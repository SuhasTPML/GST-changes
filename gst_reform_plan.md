GST Update Page — Phase-wise Implementation Plan

Principles
- Single source: embedded `gst.json` inside `GST.html`.
- Derived fields: `change_pp = to − from`, `trend` from sign.
- Self-contained: no external data requests; graceful fallback.

Phase 1 — Data + Dynamic Rendering (done)
- Embed JSON in `<script type="application/json" id="gst-data">…`.
- Render groups (Cheaper/Expensive) dynamically into `#gst-root`.
- Remove legacy static lists when render succeeds.

Phase 2 — Filters, Search, Sorting
- Add keyword search; filter by trend/sector/tags; sort by Δ/from/to/A→Z.
- Persist state in URL query for shareable views.

Phase 3 — UX, A11y, SEO
- Summary header with counts and biggest movers.
- Keyboard operable controls; WCAG AA contrast.
- Structured data: `schema.org/Dataset` with `dateModified`.

Phase 4 — Editorial Workflow
- Simple update: replace JSON content inside `#gst-data`.
- Optional snapshots as HTML comments.

How To Update
1) Open `GST.html`.
2) Replace the JSON array inside the `<script id="gst-data">` block with the latest dataset.
3) Save and reload; the page reflects changes automatically.

