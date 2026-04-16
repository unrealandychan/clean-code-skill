#!/usr/bin/env bash
# migrate.sh — Copy Clean Code + DDD skill files into a target project.
#
# Run with no arguments for interactive mode (asks questions before touching anything).
# Pass flags to skip the questionnaire — useful for CI and scripting.
#
# Usage:
#   ./scripts/migrate.sh [OPTIONS] [TARGET_DIR]
#
# Arguments:
#   TARGET_DIR   Destination project root (default: asked interactively, or cwd)
#
# Options:
#   --tool       copilot | claude | cursor | opencode | windsurf | generic | all
#   --lang       python | typescript | go | java | csharp | all
#   --no-lint    Skip linting configs
#   --no-hooks   Skip pre-commit hook config
#   --dry-run    Print what would be copied without touching the filesystem
#   --yes        Skip confirmation prompt (non-interactive)
#   --help       Show this help
#
# Examples:
#   # Interactive wizard (recommended first time)
#   ./scripts/migrate.sh
#
#   # Copilot skill + TypeScript linting only, no questions asked
#   ./scripts/migrate.sh --tool copilot --lang typescript ../my-project --yes
#
#   # Claude + Python, dry-run first
#   ./scripts/migrate.sh --tool claude --lang python --dry-run ../my-project
#
#   # Monorepo: just skills, no linting
#   ./scripts/migrate.sh --no-lint --no-hooks ../my-monorepo --yes

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ── Defaults ──────────────────────────────────────────────────────────────────
TOOL=""
LANG=""
SKIP_LINT=""
SKIP_HOOKS=""
DRY_RUN=false
YES=false
TARGET_DIR=""
INTERACTIVE=false   # set to true when questionnaire runs

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)     TOOL="$2";       shift 2 ;;
    --lang)     LANG="$2";       shift 2 ;;
    --no-lint)  SKIP_LINT=true;  shift ;;
    --no-hooks) SKIP_HOOKS=true; shift ;;
    --dry-run)  DRY_RUN=true;    shift ;;
    --yes|-y)   YES=true;        shift ;;
    --help)
      sed -n '2,31p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    -*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

# ── Interactive wizard (runs when no flags were passed) ───────────────────────
# Detect whether we need to ask questions: any of the key choices is still unset.
_needs_wizard=false
[[ -z "$TOOL" ]]       && _needs_wizard=true
[[ -z "$LANG" ]]       && _needs_wizard=true
[[ -z "$SKIP_LINT" ]]  && _needs_wizard=true
[[ -z "$SKIP_HOOKS" ]] && _needs_wizard=true
[[ -z "$TARGET_DIR" ]] && _needs_wizard=true

