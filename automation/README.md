# Automation

Nightly Slack digest scope and output contract.

## Prerequisites

- Claude Unleashed CLI installed at `~/.claude-unleashed/bin/cu`
- CU daemon running
- Slack plugin enabled and authenticated
- Read access to channels in `config/slack-channels.json`

Native workflow uses AI Expert Suite Claude CLI, Slack MCP, and macOS `launchd`. CU is not required.

## Schedule

Runs at 6:00 AM local time on weekdays. Slack tools are read-only and restricted by prompt/config to listed channels. Direct and group messages are denied. Generated reports commit only to private git.soma branch `private-reports`; `reports/private/` is ignored by public application branch.

`automation/run-nightly.sh` runs analysis and report writing. `automation/com.salesforce.system-multiplier.nightly.plist` defines cadence.

Install schedule:

```bash
cp automation/com.salesforce.system-multiplier.nightly.plist ~/Library/LaunchAgents/
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.salesforce.system-multiplier.nightly.plist
```

Review first generated report for privacy, source fidelity, and useful prioritization.
