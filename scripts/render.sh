#!/usr/bin/env bash
# render.sh — Curl fallback for the MarkPDF MCP server.
#
# Use this when the user can't (or won't) install the MCP client.
# Requires: a MarkPDF MCP token. Get one at:
#   - Free trial: curl -X POST https://markpdf.app/api/mcp/trial-token
#   - Pro: https://markpdf.app/account/mcp (after upgrading)
#
# Usage:
#   ./render.sh INPUT.md OUTPUT.pdf [theme]
#
# Examples:
#   ./render.sh report.md report.pdf
#   ./render.sh report.md report.pdf consul
#   MARKPDF_TOKEN=mpf_live_xxx ./render.sh report.md report.pdf aurora
#
# Env vars:
#   MARKPDF_TOKEN   Required. Bearer token for the MCP server.
#   MARKPDF_HOST    Override the host. Default: https://markpdf.app

set -euo pipefail

INPUT="${1:?Usage: $0 INPUT.md OUTPUT.pdf [theme]}"
OUTPUT="${2:?Usage: $0 INPUT.md OUTPUT.pdf [theme]}"
THEME="${3:-slate}"
HOST="${MARKPDF_HOST:-https://markpdf.app}"

if [ -z "${MARKPDF_TOKEN:-}" ]; then
  echo "❌ MARKPDF_TOKEN env var is required."
  echo "   Get a free trial token:"
  echo "     curl -X POST $HOST/api/mcp/trial-token"
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo "❌ Input file not found: $INPUT"
  exit 1
fi

# Read markdown and JSON-encode it for the MCP request body.
MARKDOWN_JSON=$(jq -Rs . < "$INPUT")

# Build a JSON-RPC 2.0 call to the convert_markdown_to_pdf tool.
PAYLOAD=$(cat <<EOF
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "convert_markdown_to_pdf",
    "arguments": {
      "markdown": $MARKDOWN_JSON,
      "theme": "$THEME"
    }
  }
}
EOF
)

echo "→ Rendering $INPUT with theme '$THEME'..."

RESPONSE=$(curl -sS -X POST "$HOST/mcp" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $MARKPDF_TOKEN" \
  --data "$PAYLOAD")

# Extract the base64 PDF from the JSON-RPC response and decode it.
# The MCP convert tools return a `content` array with a base64 blob.
PDF_B64=$(echo "$RESPONSE" | jq -r '.result.content[]? | select(.type=="resource") | .resource.blob // empty')

if [ -z "$PDF_B64" ] || [ "$PDF_B64" = "null" ]; then
  echo "❌ MCP call failed. Response:"
  echo "$RESPONSE" | jq .
  exit 1
fi

echo "$PDF_B64" | base64 --decode > "$OUTPUT"

echo "✅ Wrote $OUTPUT ($(wc -c < "$OUTPUT" | awk '{print $1}') bytes)"