if [[ "$_needs_wizard" == true ]] && [[ "$YES" == false ]] && [[ -t 0 ]]; then
  INTERACTIVE=true
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo " Clean Code + DDD Skill Kit — Migration Wizard"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo " Answer each question, or press Enter to accept the [default]."
  echo " Skip the wizard: pass --tool, --lang, and --yes flags instead."
  echo ""

  # ── Target directory ────────────────────────────────────────────────────────
  if [[ -z "$TARGET_DIR" ]]; then
    read -r -p "1. Target project directory [.]: " _input
    TARGET_DIR="${_input:-.}"
  fi

  # ── AI tool(s) ──────────────────────────────────────────────────────────────
  if [[ -z "$TOOL" ]]; then
    echo ""
    echo "2. Which AI tool(s) should be set up?"
    echo "   [1] copilot    — GitHub Copilot (VS Code)"
    echo "   [2] claude     — Claude Code"
    echo "   [3] cursor     — Cursor (.mdc rules)"
    echo "   [4] opencode   — OpenCode (AGENTS.md)"
    echo "   [5] windsurf   — Windsurf / Cascade"
    echo "   [6] generic    — Generic system prompts (any LLM API)"
    echo "   [a] all        — Install all of the above"
    read -r -p "   Enter numbers/letters separated by commas [a]: " _input
    _input="${_input:-a}"
    if [[ "$_input" == "a" || "$_input" == "all" ]]; then
      TOOL="all"
    else
      TOOL=""
      IFS=',' read -ra _choices <<< "$_input"
      for _c in "${_choices[@]}"; do
        _c="$(echo "$_c" | tr -d ' ')"
        case "$_c" in
          1) TOOL="${TOOL:+$TOOL,}copilot" ;;
          2) TOOL="${TOOL:+$TOOL,}claude" ;;
          3) TOOL="${TOOL:+$TOOL,}cursor" ;;
          4) TOOL="${TOOL:+$TOOL,}opencode" ;;
          5) TOOL="${TOOL:+$TOOL,}windsurf" ;;
          6) TOOL="${TOOL:+$TOOL,}generic" ;;
          *) TOOL="${TOOL:+$TOOL,}$_c" ;;
        esac
      done
      [[ -z "$TOOL" ]] && TOOL="all"
    fi
  fi

  # ── Linting ─────────────────────────────────────────────────────────────────
  if [[ -z "$SKIP_LINT" ]]; then
    echo ""
    echo "3. Copy linting configuration files?"
    echo "   [y] yes — copy per-language lint configs (Ruff, ESLint, golangci, Checkstyle, etc.)"
    echo "   [n] no  — skip (useful for monorepos where each package manages its own)"
    read -r -p "   [y]: " _input
    case "${_input:-y}" in
      [nN]*) SKIP_LINT=true ;;
      *)     SKIP_LINT=false ;;
    esac
  fi

  # ── Language (only if linting is enabled) ───────────────────────────────────
  if [[ "$SKIP_LINT" == false ]] && [[ -z "$LANG" ]]; then
    echo ""
    echo "4. Which language linting config(s) do you need?"
    echo "   [1] python"
    echo "   [2] typescript"
    echo "   [3] go"
    echo "   [4] java"
    echo "   [5] csharp"
    echo "   [a] all"
    read -r -p "   Enter numbers/letters separated by commas [a]: " _input
    _input="${_input:-a}"
    if [[ "$_input" == "a" || "$_input" == "all" ]]; then
      LANG="all"
    else
      LANG=""
      IFS=',' read -ra _choices <<< "$_input"
      for _c in "${_choices[@]}"; do
        _c="$(echo "$_c" | tr -d ' ')"
        case "$_c" in
          1) LANG="${LANG:+$LANG,}python" ;;
          2) LANG="${LANG:+$LANG,}typescript" ;;
          3) LANG="${LANG:+$LANG,}go" ;;
          4) LANG="${LANG:+$LANG,}java" ;;
          5) LANG="${LANG:+$LANG,}csharp" ;;
          *) LANG="${LANG:+$LANG,}$_c" ;;
        esac
      done
      [[ -z "$LANG" ]] && LANG="all"
    fi
  fi

  # ── Pre-commit hooks ─────────────────────────────────────────────────────────
  if [[ -z "$SKIP_HOOKS" ]]; then
    echo ""
    echo "5. Copy pre-commit hook config (.pre-commit-config.yaml)?"
    read -r -p "   [y]: " _input
    case "${_input:-y}" in
      [nN]*) SKIP_HOOKS=true ;;
      *)     SKIP_HOOKS=false ;;
    esac
  fi

  # ── Dry-run ──────────────────────────────────────────────────────────────────
  if [[ "$DRY_RUN" == false ]]; then
    echo ""
    echo "6. Do a dry run first (preview what would be copied without writing files)?"
    read -r -p "   [y]: " _input
    case "${_input:-y}" in
      [nN]*) DRY_RUN=false ;;
      *)     DRY_RUN=true ;;
    esac
  fi

  echo ""
fi

# Fill defaults for anything still unset after the wizard / flag parsing
[[ -z "$TOOL" ]]       && TOOL="all"
[[ -z "$LANG" ]]       && LANG="all"
[[ -z "$SKIP_LINT" ]]  && SKIP_LINT=false
[[ -z "$SKIP_HOOKS" ]] && SKIP_HOOKS=false
[[ -z "$TARGET_DIR" ]] && TARGET_DIR="$PWD"

# ── Resolve target path ───────────────────────────────────────────────────────
TARGET_DIR="${TARGET_DIR:-$PWD}"
# Resolve to absolute path; in dry-run mode the dir may not exist yet
if [[ -d "$TARGET_DIR" ]]; then
  TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
else
  # Treat as relative to cwd
  TARGET_DIR="$(cd "$(dirname "$TARGET_DIR")" 2>/dev/null && pwd)/$(basename "$TARGET_DIR")" || TARGET_DIR="$PWD/$TARGET_DIR"
fi

# ── Helpers ───────────────────────────────────────────────────────────────────
COPIED=0
SKIPPED=0

copy_file() {
  local src="$1" dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  if [[ ! -f "$src" ]]; then
    echo "  WARN  source not found: $src"
    return
  fi

  if [[ "$DRY_RUN" == true ]]; then
    echo "  [dry] cp  $src"
    echo "        →   $dst"
    COPIED=$((COPIED + 1))
    return
  fi

  mkdir -p "$dst_dir"
  if [[ -f "$dst" ]]; then
    # Back up existing file with timestamp so nothing is lost
    cp "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
    echo "  MERGE $dst  (backup created)"
  else
    echo "  COPY  $dst"
  fi
  cp "$src" "$dst"
  COPIED=$((COPIED + 1))
}

