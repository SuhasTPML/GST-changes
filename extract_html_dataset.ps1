$ErrorActionPreference = 'Stop'

$htmlPath = Join-Path $PSScriptRoot 'GST.html'
if (-not (Test-Path $htmlPath)) { throw "GST.html not found at $htmlPath" }

$outPath = Join-Path $PSScriptRoot 'html_dataset.json'

# Read HTML (keep as raw to allow regex over multiple lines)
$html = Get-Content -Raw -Path $htmlPath

function CleanText([string]$s){
  if (-not $s) { return '' }
  $decoded = [System.Net.WebUtility]::HtmlDecode($s)
  $decoded = $decoded -replace '\s+', ' '
  return $decoded.Trim()
}

# Find rows: description + old + new
$regex = '<li class="dh-row".*?<span class="dh-name">(.*?)</span>.*?<span class="old">(\d+)%</span>.*?<span class="new">(\d+)%</span>'
$matches = [System.Text.RegularExpressions.Regex]::Matches($html, $regex, [System.Text.RegularExpressions.RegexOptions]::Singleline)

$items = @()
foreach($m in $matches){
  $name = CleanText $m.Groups[1].Value
  $from = [int]$m.Groups[2].Value
  $to   = [int]$m.Groups[3].Value
  $change = $to - $from
  $trend = if ($change -gt 0) { 'expensive' } elseif ($change -lt 0) { 'cheaper' } else { 'no_change' }
  $items += [pscustomobject]@{
    description = $name
    from = $from
    to = $to
    change_pp = $change
    trend = $trend
    source = 'GST.html'
  }
}

$items | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 -Path $outPath
Write-Host "Extracted $($items.Count) rows to $outPath" -ForegroundColor Green

