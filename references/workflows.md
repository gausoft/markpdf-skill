# Workflows Playbook

Copy-paste recipes for every common (and not-so-common) situation. Each recipe shows the exact tool calls to make, in order, and what to tell the user.

Quick navigation:
- [Default: PDF + share link + auto-open](#1-default-pdf--share-link--auto-open)
- [Default: slide deck](#2-default-slide-deck-pdf--share-link)
- [Variation: email gate](#3-variation-share-with-specific-emails)
- [Variation: password gate](#4-variation-password-protected-share)
- [Variation: brand-color customization](#5-variation-brand-color)
- [Variation: PowerPoint output](#6-variation-pptx-instead-of-pdf)
- [Variation: pure download (no share)](#7-variation-user-just-wants-the-file)
- [Variation: preview only](#8-variation-iterate-styling-without-burning-quota)
- [Variation: in-place Pro upgrade](#9-variation-in-place-pro-upgrade)
- [Variation: Pro letterhead](#10-variation-letterhead--header--footer)
- [Edge cases](#edge-cases)

---

## 1. Default: PDF + share link + auto-open

**Trigger**: "make a PDF", "export this", "turn this into a doc", or anything where the user gives Markdown and wants a polished output.

```jsonc
// Step 1: who am I? (skip if already done this session)
{ "tool": "whoami" }

// Step 2: render the PDF (consumes 1 export from daily quota — resets 00:00 UTC)
{
  "tool": "convert_markdown_to_pdf",
  "input": {
    "markdown": "<full markdown including frontmatter>",
    "theme": "slate"            // pick from intent → theme map
  }
}

// Step 3: create a clean share link (free, no quota)
{
  "tool": "create_share_link",
  "input": {
    "markdown": "<same markdown>",
    "theme": "slate",
    "kind": "doc"
  }
}
// → { "fullUrl": "https://markpdf.app/d/abc123", ... }
```

Then in your reply to the user:

> ✅ PDF ready. Share link (1 click): **https://markpdf.app/d/abc123**
>
> *(Direct download if you need the file: <secondary URL>)*
>
> Quota: 1/2 used today, 1 left (resets at 00:00 UTC).

**If you have shell access**, before/after the message run:

```bash
# Detect OS and open
case "$(uname -s)" in
  Darwin)  open "https://markpdf.app/d/abc123" ;;
  Linux)   xdg-open "https://markpdf.app/d/abc123" 2>/dev/null || true ;;
  CYGWIN*|MINGW*|MSYS*) start "" "https://markpdf.app/d/abc123" ;;
esac
```

Or use the helper: `bash scripts/open-url.sh "https://markpdf.app/d/abc123"`.

---

## 2. Default: slide deck (PDF) + share link

**Trigger**: "pitch deck", "slides", "presentation", "Marp", "16:9 deck".

```jsonc
{ "tool": "whoami" }

{
  "tool": "convert_markdown_to_slides",
  "input": {
    "markdown": "<deck markdown with --- separators>",
    "format": "pdf",
    "slideTheme": "aurora",      // or "slate" if free tier
    "ratio": "16:9",
    "paginate": true
  }
}

{
  "tool": "create_share_link",
  "input": {
    "markdown": "<same deck markdown>",
    "theme": "aurora",
    "kind": "slides"             // ← important for slide rendering on the share page
  }
}
```

Reply pattern:
> 🎬 Deck ready (12 slides, 16:9). View online: **https://markpdf.app/d/xyz**

---

## 3. Variation: share with specific emails

**Trigger**: "send to alice@x.com", "share with the design team (a@x, b@x)", "for client review only".

```jsonc
{
  "tool": "create_share_link",
  "input": {
    "markdown": "<markdown>",
    "theme": "consul",
    "kind": "doc",
    "accessEmails": ["alice@example.com", "bob@example.com"]
  }
}
```

Recipients receive a magic-link email. Tell the user:

> 🔒 Restricted share link created. **alice@example.com** and **bob@example.com** will get a magic link to view it. Anyone else gets blocked.

**Cap**: max 25 emails. If user lists more, batch into multiple share links or suggest password mode instead.

---

## 4. Variation: password-protected share

**Trigger**: "password-protect it", "gate with hunter2", "private link".

```jsonc
{
  "tool": "create_share_link",
  "input": {
    "markdown": "<markdown>",
    "theme": "slate",
    "kind": "doc",
    "password": "hunter2"
  }
}
```

> 🔐 Share link with password gate. URL: https://markpdf.app/d/abc — visitors must enter `hunter2` to view.

**Don't echo strong passwords back in plain text on shared screens.** If the user typed it in a private chat that's fine; if you generated it, surface it once and warn them to save it.

---

## 5. Variation: brand color

**Trigger**: "use #ff5722", "match our brand", "blue accent".

Free tier ✅ — `accent` is a free knob.

```jsonc
{
  "tool": "convert_markdown_to_pdf",
  "input": {
    "markdown": "<markdown>",
    "theme": "slate",
    "customizations": { "accent": "#ff5722" }
  }
}
```

Combine with `fontSize` (13–18) and `lineHeight` (1.5–2.2) for typography tweaks. All free.

For **custom fonts** (`fontBody`, `fontHeading`, `fontMono`) → Pro only. Check `whoami` first.

---

## 6. Variation: PPTX instead of PDF

**Trigger**: "PowerPoint", "editable slides", ".pptx", "send to client to edit".

```jsonc
{
  "tool": "convert_markdown_to_slides",
  "input": {
    "markdown": "<deck markdown>",
    "format": "pptx",
    "slideTheme": "consul",
    "pptxMetadata": {
      "title": "Q4 Roadmap",
      "author": "Acme Inc.",
      "subject": "Quarterly planning deck"
    }
  }
}
```

⚠️ Tell the user: *"Slides are rendered as 2× screenshots inside the PPTX — text is not editable in PowerPoint. If they need to edit text, deliver the source Markdown alongside."*

---

## 7. Variation: user just wants the file

**Trigger**: "give me the download link", "I just need the file", "no share, just the PDF".

Skip `create_share_link`. Surface the raw download URL from the convert call:

```jsonc
{ "tool": "convert_markdown_to_pdf", "input": { ... } }
```

Reply with the `download.url` from the response. Don't pretty-format the URL — paste it raw, in a code block, so it copies cleanly.

---

## 8. Variation: iterate styling without burning quota

**Trigger**: "let me see what it looks like first", "preview", "try a few themes".

Use `convert_markdown_to_html` — free, unlimited:

```jsonc
{
  "tool": "convert_markdown_to_html",
  "input": { "markdown": "<md>", "theme": "consul" }
}
```

Returns the full HTML inline. You can show snippets, compare themes, tweak `customizations`, then commit to a real PDF when the user is happy.

**Pro tip**: when iterating, render 2–3 themes in parallel with HTML calls, present them as choices, *then* do the single PDF call.

---

## 9. Variation: in-place Pro upgrade

**Trigger**: "I just bought Pro, here's my key MPDF-xxx", "I have a license", "upgrade me".

```jsonc
{
  "tool": "redeem_license",
  "input": {
    "licenseKey": "MPDF-xxxxxxxx",
    "label": "Claude Code laptop"   // any human name
  }
}
// → { "token": "mpdf_pro_...", "setupHint": "claude mcp add ..." }
```

Then tell the user, **literally**:

> ✨ Pro token issued. To activate it:
>
> 1. Run: `claude mcp remove markpdf`
> 2. Run: `claude mcp add --transport http markpdf https://markpdf.app/mcp --header "Authorization: Bearer mpdf_pro_xxx"`
> 3. Restart Claude Code (`exit` then `claude`)
> 4. Verify: ask me to run `whoami` — it should show `tier: pro`.

For Cursor/Claude Desktop, point them at https://markpdf.app/integrations/mcp for the right snippet.

---

## 10. Variation: letterhead / header / footer

**Trigger**: "company letterhead", "page numbers", "footer with date".

Pro only. Add `pageOptions`:

```jsonc
{
  "tool": "convert_markdown_to_pdf",
  "input": {
    "markdown": "<md>",
    "theme": "consul",
    "pageOptions": {
      "pageFormat": "Letter",
      "margin": { "top": "25mm", "right": "18mm", "bottom": "22mm", "left": "18mm" },
      "headerTemplate": "<div style='font-size:9pt;color:#888;text-align:right;width:100%;padding-right:18mm;'><span class='title'></span></div>",
      "footerTemplate": "<div style='font-size:9pt;color:#888;text-align:center;width:100%;'>Page <span class='pageNumber'></span> / <span class='totalPages'></span></div>"
    }
  }
}
```

Available placeholders inside templates: `title`, `pageNumber`, `totalPages`, `date`, `url`. See `references/customization.md`.

---

## Edge cases

### Free user requests a Pro theme

Don't fail the request — translate it gracefully.

> "consul is a Pro theme. Want me to:
> (a) render it now in `paper` (closest free equivalent), or
> (b) you upgrade first (1 min via `redeem_license` if you have a key)?"

### User has both a free token AND mentions a license key

If the license is valid, default to upgrading **before** spending free quota:

1. Call `redeem_license`
2. Tell the user to swap their token
3. Wait for them to restart and re-prompt
4. Then do the export with full Pro powers

### Quota exhausted mid-session

```jsonc
// whoami shows dailyUsed: 2, remaining: 0
```

Don't try the export. Tell the user:

> Your free quota is fully used today. It resets at 00:00 UTC (`whoami.dailyResetAt`). Options:
> - Wait for the daily reset
> - Upgrade ($5/mo, $45/yr or $19 LTD) — instant via `redeem_license` if you already have a key
> - Use `convert_markdown_to_html` to preview without consuming quota

### User pastes a 5MB markdown file

The PDF tool caps at 2MB, slides at 1MB. Suggest:

- Stripping embedded base64 images (use `https://` URLs instead)
- Splitting into multiple documents (chapter-per-file)
- For massive academic papers: drop the bibliography to a separate file

### Headless / CI environment

Skip the `open` step. Return the share URL clearly so it can be parsed by scripts. Example reply:

```
SHARE_URL=https://markpdf.app/d/abc123
DOWNLOAD_URL=https://markpdf.app/api/d/xyz.pdf
QUOTA_REMAINING=2
```

### Multiple deliverables in one ask

User says: *"Make a PDF AND slides AND share with my team"*. Run all three tool families:

```
1. whoami
2. convert_markdown_to_pdf       (theme: consul)
3. convert_markdown_to_slides    (slideTheme: consul, format: pptx)
4. create_share_link             (kind: doc, accessEmails: [...])
5. create_share_link             (kind: slides, accessEmails: [...])
6. Reply with both share links + both download links + quota
```

Two exports consumed. Warn before running if free user only has 1 left.