copy_dir() {
  local src="$1" dst="$2"
  if [[ ! -d "$src" ]]; then
    echo "  WARN  source not found: $src"
    return
  fi
  if [[ "$DRY_RUN" == true ]]; then
    echo "  [dry] cp -r $src/"
    echo "        →     $dst/"
    COPIED=$((COPIED + 1))
    return
  fi
  mkdir -p "$dst"
  cp -r "$src/." "$dst/"
  echo "  COPY  $dst/"
  COPIED=$((COPIED + 1))
}

section() { echo ""; echo "── $* ──────────────────────────────────────────────────"; }

# ── Banner ────────────────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Clean Code + DDD Skill Kit — Migration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Source  : $KIT_ROOT"
echo "  Target  : $TARGET_DIR"
echo "  Tool(s) : $TOOL"
echo "  Lang(s) : $([ "$SKIP_LINT" == true ] && echo "— (linting skipped)" || echo "$LANG")"
echo "  Linting : $([ "$SKIP_LINT" == true ] && echo skip || echo yes)"
echo "  Hooks   : $([ "$SKIP_HOOKS" == true ] && echo skip || echo yes)"
[[ "$DRY_RUN" == true ]] && echo "  Mode    : DRY RUN — no files will be written"
echo ""

# ── Confirmation (non-interactive / --yes skips this) ─────────────────────────
if [[ "$DRY_RUN" == false ]] && [[ "$YES" == false ]] && [[ -t 0 ]]; then
  read -r -p "Proceed with migration? [y/N]: " _confirm
  case "${_confirm:-n}" in
    [yY]*) ;;
    *)
      echo "Aborted."
      exit 0
      ;;
  esac
  echo ""
fi

# ── AI Skills ────────────────────────────────────────────────────────────────
section "AI Skills"

copy_shared_skills() {
  # shared rules are needed by most adapters
  copy_file "$KIT_ROOT/skills/shared/rules.md"              "$TARGET_DIR/skills/shared/rules.md"
  copy_file "$KIT_ROOT/skills/shared/lint-report-prompt.md" "$TARGET_DIR/skills/shared/lint-report-prompt.md"
  copy_file "$KIT_ROOT/skills/shared/husky-rules.md"        "$TARGET_DIR/skills/shared/husky-rules.md"
}

install_tool() {
  local t="$1"
  case "$t" in
    copilot)
      copy_shared_skills
      copy_file "$KIT_ROOT/skills/copilot/_rules.instructions.md"            "$TARGET_DIR/.github/_rules.instructions.md"
      copy_file "$KIT_ROOT/skills/copilot/clean-code-review.instructions.md" "$TARGET_DIR/.github/clean-code-review.instructions.md"
      copy_file "$KIT_ROOT/skills/copilot/lint-report.instructions.md"       "$TARGET_DIR/.github/lint-report.instructions.md"
      copy_file "$KIT_ROOT/skills/copilot/husky-enforcement.instructions.md" "$TARGET_DIR/.github/husky-enforcement.instructions.md" 2>/dev/null || true
      echo "  NOTE  VS Code picks up .github/*.instructions.md automatically."
      ;;
    claude)
      copy_shared_skills
      copy_file "$KIT_ROOT/skills/claude/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
      echo "  NOTE  Claude Code reads CLAUDE.md from the project root on startup."
      ;;
    cursor)
      copy_dir "$KIT_ROOT/skills/cursor/.cursor" "$TARGET_DIR/.cursor"
      echo "  NOTE  .mdc rule activates automatically for matching file globs."
      ;;
    opencode)
      copy_file "$KIT_ROOT/skills/opencode/AGENTS.md" "$TARGET_DIR/AGENTS.md"
      ;;
    windsurf)
      copy_file "$KIT_ROOT/skills/windsurf/.windsurfrules" "$TARGET_DIR/.windsurfrules"
      ;;
    generic)
      copy_file "$KIT_ROOT/skills/generic/system-prompt.txt"             "$TARGET_DIR/skills/generic/system-prompt.txt"
      copy_file "$KIT_ROOT/skills/generic/lint-report-system-prompt.txt" "$TARGET_DIR/skills/generic/lint-report-system-prompt.txt"
      ;;
    *)
      echo "  WARN  Unknown tool: $t (valid: copilot claude cursor opencode windsurf generic)"
      SKIPPED=$((SKIPPED + 1))
      ;;
  esac
}

