#!/usr/bin/env bash
# generate-release-notes.sh — Generate a RELEASE-NOTES.md entry for a version tag using an LLM.
#
# Collects all conventional commits since the previous tag, calls the LLM,
# and inserts the new entry into RELEASE-NOTES.md immediately after the header block.
#
# Run locally or from CI (the GitHub Actions workflow at
# .github/workflows/release-notes.yml calls this script).
#
# Usage:
#   ./scripts/generate-release-notes.sh [OPTIONS]
#
# Options:
#   --version VERSION   Tag / version string, e.g. 0.5.0 or v0.5.0 (default: latest git tag)
#   --dry-run           Print the generated entry to stdout; do not modify RELEASE-NOTES.md
#   --llm               claude | github-models  (default: claude if ANTHROPIC_API_KEY is set,
#                       otherwise github-models — requires GITHUB_TOKEN)
#   --help              Show this help
#
# Required environment variables (depending on --llm):
#   ANTHROPIC_API_KEY   For --llm claude
#   GITHUB_TOKEN        For --llm github-models (also the default in GitHub Actions)
#
# Examples:
#   # Generate entry for the latest tag, insert into RELEASE-NOTES.md
#   ANTHROPIC_API_KEY=sk-ant-... ./scripts/generate-release-notes.sh
#
#   # Dry run against a specific version
#   ./scripts/generate-release-notes.sh --version 0.5.0 --dry-run
#
#   # Use GitHub Models (no extra API key needed inside GitHub Actions)
#   ./scripts/generate-release-notes.sh --llm github-models

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RELEASE_NOTES="$REPO_ROOT/RELEASE-NOTES.md"

# ── Defaults ──────────────────────────────────────────────────────────────────
VERSION=""
DRY_RUN=false
LLM=""   # resolved later

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) VERSION="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --llm)     LLM="$2";     shift 2 ;;
    --help)
      sed -n '2,36p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# ── Resolve version ───────────────────────────────────────────────────────────
if [[ -z "$VERSION" ]]; then
  VERSION="$(git -C "$REPO_ROOT" describe --tags --abbrev=0 2>/dev/null || true)"
  if [[ -z "$VERSION" ]]; then
    echo "ERROR: No git tag found and --version not specified."
    echo "  Tag first: git tag v0.5.0 && git push origin v0.5.0"
    exit 1
  fi
fi
# Strip leading 'v' for the display version (v0.5.0 → 0.5.0)
DISPLAY_VERSION="${VERSION#v}"
DATE="$(date +%Y-%m-%d)"

# ── Resolve LLM ───────────────────────────────────────────────────────────────
if [[ -z "$LLM" ]]; then
  if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
    LLM="claude"
  elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
    LLM="github-models"
  else
    echo "ERROR: Set ANTHROPIC_API_KEY (for Claude) or GITHUB_TOKEN (for GitHub Models)."
    exit 1
  fi
fi

# ── Collect commits since previous tag ───────────────────────────────────────
PREV_TAG="$(git -C "$REPO_ROOT" tag --sort=-version:refname \
  | grep -v "^${VERSION}$" | head -1 || true)"

if [[ -n "$PREV_TAG" ]]; then
  COMMIT_RANGE="${PREV_TAG}..${VERSION}"
else
  # First release — use all commits
  COMMIT_RANGE="HEAD"
fi

COMMITS="$(git -C "$REPO_ROOT" log "$COMMIT_RANGE" \
  --format="%s" \
  --no-merges \
  | grep -E '^(feat|fix|refactor|perf|docs|chore|style|test|ci|revert|release)(\(.+\))?(!)?:' \
  || true)"

if [[ -z "$COMMITS" ]]; then
  echo "No conventional commits found in range $COMMIT_RANGE."
  echo "Nothing to add to RELEASE-NOTES.md."
  exit 0
fi

echo "Generating release notes for v${DISPLAY_VERSION} (${DATE})"
echo "  LLM     : $LLM"
echo "  Range   : ${PREV_TAG:-<beginning>}..${VERSION}"
echo "  Commits : $(echo "$COMMITS" | wc -l | tr -d ' ')"
echo ""

