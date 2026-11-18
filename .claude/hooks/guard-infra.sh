#!/usr/bin/env bash
# PreToolUse guard for Bash: deny Azure deletes and Complete-mode deployments
# even in bypassPermissions mode, with a reason Claude reads.

set -uo pipefail

# Fail closed: only exit 2 blocks a call, so any error must end in exit 2
if ! command -v jq >/dev/null 2>&1; then
  echo "guard-infra: jq isn't installed, so this command can't be checked." >&2
  exit 2
fi

if ! command=$(jq -r '.tool_input.command // empty' 2>/dev/null); then
  echo "guard-infra: couldn't read the tool call." >&2
  exit 2
fi

# Match anywhere in the text: lowercase, quotes removed, repeated spaces collapsed
normalized=$(printf '%s' "$command" | tr '[:upper:]' '[:lower:]' | tr -d "\"'" | tr -s ' ')

deny() {
  jq -n --arg reason "$1" '{hookSpecificOutput: {hookEventName: "PreToolUse",
    permissionDecision: "deny", permissionDecisionReason: $reason}}'
  exit 0
}

case "$normalized" in
  *"group delete"* | *"resource delete"* | *"storage account delete"*)
    deny "BrezyWeather guard: Claude can't delete Azure resources in this repo. Ask a human to run it." ;;
  *"--mode complete"* | *"--mode=complete"*)
    deny "BrezyWeather guard: Complete mode deletes every resource in the group that isn't in the template, even in a preview. Use Incremental mode." ;;
esac

# No decision: the permission rules decide as usual
exit 0
