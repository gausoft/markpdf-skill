# Customization Reference

Every export tool accepts the same `customizations` object plus optional `overrideCSS` and `pageOptions`. Tier rules apply.

## `customizations` object

| Field | Type | Range / Format | Tier | Effect |
|---|---|---|---|---|
| `accent` | string | hex `#rrggbb` or `#rgb` | **Free** | Repaints headings, links, table headers, list markers, blockquote bars |
| `fontSize` | int | 13 – 18 | **Free** | Body font size in px |
| `lineHeight` | number | 1.5 – 2.2 | **Free** | Body line-height (unitless) |
| `fontBody` | string | Google Font or Monaspace family | **Pro** | Body text font |
| `fontHeading` | string | Google Font or Monaspace family | **Pro** | Headings font |
| `fontMono` | string | Google Font or Monaspace family | **Pro** | Code blocks font |

### Font name rules

- Letters, digits, spaces, `_` and `-` only (regex: `^[A-Za-z][A-Za-z0-9 _-]{1,63}$`)
- Examples: `"Inter"`, `"JetBrains Mono"`, `"Monaspace Neon"`, `"IBM Plex Sans"`
- Fonts are auto-loaded from Google Fonts (and Monaspace served from MarkPDF). No need to add `<link>` tags.

### Example

```jsonc
"customizations": {
  "accent": "#0d9488",
  "fontSize": 16,
  "lineHeight": 1.7,
  "fontBody": "Inter",            // Pro
  "fontHeading": "Fraunces",      // Pro
  "fontMono": "JetBrains Mono"    // Pro
}
```

## `overrideCSS` — raw CSS escape hatch (Pro only)

Appended **after** the theme stylesheet and `customizations` CSS. Use for tweaks the structured fields can't express.

- Max 50 KB
- `@import` URLs allowed only from: `fonts.googleapis.com`, `fonts.gstatic.com`, or the `assetBaseUrl` host
- No `<script>`, no JS execution

```css
/* Increase H1 weight */
h1 { font-weight: 900; letter-spacing: -0.04em; }

/* Brand-color blockquotes */
blockquote {
  border-left-color: #ff5722;
  background: #fff3e0;
}

/* Add a page break before every H2 */
h2 { page-break-before: always; }
```

### For slides
Marp scopes everything to `section`. Prefix every selector:

```css
section h1 { font-size: 80px; }    /* ✅ */
h1 { font-size: 80px; }            /* ❌ Marp's default wins */
```

## `pageOptions` — PDF layout (Pro only, PDF tool only)

Subset of Puppeteer `PDFOptions`:

| Field | Type | Default | Notes |
|---|---|---|---|
| `pageFormat` | `A4` \| `A3` \| `A5` \| `Letter` \| `Legal` \| `Tabloid` | `A4` | |
| `landscape` | boolean | `false` | |
| `margin` | `{top, right, bottom, left}` | theme-defined | Each `0` or `<n><px\|mm\|cm\|in>`, capped at 50 mm |
| `headerTemplate` | HTML string (max 4 KB) | — | Sanitized: only `span/div/b/i/em/strong/small/br/p/img` allowed |
| `footerTemplate` | HTML string (max 4 KB) | — | Same sanitization |
| `displayHeaderFooter` | boolean | `false` | Auto-true if either template provided |

### Header/footer placeholders

Chromium recognizes these inside header/footer templates (use as `<span class="…"></span>`):

| Class | Renders |
|---|---|
| `title` | Document title |
| `pageNumber` | Current page |
| `totalPages` | Total pages |
| `date` | Current date |
| `url` | Page URL |

### Example

```jsonc
"pageOptions": {
  "pageFormat": "Letter",
  "landscape": false,
  "margin": { "top": "20mm", "right": "18mm", "bottom": "22mm", "left": "18mm" },
  "headerTemplate": "<div style='font-size:9pt;color:#888;width:100%;text-align:right;padding-right:18mm;'><span class='title'></span></div>",
  "footerTemplate": "<div style='font-size:9pt;color:#888;width:100%;text-align:center;'>Page <span class='pageNumber'></span> / <span class='totalPages'></span></div>"
}
```

## Tier enforcement

When a free token sends Pro fields:

```json
{
  "error": "Custom fonts (fontBody, fontHeading) require a Pro license. Upgrade at https://markpdf.app/pricing."
}
```

**Always call `whoami` first** if unsure of tier. Strip Pro fields gracefully on free tokens, or surface the upgrade URL.

## When to use `customizations` vs `overrideCSS`

| Need | Use |
|---|---|
| Brand color | `customizations.accent` |
| Bigger text | `customizations.fontSize` |
| Custom font | `customizations.fontBody` (Pro) |
| Page break before H2 | `overrideCSS` |
| Multi-column layout | `overrideCSS` |
| Tweak code block padding | `overrideCSS` |
| Letterhead with logo | `pageOptions.headerTemplate` (Pro) |
