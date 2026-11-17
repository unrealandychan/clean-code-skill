# Impeccable Frontend Design & Anti-Slop Engine — Canonical Reference

> Powered by **Impeccable** ([github.com/pbakaus/impeccable](https://github.com/pbakaus/impeccable), v4.9.2, Apache 2.0) by Paul Bakaus.
> Extends `rules.md`, `agentic-engineering-rules.md`, and `code-review-quality-rules.md` with mode-calibrated frontend design craft, durable product/design context (`PRODUCT.md` + `DESIGN.md`), 24 design workflows, 5 specialized visual subagents, and a deterministic 62-rule Rust anti-slop & UI quality detector (`npx impeccable detect`).

---

## 1. Core Design Philosophy: Mode-Calibrated Out-of-Distribution Craft

Unguided AI coding models converge on predictable **"AI slop"**: purple-to-cyan gradients, Inter/Roboto everywhere, eyebrow kickers above every heading, 3-column icon-card grids, colored left borders on rounded cards, zero-offset neon halos, and invented marketing buzzwords.

**Impeccable** replaces generic defaults with **surface-calibrated craft**:

1. **The Brief Wins**: Honor pinned aesthetics, materials, fonts, and palettes from `PRODUCT.md` and `DESIGN.md`. Never override a committed visual world with generic model habits.
2. **Scale Ambition to Surface Mode**: Choose the mode from the *surface*, not the company (a developer tool's landing page is `Persuade`; a fashion brand's documentation is `Read`):

| Surface Mode | Visitor Goal | Target Surfaces | Design Posture |
| :--- | :--- | :--- | :--- |
| **`Persuade`** | Decide and act; design *is* the product | Landing pages, marketing, campaigns, pricing | Bold, unmistakable point of view, own-world typography, real imagery/plates, authored motion. |
| **`Operate`** | Complete a task reliably and fast | App UI, dashboards, editors, admin, settings | Scanability, hierarchy, keyboard/focus precision, native platform expectations; brand lives in subtle details. |
| **`Read`** | Understand and retain information | Docs, articles, changelogs, guides, help centers | 65–75ch measure, clear typographic rhythm, zero chrome clutter, effortless navigation. |
| **`Experience`** | Step inside the work itself | Portfolios, galleries, interactive showcases | Let the artifact lead from the first viewport; UI chrome recedes completely. |

3. **Durable Design Context Artifacts**:
   - **`PRODUCT.md`** (`/impeccable init`): Captures audience, jobs-to-be-done, brand voice, platform (`web`, `ios`, `android`, `adaptive`), and non-goals.
   - **`DESIGN.md`** (`/impeccable document`): Codifies the visual world, typography scale, color tokens, elevation rules, and component invariants from real code.
   - **`.impeccable/`**: Stores surface briefs, visual comps/mocks, detector hook configuration, and `impeccable comp-diff` verification reports.

---

## 2. How Impeccable Connects with Clean Code Skill Modules

| Lifecycle Phase | Clean Code Skill Module | Impeccable Integration Role |
| :--- | :--- | :--- |
| **1. Product & Domain Discovery** | EGM (`/egm-brainstorm`) & Matt Pocock (`/domain-modeling`) | **`/impeccable init` & `/impeccable shape`** establish `PRODUCT.md`, UX flows, and surface modes (`Persuade`, `Operate`, `Read`, `Experience`) before writing UI code. |
| **2. Design System Specification** | EGM (`/egm-draft`) & Deep Modules (`codebase-design`) | **`/impeccable document` & `/impeccable extract`** codify `DESIGN.md` and extract reusable design tokens and compound components (preventing `boolean-prop-proliferation`). |
| **3. Craft-Floor Implementation** | Uncle Bob's Extreme Constraints (`/vibe-guard`) | **Craft Floor (`reference/craft-floor.md`) + Edit Hooks (`/impeccable hooks on`)** enforce real-time contrast, typography, spacing, and anti-slop bans on every UI file edit. |
| **4. Deterministic Slop & A11y Gate** | Automated Gauntlet (`/gauntlet-check`) | **`npx impeccable detect <dir\|url>`** runs the headless Chromium + Rust 62-rule engine to catch contrast failures, overflow, clipped text, and AI slop patterns mechanically. |
| **5. Fresh-Eyes Visual Review** | EGM Goldfish Critics & 5-Axis Review (`/code-review`) | **`impeccable-finish-reviewer` & `impeccable-motion-reviewer`** run isolated subagent audits returning strict `ship` / `fix` / `rebuild` / `recapture` dispositions. |
| **6. Production Hardening** | Harness Engineering (`skills/shared/harness-rules.md`) | **`/impeccable harden`, `/impeccable adapt`, `/impeccable optimize`** verify loading/empty/error states, i18n text expansion, responsive breakpoints, and rendering performance. |

---

## 3. The Craft Floor (`Verify` & `Refuse` Mandates)

Before making any UI edit (including small refinements), enforce the **Craft Floor** (`skills/impeccable/reference/craft-floor.md`):

### 3.1 Verify on Every Rendered Viewport
- **Contrast**: Body and placeholder text $\ge 4.5:1$; large text $\ge 3:1$. On colored surfaces, tint secondary text from that surface hue — **never neutral gray on color** (`gray-on-color`).
- **Depth**: Shadows must carry a vertical offset and soft blur. Zero-offset colored glows (`dark-glow`, `radial-halo`) are decoration, not elevation. Declare elevation once (border *or* shadow — never a 1px border over a wide soft shadow, `gpt-thin-border-wide-shadow`).
- **Spacing**: Tight internal grouping, generous section separation, and **more space above a heading than below it** (`heading-rhythm`).
- **Typography**: Body measure `65–75ch` (`line-length`), display max `6rem` (`oversized-h1`), negative tracking floor `-0.04em` (`extreme-negative-tracking`), `text-wrap: balance` on headings (`unbalanced-heading`), and tabular numerals (`font-variant-numeric: tabular-nums`) in data views.
- **Motion**: One authored moment using exponential ease-out from an already-visible resting state (never `content-hidden-at-rest` or `bounce-easing`).
- **Interactive States & Browser Surfaces**: Implement `hover`, `focus-visible`, `disabled`, `loading`, `empty`, and `error` states. Theme `::selection`, caret, scrollbars, focus rings, and underline offsets to match the palette.
- **UX Copy**: Use domain Ubiquitous Language (`GLOSSARY.md`). Buttons name their concrete action; error messages name both the problem and the recovery path (`clarify`).

### 3.2 Refuse (Hard Bans & Slop Scaffolds)
- **Hard Ban — No Kickers / Eyebrows Above Headings (`kicker-above-heading`, `hero-eyebrow-chip`)**: Delete small uppercase labels or pill badges above `h1`/`h2` headings. Let the heading carry its own weight.
- **No Card-Grid Page Scaffolds (`icon-tile-stack`, `nested-cards`)**: Refuse 3-up equal-height cards of icon + title + blurb as default page structure. **Nested cards are always wrong.**
- **No Colored Side Stripes on Rounded Containers (`side-tab`, `border-accent-on-rounded`)**: Refuse `border-left` / `border-right` > 1px accent stripes on cards, callouts, or list items.
- **No Gradient Text (`gradient-text`)**: Achieve hierarchy through scale, weight, and contrast — never `background-clip: text` gradients.
- **No Uninvited Neobrutalist Offset Shadows**: Refuse `box-shadow: 4px 4px 0` outside an explicitly neobrutalist visual world.
- **No Emoji / Unicode Icons**: Use a consistent stroke/weight SVG icon set; never substitute emoji or Unicode glyphs for UI icons.
- **No Fake Sketch SVG / `feTurbulence` Grain (`shape-assembled-illustration`)**: Crisp geometric SVG, diagrams, and shaders are welcome; amateur AI-assembled figure/scene SVGs are banned.
- **No Theater Copy (`marketing-buzzword`, `aphoristic-cadence`, `theater-slop-phrase`, `em-dash-overuse`)**: Ban AI copywriting tropes ("Built for modern teams", "Not X. Just Y.", excessive em-dashes).

---

## 4. Deterministic 62-Rule Anti-Slop & Quality Detector (`impeccable detect`)

Run the standalone Rust/headless-browser detector locally or in CI (`npx impeccable detect <dir|url> --format json`):

### 4.1 Immediate-Tier Edit Rules (Enforced Live by `/impeccable hooks on`)

| Rule ID | Category | Severity | What It Catches |
| :--- | :--- | :--- | :--- |
| `broken-image` | `quality` | **high** | `<img>` failing to load (`naturalWidth === 0`) or missing asset path |
| `text-overflow` | `quality` | **high** | Text horizontally overflowing or clipping outside its container |
| `body-text-viewport-edge` | `quality` | **high** | Body copy touching the viewport edge without horizontal padding |
| `low-contrast` | `quality` | **high** | WCAG AA contrast failure ($< 4.5:1$ normal text, $< 3:1$ large text) |
| `gray-on-color` | `slop` | medium | Untinted neutral gray text placed directly on a colored surface |
| `tiny-text` | `quality` | **high** | Rendered font size below readable floor (`< 11px` / `undersized-ui-text`) |
| `gradient-text` | `slop` | medium | `background-clip: text` gradient fills used on headings or labels |
| `dark-glow` | `slop` | medium | Neon zero-offset outer glow `box-shadow` on dark surfaces |
| `design-system-font` | `quality` | medium | Undeclared font family drifting from `DESIGN.md` tokens |
| `design-system-color` | `quality` | medium | Hardcoded hex/RGB values bypassing `DESIGN.md` semantic tokens |
| `design-system-radius` | `quality` | low | Arbitrary border radii drifting from the design system scale |
| `design-system-font-size` | `quality` | low | Off-scale font sizes violating the documented type ramp |

### 4.2 Full Slop & Structural Quality Rule Catalog (Selected High-Signal Rules)

- **Visual AI Slop (`slop`)**: `ai-color-palette` (generic indigo/violet/cyan AI palette), `cream-palette` (unmotivated warm-cream default ground), `overused-font` (reflexive Inter/Space Grotesk/Plus Jakarta Sans without brief pin), `italic-serif-display` (cliché editorial italic serif hero), `side-tab` & `border-accent-on-rounded`, `nested-cards`, `icon-tile-stack`, `hero-eyebrow-chip`, `kicker-above-heading`, `numbered-section-labels` (`01 / 02 / 03` without sequential meaning), `pulsing-dot`, `blinking-cursor`, `bounce-easing`, `marquee`, `radial-halo`, `radial-spotlight-glow`, `gpt-thin-border-wide-shadow`, `repeating-stripes-gradient`, `codex-grid-background`, `shape-assembled-illustration`, `em-dash-overuse`, `marketing-buzzword`, `aphoristic-cadence`, `theater-slop-phrase`.
- **Layout, Typography & Runtime Quality (`quality`)**: `script-error` (uncaught console/page JS error), `content-hidden-at-rest` (`opacity: 0` scroll-reveal traps), `text-occlusion` (overlapping elements obscuring text), `first-viewport-column-overflow`, `clipped-overflow-container`, `edge-flush-cards`, `cramped-padding`, `monotonous-spacing`, `flat-type-hierarchy`, `oversized-h1`, `extreme-negative-tracking`, `wide-tracking`, `all-caps-body`, `tight-leading`, `line-length`, `justified-text`, `skipped-heading`, `heading-rhythm`, `straggler`, `unbalanced-heading`, `repeated-container-text`.

---

## 5. The 24 `/impeccable` Commands & 5 Specialized Subagents

### 5.1 Command Matrix

| Phase | Commands | Primary Responsibility |
| :--- | :--- | :--- |
| **Build & Plan** | `init`, `shape`, `document`, `extract` | Capture `PRODUCT.md` (`init`), plan UX/surface structure (`shape`), codify `DESIGN.md` (`document`), and extract design-system tokens/components (`extract`). |
| **Evaluate** | `critique`, `audit` | Heuristic UX/design-director scoring (`critique`) and technical a11y/responsive/perf auditing (`audit`, plus native iOS/Android rubrics). |
| **Refine & Finish** | `polish`, `bolder`, `quieter`, `distill`, `harden`, `onboard` | Pre-ship alignment pass (`polish`), amplify timid UI (`bolder`), calm noisy UI (`quieter`), strip bloat (`distill`), edge-case/i18n/error readiness (`harden`), empty-state & first-run UX (`onboard`). |
| **Enhance** | `animate`, `colorize`, `typeset`, `layout`, `delight`, `overdrive` | Purposeful choreography (`animate`), strategic color (`colorize`), type scale & pairing (`typeset`), spatial rhythm (`layout`), micro-interactions (`delight`), high-craft effects (`overdrive`). |
| **Fix** | `clarify`, `adapt`, `optimize` | Crisp UX copy & recovery messages (`clarify`), responsive & cross-device adaptation (`adapt`), rendering/CLS/bundle optimization (`optimize`). |
| **Iterate & Meta** | `live`, `generate`, `hooks`, `doctor`, `foundations`, `pin` | In-browser live variant picker (`live`, `generate`), edit-time slop hooks (`hooks`), artifact drift check (`doctor`), product launch checklist (`foundations`), command shortcuts (`pin`). |

### 5.2 Specialized Visual Subagents (`agents/impeccable-*.md`)

1. **`impeccable-finish-reviewer`**: Stateless fresh-eyes design director auditing screenshots, `PRODUCT.md`, `DESIGN.md`, and `comp-diff` reports. Emits a mandatory four-word disposition: `ship`, `fix`, `rebuild`, or `recapture`.
2. **`impeccable-motion-reviewer`**: Reviews choreographed transitions, easing curves, `prefers-reduced-motion` compliance, and 60fps compositor safety.
3. **`impeccable-documenter`**: Extracts live tokens, typography scales, surface rules, and component patterns from source code into `DESIGN.md`.
4. **`impeccable-asset-producer`**: Produces authentic raster/vector plates and mattes so builds never substitute cheap CSS gradients or clip-paths for real imagery.
5. **`impeccable-manual-edit-applier`**: Translates visual live-browser tweaks (`live`) cleanly back into idiomatic component source code and tokens.

---

## 6. Frontend Design & Anti-Slop Review Output Format

When reviewing frontend/UI code or reporting Impeccable audit findings, use this structured format:

```markdown
## Impeccable Frontend Design & Quality Review

**Surface & Mode**: `<route-or-component>` (`Persuade` | `Operate` | `Read` | `Experience`)
**Context Artifacts**: `PRODUCT.md`: [present | missing] · `DESIGN.md`: [present | missing]
**Detector Summary**: `N` findings (`High`: N, `Medium`: N, `Low`: N)
**Disposition**: `ship` | `fix` | `rebuild` | `recapture`

### Finding N
- **Severity**: high | medium | low
- **Rule / Check**: `<impeccable-rule-id-or-craft-floor-check>`
- **Location**: `<file>:<line>` (Selector / Viewport: `<selector> @ <desktop|mobile>`)
- **Problem**: <Specific slop pattern, hierarchy flaw, a11y/contrast failure, or missing state>
- **Why It Matters**: <UX comprehension, brand credibility, accessibility, or task-completion impact>
- **Suggested Fix**: <Concrete CSS/component/copy change aligned with DESIGN.md>
```