if [[ "$TOOL" == "all" ]]; then
  for t in copilot claude cursor opencode windsurf generic; do
    install_tool "$t"
  done
else
  # support comma-separated list: --tool copilot,claude
  IFS=',' read -ra TOOLS <<< "$TOOL"
  for t in "${TOOLS[@]}"; do
    install_tool "$(echo "$t" | tr -d ' ')"
  done
fi

# ── Linting configs ───────────────────────────────────────────────────────────
if [[ "$SKIP_LINT" == false ]]; then
  section "Linting configs"

  copy_shared_editorconfig() {
    copy_file "$KIT_ROOT/linting/shared/.editorconfig" "$TARGET_DIR/.editorconfig"
  }

  install_lang() {
    local l="$1" dst_prefix="${2:-$TARGET_DIR}"
    case "$l" in
      python)
        copy_shared_editorconfig
        copy_file "$KIT_ROOT/linting/python/pyproject.toml" "$dst_prefix/pyproject.toml"
        echo "  NOTE  Install linters: pip install ruff mypy bandit"
        ;;
      typescript|javascript|js|ts)
        copy_shared_editorconfig
        copy_file "$KIT_ROOT/linting/typescript/.eslintrc.json"   "$dst_prefix/.eslintrc.json"
        copy_file "$KIT_ROOT/linting/typescript/.prettierrc.json" "$dst_prefix/.prettierrc.json"
        echo "  NOTE  Install linters: npm install -D eslint prettier @typescript-eslint/parser ..."
        ;;
      go)
        copy_shared_editorconfig
        copy_file "$KIT_ROOT/linting/go/.golangci.yml" "$dst_prefix/.golangci.yml"
        echo "  NOTE  Install linter: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
        ;;
      java)
        copy_shared_editorconfig
        copy_file "$KIT_ROOT/linting/java/checkstyle.xml"   "$dst_prefix/checkstyle.xml"
        copy_file "$KIT_ROOT/linting/java/pmd-ruleset.xml"  "$dst_prefix/pmd-ruleset.xml"
        echo "  NOTE  Add checkstyle + pmd plugins to your pom.xml (see README)"
        ;;
      csharp|cs)
        copy_file "$KIT_ROOT/linting/csharp/.editorconfig" "$dst_prefix/.editorconfig"
        echo "  NOTE  Run: dotnet format --verify-no-changes"
        ;;
      *)
        echo "  WARN  Unknown lang: $l (valid: python typescript go java csharp)"
        SKIPPED=$((SKIPPED + 1))
        ;;
    esac
  }

  if [[ "$LANG" == "all" ]]; then
    for l in python typescript go java csharp; do
      install_lang "$l"
    done
  else
    IFS=',' read -ra LANGS <<< "$LANG"
    for l in "${LANGS[@]}"; do
      install_lang "$(echo "$l" | tr -d ' ')"
    done
  fi
fi

# ── Pre-commit hooks ──────────────────────────────────────────────────────────
if [[ "$SKIP_HOOKS" == false ]]; then
  section "Pre-commit hooks"
  copy_file "$KIT_ROOT/linting/shared/.pre-commit-config.yaml" "$TARGET_DIR/.pre-commit-config.yaml"
  echo "  NOTE  Activate: pip install pre-commit && pre-commit install"
fi

# ── lint-and-report script ────────────────────────────────────────────────────
section "Lint → AI report script"
mkdir -p "$TARGET_DIR/scripts"
copy_file "$KIT_ROOT/scripts/lint-and-report.sh" "$TARGET_DIR/scripts/lint-and-report.sh"
if [[ "$DRY_RUN" == false ]] && [[ -f "$TARGET_DIR/scripts/lint-and-report.sh" ]]; then
  chmod +x "$TARGET_DIR/scripts/lint-and-report.sh"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ "$DRY_RUN" == true ]]; then
  echo " Dry run complete — $COPIED item(s) would be copied, $SKIPPED warning(s)"
  echo ""
  echo " Run again without dry-run to apply:"
  echo "   ./scripts/migrate.sh --tool $TOOL --lang $LANG$( \
    [[ "$SKIP_LINT"  == true ]] && echo " --no-lint" || true)$( \
    [[ "$SKIP_HOOKS" == true ]] && echo " --no-hooks" || true) \
\"$TARGET_DIR\" --yes"
else
  echo " Migration complete — $COPIED item(s) copied, $SKIPPED warning(s)"
fi
echo ""
echo " Next steps:"
echo "   1. Run your linter:   ./scripts/lint-and-report.sh"
echo "   2. Feed output to AI: see instructions printed by the script above"
echo "   3. Commit:            git add . && git commit -m 'chore: add clean-code skill kit'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
