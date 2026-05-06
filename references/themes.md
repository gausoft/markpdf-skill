# MarkPDF Themes — Full Catalog

15 PDF themes + 13 slide themes. Free tier unlocks 3 of each; Pro unlocks all.

## How to choose

> Match the **document's voice**, not its content. Same Markdown can be `slate` (memo), `consul` (board deck), or `obsidian` (luxury report). The theme IS the brand.

## PDF themes

### Free tier

| Slug | Name | Font | Style | Use it for |
|---|---|---|---|---|
| `slate` | Slate | Manrope | Linear / Notion | Internal docs, dev notes, technical reports, changelogs. **Default — pick this when in doubt.** |
| `paper` | Paper | Lora | Editorial longform | Essays, articles, blog exports, opinion pieces, longform writing |
| `ivory` | Ivory | Shippori Mincho | Japanese minimalism | Journals, personal writing, mindful/lifestyle content, poetry |

### Pro tier

| Slug | Name | Font | Style | Use it for |
|---|---|---|---|---|
| `midnight` | Midnight | Space Grotesk | Deep indigo dark | Dev docs, technical notes, dark-mode reading. Catppuccin Mocha syntax colors. |
| `consul` | Consul | Libre Baskerville | BCG / McKinsey report | Consulting reports, board memos, formal proposals, RFPs |
| `aurora` | Aurora | Fraunces + Outfit | Scandinavian fresh | Modern reports, creative briefs, startup updates with a calm Nordic feel |
| `scholar` | Scholar | EB Garamond | Academic journal | Research papers, theses, citations-heavy text. Justified, indented paragraphs. |
| `obsidian` | Obsidian | Cormorant Garamond | Luxury editorial dark | Luxury brands, fashion, hospitality, premium editorial content. Gold accents. |
| `hertz` | Hertz | Space Grotesk + Manrope | Dark teal & amber | Dev docs at night, technical specs, changelogs with a developer feel |
| `folio` | Folio | Playfair + Baskerville | Literary collection | Memoirs, essays collections, literary criticism, anthologies. Burgundy accents. |
| `academic` | Academic | Source Serif 4 + Manrope | STEM research paper | Modern scientific reports. Ruled tables, abstract box, numbered sections. |
| `quill` | Quill | Caveat + Crimson Pro | Creative writing | Fiction, journals, poetry, storytelling. Handwritten headings + drop caps. |
| `prose` | Prose | Newsreader + Manrope | Modern newsletter | Newsletters, longform blog → PDF, warm terracotta tones |
| `rosepine` | Rosé Pine | Outfit + Crimson Pro | Poetic dark | Journals, creative writing, night sessions. Soft mauve palette. |
| `horizon` | Horizon | Plus Jakarta + Source Serif 4 | Warm sunset light | Creative reports, lifestyle, wellness, energetic brands. Pink/coral accents. |

## Slide themes (Marp-compatible)

### Free tier

| Slug | Style | Use it for |
|---|---|---|
| `slate` | Notion-clean light | Internal product reviews, sprint demos, tech talks |
| `paper` | Warm editorial light | Conference talks, lecture notes |
| `ivory` | Minimalist light | Workshops, calm presentations |

### Pro tier

| Slug | Style | Use it for |
|---|---|---|
| `midnight` | Indigo dark | Dev keynotes, tech meetups |
| `consul` | Corporate report deck | Client decks, board presentations, consulting |
| `aurora` | Scandinavian fresh | Pitch decks, startup investor updates, product launches |
| `scholar` | Academic | Conference papers, university lectures |
| `obsidian` | Luxury dark | Brand reveals, fashion / hospitality pitches |
| `hertz` | Dark teal + amber | Technical demos, engineering all-hands |
| `folio` | Literary | Bookish brands, publishing |
| `academic` | Modern STEM | Scientific defenses, journal presentations |
| `quill` | Handwritten creative | Creative agency pitches, storytelling |
| `prose` | Newsletter feel | Editorial keynotes, content team reviews |
| `rosepine` | Soft poetic dark | Late-night creative sessions, writing workshops |
| `horizon` | Warm sunset | Wellness, lifestyle launches, design pitches |

## Mapping user intents → theme

| User says… | PDF | Slides |
|---|---|---|
| "Make it look like a Notion doc" | `slate` | `slate` |
| "Like a McKinsey/BCG report" | `consul` | `consul` |
| "Investor pitch / startup deck" | `aurora` | `aurora` |
| "Scientific paper" | `academic` or `scholar` | `academic` |
| "Dark mode for devs" | `midnight` or `hertz` | `midnight` or `hertz` |
| "Luxury / premium feel" | `obsidian` | `obsidian` |
| "Newsletter / editorial" | `prose` | `prose` |
| "Creative / handwritten / fun" | `quill` | `quill` |
| "Calm / minimalist / Japanese" | `ivory` | `ivory` |
| "Memoir / essays collection" | `folio` | `folio` |

## Tips

- The accent color in each theme can be overridden via `customizations.accent` (free tier OK). Useful to brand-match without going full Pro.
- Slide themes apply CSS to `section` elements — Marp's container. Don't use root selectors in `overrideCSS` for slides.
- Dark themes (`midnight`, `obsidian`, `hertz`, `rosepine`) require `-webkit-print-color-adjust: exact` — already baked in. Don't wrap content in `background: white` divs.
- All themes set `@page` margins, `page-break-inside: avoid` on `pre`/`table`/headings, and `orphans/widows` rules. Don't fight them.
