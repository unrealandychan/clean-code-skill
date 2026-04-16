// commitlint.config.cjs
// Enforces Conventional Commits for every commit in this project.
// Docs: https://commitlint.js.org | https://www.conventionalcommits.org

/** @type {import('@commitlint/types').UserConfig} */
module.exports = {
  extends: ["@commitlint/config-conventional"],

  rules: {
    // ── Type ────────────────────────────────────────────────────────────────
    // Allowed commit types for this project
    "type-enum": [
      2, // error
      "always",
      [
        "feat",   // new skill, new linting config, new tool support
        "fix",    // correct a wrong rule, broken config, typo in prompt
        "docs",   // README, RELEASE-NOTES, ai-clean-code-skill-guide
        "style",  // whitespace, formatting inside config files (no logic change)
        "refactor", // restructure without behaviour change (e.g. shared rules split)
        "perf",   // make a hook/lint step faster
        "test",   // add or fix test cases for configs
        "chore",  // dependency bumps, tooling, CI
        "revert", // revert a previous commit
        "release", // version bump commits
      ],
    ],
    "type-case": [2, "always", "lower-case"],
    "type-empty": [2, "never"],

    // ── Scope ───────────────────────────────────────────────────────────────
    // Scope is optional but must be one of these values when provided
    "scope-enum": [
      1, // warning — scopes are recommended but not required
      "always",
      [
        // AI skill adapters
        "skills",          // change affects multiple adapters
        "shared",          // skills/shared/rules.md
        "copilot",         // skills/copilot/
        "claude",          // skills/claude/
        "cursor",          // skills/cursor/
        "opencode",        // skills/opencode/
        "windsurf",        // skills/windsurf/
        "generic",         // skills/generic/

        // Linting
        "linting",         // change affects multiple linting configs
        "python",          // linting/python/
        "typescript",      // linting/typescript/
        "go",              // linting/go/
        "java",            // linting/java/
        "csharp",          // linting/csharp/

        // Shared tooling
        "editorconfig",    // linting/shared/.editorconfig
        "pre-commit",      // linting/shared/.pre-commit-config.yaml
        "hooks",           // .husky/ or commitlint

        // Project meta
        "deps",            // package.json dependency updates
        "release",         // RELEASE-NOTES.md, version tags
        "ci",              // CI/CD pipeline config
      ],
    ],
    "scope-case": [2, "always", "lower-case"],

    // ── Subject ─────────────────────────────────────────────────────────────
    "subject-empty": [2, "never"],
    "subject-case": [2, "always", "lower-case"],
    // Do not end the subject line with a period
    "subject-full-stop": [2, "never", "."],
    // Keep subject concise — body is the place for detail
    "subject-max-length": [2, "always", 72],
    "subject-min-length": [2, "always", 10],

    // ── Body ────────────────────────────────────────────────────────────────
    // Body is optional. When present, must be separated by a blank line.
    "body-leading-blank": [2, "always"],
    "body-max-line-length": [1, "always", 100],

    // ── Footer ──────────────────────────────────────────────────────────────
    "footer-leading-blank": [2, "always"],
    "footer-max-line-length": [1, "always", 100],

    // ── Header ──────────────────────────────────────────────────────────────
    "header-max-length": [2, "always", 100],
  },

  // Custom prompt shown when commitlint fails
  helpUrl:
    "https://github.com/conventional-changelog/commitlint/#what-is-commitlint",

  prompt: {
    messages: {
      skip: "(optional — press enter to skip)",
      max: "max %d chars",
      min: "%d chars minimum",
      emptyWarning: "%s is required",
      upperLimitWarning: "%s is over the limit of %d chars",
      lowerLimitWarning: "%s is under the minimum of %d chars",
    },
    questions: {
      type: {
        description: "What type of change is this commit?",
        enum: {
          feat:     { description: "New skill, rule, linting config, or tool support", title: "feat",     emoji: "✨" },
          fix:      { description: "Correct a wrong rule, broken config, bad prompt",  title: "fix",      emoji: "🐛" },
          docs:     { description: "README, RELEASE-NOTES, guide updates",             title: "docs",     emoji: "📝" },
          style:    { description: "Whitespace or formatting, no logic change",        title: "style",    emoji: "💄" },
          refactor: { description: "Restructure without behaviour change",             title: "refactor", emoji: "♻️"  },
          perf:     { description: "Improve hook or lint performance",                 title: "perf",     emoji: "⚡️" },
          test:     { description: "Add or fix config tests",                          title: "test",     emoji: "✅" },
          chore:    { description: "Dependency bumps, tooling, CI",                   title: "chore",    emoji: "🔧" },
          revert:   { description: "Revert a previous commit",                        title: "revert",   emoji: "⏪️" },
          release:  { description: "Version bump commit",                             title: "release",  emoji: "🚀" },
        },
      },
      scope: {
        description:
          "Which part of the project does this change affect? (e.g. shared, copilot, python, hooks)",
      },
      subject: {
        description: "Short description — lowercase, no trailing period, max 72 chars",
      },
      body: {
        description: "Longer description (optional). Explain what changed and why.",
      },
      isBreaking: {
        description: "Is this a BREAKING CHANGE?",
      },
      breakingBody: {
        description:
          "A BREAKING CHANGE commit requires a body. Describe what breaks and how to migrate.",
      },
      breaking: {
        description: "Describe the breaking change",
      },
      isIssueAffected: {
        description: "Does this change affect any open issues?",
      },
      issuesBody: {
        description:
          "If issues are closed, the commit requires a body. Describe the fix.",
      },
      issues: {
        description: 'Reference issues (e.g. "fix #123", "closes #456")',
      },
    },
  },
};
