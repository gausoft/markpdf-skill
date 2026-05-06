# MarkPDF — Agent Skill

> Convert Markdown to **premium-themed PDFs**, slide decks (PPTX or PDF), styled HTML, and shareable links — from any AI coding agent.

This is the official skill for [MarkPDF](https://markpdf.app), built on the open [Agent Skills standard](https://agentskills.io). It works across **Claude Code**, **Cursor**, **GitHub Copilot**, **VS Code**, and the rest of the [skills.sh](https://skills.sh) ecosystem.

## Install

Pick the flag that matches your agent:

```bash
npx skills add gausoft/markpdf-skill -a claude-code   # Claude Code
npx skills add gausoft/markpdf-skill -a cursor        # Cursor
npx skills add gausoft/markpdf-skill -a copilot       # GitHub Copilot
npx skills add gausoft/markpdf-skill -a vscode        # VS Code
```

See [skills.sh](https://skills.sh) for the full list of supported agents.

## Prerequisites

The skill drives the **MarkPDF MCP server**. Configure it for your agent before installing — setup snippets for Claude Code, Cursor, and others:

👉 **<https://markpdf.app/integrations/mcp>**

No signup needed for a trial token — `whoami` accepts a free token and grants 2 exports/day. Pro keys (LTD $19) unlock unlimited exports + all 15 themes + custom fonts.

## What this skill does

| When you ask… | The agent will… |
|---|---|
| "Make a PDF from this markdown" | Pick the right theme, render, generate a clean share link, deliver both |
| "Turn this into a pitch deck" | Use Marp slides + the `aurora` theme, return PDF or PPTX |
| "Share this with alice@example.com" | Email-gate the share link with magic-link auth |
| "Style it like a McKinsey report" | Pro theme `consul` (or fall back to `paper` on free tier) |
| "Use my brand color #ff5722" | Customize accent through `customizations.accent` |
| "Just give me the file" | Skip the share link, surface the direct download |

The skill bundles **8 reference recipes** (academic paper, pitch deck, executive report, password-protected share, custom CSS, etc.) and **OS-aware auto-open** so the result lands directly in your browser.

## Concrete example — Claude Code

After installing both the skill and the MCP server, here's a real session:

**1. Install**
```bash
# Add the MarkPDF MCP server (one-time)
claude mcp add --transport http markpdf https://markpdf.app/mcp \
  --header "Authorization: Bearer mpf_trial_xxx"   # get one at markpdf.app/integrations/mcp

# Add the skill
npx skills add gausoft/markpdf-skill -a claude-code
```

**2. Restart Claude Code, then drop a markdown file into the chat:**

> Take this `release-notes.md` and turn it into a polished PDF using the consul theme. Share it with `alice@acme.com` so she gets a magic link.

**3. What Claude does behind the scenes:**

```
1. whoami                          → tier=free, dailyUsed=0/2
2. convert_markdown_to_pdf         → theme=consul, returns dl URL
3. create_share_link               → kind=doc, accessEmails=[alice@acme.com]
4. open https://markpdf.app/d/x9k  → auto-opens in your default browser
```

**4. Output you see in the chat:**

> ✅ PDF ready. Share link (1 click): **https://markpdf.app/d/x9k7abc**
> *(Direct download if you need the file: `https://r2.markpdf.app/...`)*
> 🔒 Restricted — only `alice@acme.com` can open it (magic link sent).
> Quota: 1/2 used today, 1 left (resets at 00:00 UTC).

The browser opens to the share page automatically. Alice gets the email.

## Concrete example — other agents

The flow is identical for every agent — only the install commands and the chat UI change.

<details>
<summary><b>Cursor</b></summary>

```bash
npx skills add gausoft/markpdf-skill -a cursor
```

Add the MCP server to Cursor's settings (`cmd+,` → MCP) following <https://markpdf.app/integrations/mcp#cursor>. Then in any chat: *"Make a PDF of this markdown using the consul theme."*
</details>

<details>
<summary><b>GitHub Copilot</b></summary>

```bash
npx skills add gausoft/markpdf-skill -a copilot
```

MCP setup: <https://markpdf.app/integrations/mcp#copilot>. The skill plugs into Copilot Chat — same prompts work.
</details>

<details>
<summary><b>VS Code</b></summary>

```bash
npx skills add gausoft/markpdf-skill -a vscode
```

MCP setup: <https://markpdf.app/integrations/mcp#vscode>. Use VS Code's Chat panel.
</details>

<details>
<summary><b>Other agents (~50 supported)</b></summary>

The skill conforms to the open Agent Skills standard. If your agent is on [skills.sh](https://skills.sh), pass its slug to `-a`. Examples: `aider`, `goose`, `continue`, `windsurf`, `zed`.
</details>

## The 7 MCP tools

| Tool | Purpose | Quota |
|---|---|---|
| `whoami` | Tier + remaining quota | Free |
| `list_themes` | Browse all available themes | Free |
| `redeem_license` | Upgrade a free token to Pro in-place | Free |
| `convert_markdown_to_html` | Iterate styling without burning quota | Free |
| `convert_markdown_to_pdf` | Final document export | Counts toward daily quota |
| `convert_markdown_to_slides` | Slide deck (PDF or PPTX) | Counts toward daily quota |
| `create_share_link` | Default delivery channel — clean `markpdf.app/d/…` URL | Free |

## Themes — gallery

A taste of what the skill produces. **Free** themes work with any token; **Pro** unlock with a license key (LTD $19).

<table>
  <tr>
    <td align="center" width="33%">
      <img src="previews/paper.png" alt="Paper theme — editorial longform" width="100%"><br>
      <b>Paper</b> · <sub>Free</sub><br>
      <sub>Editorial longform · Lora</sub>
    </td>
    <td align="center" width="33%">
      <img src="previews/slate.png" alt="Slate theme — Linear/Notion clean" width="100%"><br>
      <b>Slate</b> · <sub>Free</sub><br>
      <sub>Linear/Notion clean · Inter</sub>
    </td>
    <td align="center" width="33%">
      <img src="previews/consul.png" alt="Consul theme — corporate consulting" width="100%"><br>
      <b>Consul</b> · <sub>Pro</sub><br>
      <sub>Corporate / consulting</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="33%">
      <img src="previews/aurora.png" alt="Aurora theme — startup pitch" width="100%"><br>
      <b>Aurora</b> · <sub>Pro</sub><br>
      <sub>Startup pitch · vibrant</sub>
    </td>
    <td align="center" width="33%">
      <img src="previews/obsidian.png" alt="Obsidian theme — luxury dark" width="100%"><br>
      <b>Obsidian</b> · <sub>Pro</sub><br>
      <sub>Luxury / premium dark</sub>
    </td>
    <td align="center" width="33%">
      <img src="previews/midnight.png" alt="Midnight theme — dark mode tech" width="100%"><br>
      <b>Midnight</b> · <sub>Pro</sub><br>
      <sub>Dark mode tech / dev</sub>
    </td>
  </tr>
</table>

Plus `ivory` (free), `scholar`, `hertz`, `folio`, `academic`, `quill`, `prose`, `rosepine`, `horizon`. **15 themes total** — see the [full catalog](https://markpdf.app/themes) or run `list_themes` from your agent.

## Bundle structure

```
markpdf-skill/
├── SKILL.md              # Manifest + golden rules + variation playbook
├── references/           # On-demand docs (workflows, themes, slides, customization, frontmatter)
├── examples/             # Ready-to-render samples (academic, pitch-deck, report)
├── scripts/              # render.sh (curl fallback) + open-url.sh (OS-aware)
└── previews/             # Theme gallery PNGs (rendered from a deterministic sample)
```

## Updating

Re-run the install command — `skills add` overwrites the existing copy with the latest from this repo:

```bash
npx skills add gausoft/markpdf-skill -a <your-agent>
```

## License

[MIT](./LICENSE) — copyright © Gauthier Eholoum.

## Links

- 🌐 Web app: <https://markpdf.app>
- 📚 MCP setup: <https://markpdf.app/integrations/mcp>
- 🎨 Themes: <https://markpdf.app/themes>
- ⭐ Skill listing: <https://skills.sh>
