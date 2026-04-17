#!/usr/bin/env node
'use strict';

/**
 * Entry point for `npx clean-code-skill-kit`.
 *
 * Locates migrate.sh relative to this file (which is at <pkg-root>/bin/),
 * then forwards all CLI arguments to the bash script unchanged.
 *
 * The script's own SCRIPT_DIR / KIT_ROOT detection still works correctly
 * because migrate.sh is executed from its real on-disk location inside
 * the npm package tree.
 */

const { spawnSync } = require('child_process');
const path = require('path');

const script = path.join(__dirname, '..', 'scripts', 'migrate.sh');

const result = spawnSync('bash', [script, ...process.argv.slice(2)], {
  stdio: 'inherit',
  shell: false,
});

process.exit(result.status ?? 1);
