# Impeccable Frontend Design & Anti-Slop Execution Workflows

Actionable step-by-step workflows connecting **Impeccable v4.9.2** (`pbakaus/impeccable`) with Clean Code, DDD, Google's Elephant-Goldfish Model (EGM), and Uncle Bob's Extreme Constraints across Antigravity, Claude Code, Cursor, Codex, OpenCode, Pi, and Hermes.

---

## 1. Greenfield Surface or Redesign Workflow (`init` -> `shape` -> Craft -> `finish-reviewer`)

**Goal**: Ship an out-of-distribution frontend interface with zero AI slop, durable context artifacts, and fresh-eyes verification.

### Execution Steps
1. **Establish Durable Context (`/impeccable init`)**:
   - Run `<skill-dir>/scripts/impeccable context` once from the project root.
   - If `PRODUCT.md` is missing, run `/impeccable init` (`reference/init.md`) to capture target users, core tasks, platform (`web`, `ios`, `android`, `adaptive`), and brand personality.
2. **Select Surface Mode & Plan UX (`/impeccable shape`)**:
   - Classify the target surface into `Persuade`, `Operate`, `Read`, or `Experience`.
   - Load `reference/shape.md` and `reference/new-work.md` (plus `reference/new-work-world.md` when creating/replacing a visual world).
   - Align terminology with `GLOSSARY.md` (DDD Ubiquitous Language) and architectural boundaries in `docs/designs/<feature>.md` (EGM).
3. **Enable Mechanical Edit-Time Guardrails (`/impeccable hooks on`)**:
   - Activate the Impeccable detector hook (`reference/hooks.md`) so immediate-tier rules (`low-contrast`, `text-overflow`, `gradient-text`, `gray-on-color`, `design-system-*`) run automatically on UI edits.
4. **Load the Craft Floor Before Editing (`reference/craft-floor.md`)**:
   - Immediately before writing TSX/JSX/Vue/Svelte/CSS/SwiftUI/Compose code, read `reference/craft-floor.md`.
   - Enforce all **Verify** gates (contrast $\ge 4.5:1$, `65–75ch` measure, `hover`/`focus-visible`/`loading`/`empty`/`error` states, themed browser selection/scrollbars/focus rings, tabular numerals) and **Refuse** bans (zero eyebrow kickers above headings, zero nested cards, zero colored side-stripes on rounded cards, zero emoji icons).
5. **Run Deterministic Detection & Visual Capture**:
   - Capture rendered desktop and mobile viewports into `.impeccable/review/` (`desktop.png`, `mobile.png`).
   - Run `npx impeccable detect <url-or-build-dir>` and fix all mechanical violations.
6. **Dispatch Stateless Finish Reviewer (`impeccable-finish-reviewer`)**:
   - Spawn `impeccable-finish-reviewer` (zero build-thread bias) with `.impeccable/review/` captures, `PRODUCT.md`, `DESIGN.md`, and `reference/craft-floor.md`.
   - Iterate until disposition reaches **`disposition: ship`**, then persist tokens via `/impeccable document` (`impeccable-documenter`).

---

## 2. Legacy UI Anti-Slop & Design System Extraction (`document` -> `critique` -> `audit` -> `distill` -> `polish`)

**Goal**: Upgrade an existing or AI-generated UI suffering from visual clutter, inconsistent tokens, or "AI slop" without breaking product behavior.

### Execution Steps
1. **Baseline Deterministic Scan**:
   - Run `npx impeccable detect <target-url-or-dir> --format json` to inventory all 62-rule violations (`slop` + `quality`).
2. **Heuristic & Technical Audit (`/impeccable critique` + `/impeccable audit`)**:
   - Load `reference/critique.md` (`reference/critique-rubric.md`) to score visual hierarchy, focal clarity, mode fit, and emotional resonance.
   - Load `reference/audit.md` (or `reference/audit.native.md` for iOS/Android) to audit keyboard navigation, ARIA semantics, contrast, responsive reflow, and Core Web Vitals.
3. **Extract Reusable Deep-Module Primitives (`/impeccable extract` + `/impeccable document`)**:
   - Consolidate hardcoded colors, radii, and type sizes into semantic CSS variables / design tokens (`DESIGN.md`).
   - Refactor boolean-flag-heavy components (`boolean-prop-proliferation`) into clean compound components.
4. **Targeted Refinement Passes**:
   - Too noisy or over-decorated? Run **`/impeccable quieter`** and **`/impeccable distill`**.
   - Too generic or timid on a `Persuade`/`Experience` page? Run **`/impeccable bolder`**, **`/impeccable typeset`**, and **`/impeccable colorize`**.
   - Copy vague or robotic? Run **`/impeccable clarify`**.
5. **Pre-Ship Polish & Hardening (`/impeccable polish` + `/impeccable harden`)**:
   - Run `/impeccable harden` for long strings, i18n expansion, empty/offline/error states, and slow network states.
   - Run `/impeccable polish` + `npx impeccable detect` to confirm zero regressions.

---

## 3. CI / Pre-PR Frontend Gauntlet Integration

Pair Impeccable's deterministic CLI with `clean-code-skill` quality gates in CI or pre-push verification:

```bash
# 1. List all 62 deterministic anti-slop & UI quality rules
npx impeccable detect --list-rules

# 2. Scan a built static directory or running dev/preview server
npx impeccable detect ./dist --format json

# 3. Verify project Impeccable artifact health (PRODUCT.md, DESIGN.md, hooks)
.agents/skills/impeccable/scripts/impeccable doctor
```
