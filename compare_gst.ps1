$ErrorActionPreference = 'Stop'

# Paths
$htmlPath = Join-Path $PSScriptRoot 'GST.html'
$imgJsonPath = Join-Path $PSScriptRoot 'images_dataset.json'
$outPath = Join-Path $PSScriptRoot 'comparison_result.json'

if (-not (Test-Path $htmlPath)) { throw "GST.html not found at $htmlPath" }
if (-not (Test-Path $imgJsonPath)) { throw "images_dataset.json not found at $imgJsonPath" }

# Load inputs
$html = Get-Content -Raw -Path $htmlPath
$imgItems = Get-Content -Raw -Path $imgJsonPath | ConvertFrom-Json

function Normalize([string]$s){
  if (-not $s) { return '' }
  $t = $s.ToLower() -replace '[^a-z0-9]+',' '
  $t = $t.Trim() -replace '\s+',' '
  return $t
}

# Extract rows from HTML (name + old + new)
$regex = '<li class="dh-row".*?<span class="dh-name">(.*?)</span>.*?<span class="old">(\d+)%</span>.*?<span class="new">(\d+)%</span>'
$rows = [System.Text.RegularExpressions.Regex]::Matches($html, $regex, [System.Text.RegularExpressions.RegexOptions]::Singleline)

$htmlItems = @()
foreach($m in $rows){
  $name = $m.Groups[1].Value
  $from = [int]$m.Groups[2].Value
  $to   = [int]$m.Groups[3].Value
  $obj = [pscustomobject]@{
    description = $name
    from = $from
    to = $to
    change_pp = $to - $from
    trend = if ($to - $from -gt 0) { 'expensive' } elseif ($to - $from -lt 0) { 'cheaper' } else { 'no_change' }
    source = 'GST.html'
    key = (Normalize $name)
  }
  $htmlItems += $obj
}

# Index HTML items by normalized key
$htmlIndex = @{}
foreach($h in $htmlItems){ $htmlIndex[$h.key] = $h }

# Prepare comparison
$matches = @()
$mismatches = @()
$missingInHtml = @()

function Jaccard($a, $b){
  $as = ($a -split ' ') | Where-Object { $_ -ne '' } | Select-Object -Unique
  $bs = ($b -split ' ') | Where-Object { $_ -ne '' } | Select-Object -Unique
  $inter = @($as | Where-Object { $bs -contains $_ }).Count
  $union = @($as + $bs | Select-Object -Unique).Count
  if ($union -eq 0) { return 0 }
  return [double]$inter / [double]$union
}

foreach($img in $imgItems){
  $imgKey = Normalize $img.description
  $img | Add-Member -NotePropertyName key -NotePropertyValue $imgKey -Force
  $h = $null
  if ($htmlIndex.ContainsKey($imgKey)){
    $h = $htmlIndex[$imgKey]
  } else {
    # Fuzzy match by Jaccard similarity
    $best = $null
    $bestScore = 0
    foreach($cand in $htmlItems){
      $score = Jaccard $imgKey $cand.key
      if ($score -gt $bestScore){ $bestScore = $score; $best = $cand }
    }
    if ($bestScore -ge 0.5 -or $best.key.Contains($imgKey) -or $imgKey.Contains($best.key)){
      $h = $best
    }
  }
  if ($h -ne $null){
    $same = ($img.from -eq $h.from) -and ($img.to -eq $h.to)
    $entry = [pscustomobject]@{
      key = $imgKey
      description_images = $img.description
      description_html = $h.description
      images_from = $img.from
      images_to = $img.to
      html_from = $h.from
      html_to = $h.to
      delta_from_pp = $h.from - $img.from
      delta_to_pp = $h.to - $img.to
      matches_exact = $same
    }
    if ($same) { $matches += $entry } else { $mismatches += $entry }
  } else {
    $missingInHtml += [pscustomobject]@{ key=$imgKey; description=$img.description; from=$img.from; to=$img.to; source=$img.source }
  }
}

# Extra entries present only in HTML
$imgKeys = $imgItems | ForEach-Object { Normalize $_.description }
$extraInHtml = $htmlItems | Where-Object { ($imgKeys -notcontains $_.key) } | Select-Object description, from, to, change_pp, trend, source, key

$report = [pscustomobject]@{
  summary = [pscustomobject]@{
    images_total = $imgItems.Count
    html_total = $htmlItems.Count
    matched = $matches.Count + $mismatches.Count
    exact_matches = $matches.Count
    mismatches = $mismatches.Count
    missing_in_html = $missingInHtml.Count
    extra_in_html = $extraInHtml.Count
  }
  mismatches = $mismatches
  missing_in_html = $missingInHtml
  extra_in_html = $extraInHtml
}

$report | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 -Path $outPath

Write-Host "Comparison complete. Wrote $outPath" -ForegroundColor Green
Write-Output ($report | ConvertTo-Json -Depth 4)