# ── Build the prompt ─────────────────────────────────────────────────────────
SYSTEM_PROMPT="$(cat "$REPO_ROOT/skills/shared/release-notes-prompt.md")"

USER_MESSAGE="VERSION: ${DISPLAY_VERSION}
DATE: ${DATE}
COMMITS:
${COMMITS}"

# ── Call the LLM ─────────────────────────────────────────────────────────────
_call_claude() {
  local response
  response="$(curl -fsSL \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "Content-Type: application/json" \
    https://api.anthropic.com/v1/messages \
    -d "$(jq -n \
      --arg sys "$SYSTEM_PROMPT" \
      --arg usr "$USER_MESSAGE" \
      '{
        model: "claude-opus-4-5",
        max_tokens: 1024,
        system: $sys,
        messages: [{ role: "user", content: $usr }]
      }')")"
  echo "$response" | jq -r '.content[0].text'
}

_call_github_models() {
  local response
  response="$(curl -fsSL \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    https://models.inference.ai.azure.com/chat/completions \
    -d "$(jq -n \
      --arg sys "$SYSTEM_PROMPT" \
      --arg usr "$USER_MESSAGE" \
      '{
        model: "gpt-4o",
        max_tokens: 1024,
        messages: [
          { role: "system", content: $sys },
          { role: "user",   content: $usr }
        ]
      }')")"
  echo "$response" | jq -r '.choices[0].message.content'
}

case "$LLM" in
  claude)         ENTRY="$(_call_claude)" ;;
  github-models)  ENTRY="$(_call_github_models)" ;;
  *)
    echo "ERROR: Unknown --llm value '$LLM'. Use: claude | github-models"
    exit 1
    ;;
esac

if [[ -z "$ENTRY" ]]; then
  echo "ERROR: LLM returned an empty response. Check your API key and quota."
  exit 1
fi

# ── Dry run output ────────────────────────────────────────────────────────────
if [[ "$DRY_RUN" == true ]]; then
  echo "────────────────────────────────────────────────────────────────────────"
  echo "DRY RUN — Generated entry (not written to RELEASE-NOTES.md):"
  echo "────────────────────────────────────────────────────────────────────────"
  echo "$ENTRY"
  echo "────────────────────────────────────────────────────────────────────────"
  exit 0
fi

# ── Guard: don't insert the same version twice ────────────────────────────────
if grep -q "## \[${DISPLAY_VERSION}\]" "$RELEASE_NOTES" 2>/dev/null; then
  echo "WARN: [${DISPLAY_VERSION}] already exists in $RELEASE_NOTES — skipping insert."
  echo "  Delete the existing entry first if you want to regenerate it."
  exit 0
fi

# ── Insert entry after the header block (first '---' separator) ───────────────
# RELEASE-NOTES.md structure:
#   Line 1-N  : title + description
#   Line N+1  : ---
#   Line N+2+ : existing entries
#
# We insert the new entry + a separator immediately after the first '---'.
SEPARATOR_LINE="$(grep -n '^---$' "$RELEASE_NOTES" | head -1 | cut -d: -f1)"

if [[ -z "$SEPARATOR_LINE" ]]; then
  # No separator found — just prepend before first ## entry
  SEPARATOR_LINE="$(grep -n '^## \[' "$RELEASE_NOTES" | head -1 | cut -d: -f1)"
  SEPARATOR_LINE=$((SEPARATOR_LINE - 1))
fi

# Build the new file: header + new entry + separator + rest
HEAD="$(head -n "$SEPARATOR_LINE" "$RELEASE_NOTES")"
TAIL="$(tail -n +"$((SEPARATOR_LINE + 1))" "$RELEASE_NOTES")"

{
  echo "$HEAD"
  echo ""
  echo "$ENTRY"
  echo ""
  echo "---"
  echo ""
  echo "$TAIL"
} > "${RELEASE_NOTES}.tmp"

mv "${RELEASE_NOTES}.tmp" "$RELEASE_NOTES"

echo "✓ Inserted [${DISPLAY_VERSION}] entry into $RELEASE_NOTES"
echo ""
echo "Review the entry, then commit:"
echo "  git add RELEASE-NOTES.md"
echo "  git commit -m \"docs(release): add release notes for ${DISPLAY_VERSION}\""
