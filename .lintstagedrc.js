const IGNORED_DIRS = [
  "skills/ecc/",
  "rules/",
  "agents/",
  "hooks/",
  "contexts/",
  ".gemini/",
  "scripts/lib/",
];

function isNotIgnored(file) {
  const norm = file.replace(/\\/g, "/");
  return !IGNORED_DIRS.some((d) => norm.includes(d));
}

module.exports = {
  "*.md": (filenames) => {
    const targets = filenames.filter(isNotIgnored);
    if (targets.length === 0) return [];
    return [
      `markdownlint-cli2 --fix ${targets.map((f) => `"${f}"`).join(" ")}`,
      `prettier --write ${targets.map((f) => `"${f}"`).join(" ")}`,
    ];
  },
  "*.{json,jsonc}": (filenames) => {
    const targets = filenames.filter(isNotIgnored);
    if (targets.length === 0) return [];
    return [`prettier --write ${targets.map((f) => `"${f}"`).join(" ")}`];
  },
  "*.{yml,yaml}": (filenames) => {
    const targets = filenames.filter(isNotIgnored);
    if (targets.length === 0) return [];
    return [`prettier --write ${targets.map((f) => `"${f}"`).join(" ")}`];
  },
  "*.{ts,tsx,js,jsx,mjs,cjs}": (filenames) => {
    const targets = filenames.filter(isNotIgnored);
    if (targets.length === 0) return [];
    return [`prettier --write ${targets.map((f) => `"${f}"`).join(" ")}`];
  },
  "*.py": (filenames) => {
    const targets = filenames.filter(isNotIgnored);
    if (targets.length === 0) return [];
    return [
      `bash -c 'if command -v ruff >/dev/null 2>&1; then ruff check --fix "$@" && ruff format "$@"; fi' -- ${targets.map((f) => `"${f}"`).join(" ")}`,
    ];
  },
  "*.go": (filenames) => {
    const targets = filenames.filter(isNotIgnored);
    if (targets.length === 0) return [];
    return [
      `bash -c 'if command -v gofmt >/dev/null 2>&1; then gofmt -w "$@"; fi' -- ${targets.map((f) => `"${f}"`).join(" ")}`,
    ];
  },
  "*.cs": (filenames) => {
    const targets = filenames.filter(isNotIgnored);
    if (targets.length === 0) return [];
    return [
      `bash -c 'if command -v dotnet >/dev/null 2>&1; then dotnet format --include "$@"; fi' -- ${targets.map((f) => `"${f}"`).join(" ")}`,
    ];
  },
  "*.sh": (filenames) => {
    const targets = filenames.filter(isNotIgnored);
    if (targets.length === 0) return [];
    return [
      `bash -c 'if command -v shfmt >/dev/null 2>&1; then shfmt -w "$@"; fi' -- ${targets.map((f) => `"${f}"`).join(" ")}`,
    ];
  },
};
