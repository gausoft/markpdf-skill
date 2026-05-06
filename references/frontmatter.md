# Frontmatter Reference

Every Markdown document accepted by MarkPDF can begin with a YAML frontmatter block. Themes use it for cover pages, headers, PDF metadata, and PPTX core properties.

## Syntax

```markdown
---
title: Q4 Strategy Review
subtitle: Board Meeting Prep
author: Jane Doe
date: 2025-10-15
description: Quarterly business review covering revenue, churn, and roadmap.
keywords: [strategy, q4, board, finance]
version: "1.2"
cover: https://markpdf.app/covers/abstract-blue.jpg
---

# Document body starts here
```

The `---` block must be the **very first thing** in the file. No blank line above.

## Supported keys

| Key | Type | Used by | Notes |
|---|---|---|---|
| `title` | string | All themes (cover, PDF meta, PPTX title) | First H1 used as fallback |
| `subtitle` | string | Cover pages | |
| `author` | string | Cover pages, PDF meta, PPTX `author` | Alias: `authors` |
| `date` | string or `YYYY-MM-DD` | Cover pages | YAML dates auto-formatted |
| `description` | string | PDF meta `description`, `<meta>` tag | Aliases: `summary`, `subtitle` |
| `keywords` | array or comma-string | PDF meta, `<meta>` tag | Alias: `tags` |
| `version` | string | Cover pages | Quote numeric versions: `version: "1.0"` |
| `cover` | URL string | Cover image on title page | Use `https://` URLs |

## Slide-specific frontmatter

When the markdown is a deck, add these (see `references/slides.md`):

```yaml
---
marp: true
theme: aurora
size: 16:9
paginate: true
title: Q4 Roadmap
author: Acme Inc.
---
```

## Best practices

- **Always set `title` and `author`** — they end up in the PDF metadata, the browser tab, and PPTX core props. Better SEO + better file management for the user.
- **Quote any value containing `:` or starting with a digit.** YAML gotcha.
  ```yaml
  version: "1.0"            # ✅
  date: "2025-10-15"        # ✅ (also "2025/10/15" works as YAML date)
  title: "Pricing: Q4"      # ✅
  ```
- **Use `keywords` as an array** for clarity:
  ```yaml
  keywords: [finance, board, q4]
  ```
- **Don't put HTML in frontmatter values** — they get HTML-escaped before insertion into `<meta>` tags.
- **Cover image**: prefer landscape 16:9 or A4-portrait dimensions. Themes letterbox/contain rather than crop.

## What overrides what

When you call `convert_markdown_to_pdf` with a `metadata` argument:

```
metadata (MCP arg)  >  frontmatter  >  inferred from H1
```

So a `metadata.title` in the tool call wins over a frontmatter `title:`, which itself wins over the first `# H1` in the body.
