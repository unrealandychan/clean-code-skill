"""CLI entry point for the clean-code-skill-kit Python distribution.

Run directly:   python -m clean_code_skill_kit
Via uvx:        uvx clean-code-skill-kit
Via pip:        clean-code-skill

Locates migrate.sh next to this file (bundled as package data) and
forwards all arguments to it, preserving the script's interactive
SCRIPT_DIR / KIT_ROOT auto-detection logic.
"""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


def main() -> None:
    """Locate and run the interactive migration wizard."""
    pkg_root = Path(__file__).parent
    script = pkg_root / "scripts" / "migrate.sh"

    if not script.exists():
        print(
            f"ERROR: migrate.sh not found at {script}\n"
            "This is a packaging issue — please report it at\n"
            "https://github.com/unrealandychan/clean-code-skill/issues",
            file=sys.stderr,
        )
        sys.exit(1)

    result = subprocess.run(["bash", str(script)] + sys.argv[1:])
    sys.exit(result.returncode)


if __name__ == "__main__":
    main()
