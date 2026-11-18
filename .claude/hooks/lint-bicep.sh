#!/usr/bin/env bash
# PostToolUse check for Edit and Write: lint the Bicep file Claude just changed.
# The edit has already happened; exit 2 sends the findings back to Claude to fix.

set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "lint-bicep: jq isn't installed, so this edit wasn't linted." >&2
  exit 2
fi

if ! file_path=$(jq -r '.tool_input.file_path // empty' 2>/dev/null); then
  echo "lint-bicep: couldn't read the tool call." >&2
  exit 2
fi

# Only Bicep templates; parameter files and other files pass through
[[ "$file_path" == *.bicep ]] || exit 0

if ! lint_output=$(az bicep lint --file "$file_path" 2>&1); then
  printf 'Bicep lint failed for %s. Fix these findings:\n%s\n' "$file_path" "$lint_output" >&2
  exit 2
fi

exit 0
