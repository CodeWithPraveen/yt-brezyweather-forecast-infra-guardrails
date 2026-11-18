# BrezyWeather Forecast Infrastructure: Guardrails

Demo repository for the Code with Praveen video "Claude Code Permissions and Hooks: Guardrails for Infrastructure Repos". The Bicep storage repo with permission rules, a PreToolUse hook that blocks Azure deletes and Complete-mode deploys, and a PostToolUse hook that lints every Bicep file Claude edits.

## Requirements

- Claude Code 2.1.317 or later, signed in
- Azure CLI 2.89.0 or later with Bicep 0.48.1 or later, and `jq`
- Tested on macOS; the hooks are Bash scripts

## Setup

```bash
git clone https://github.com/CodeWithPraveen/yt-brezyweather-forecast-infra-guardrails && cd yt-brezyweather-forecast-infra-guardrails
claude   # accept the workspace trust prompt; project hooks and allow rules wait for it
```

The demo needs no Azure resources: the guard blocks its commands before they run. Read `.claude/hooks/` before you trust any repo that ships hooks; they run with your user permissions.

## Tear down

Nothing to delete. Remove the folder when you're done.
