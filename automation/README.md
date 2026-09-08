# Automation

Nightly Slack digest scope and output contract.

## Prerequisites

- Claude Unleashed CLI installed at `~/.claude-unleashed/bin/cu`
- CU daemon running
- Slack plugin enabled and authenticated
- Read access to channels in `config/slack-channels.json`

Current machine resolves `cu` to macOS `/usr/bin/cu`, not Claude Unleashed. Install or repair PATH before activation.

## Intended schedule

Runs at 6:00 PM local time on weekdays. Agent must permit Slack read/search, repository read/write, and Git commit/push only. It must deny Slack posting and direct-message access.

```bash
cu schedules add nightly-slack-digest \
  --kind run \
  --target "/Users/madison.moore/workspace/system-multiplier" \
  --cron "0 18 * * 1-5" \
  --agent nightly-slack-reporter \
  --model opusplan \
  --max-turns 200 \
  --max-budget-usd 10 \
  --no-multiturn \
  --disable-slash-commands \
  --slack-announce off \
  --prompt-file "/Users/madison.moore/workspace/system-multiplier/automation/prompts/nightly-slack-digest.md"
```

Before enabling unattended runs:

```bash
cu schedules validate-cron "0 18 * * 1-5" --json
cu schedules run-now nightly-slack-digest --json
cu schedules history nightly-slack-digest --json
```

Review first generated report for privacy, source fidelity, and useful prioritization.
