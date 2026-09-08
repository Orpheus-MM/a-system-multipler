#!/bin/bash
set -euo pipefail

REPO="/Users/madison.moore/workspace/system-multiplier"
CLAUDE="/Users/madison.moore/.aisuite/bin/claude"
PRIVATE="$HOME/.system-multiplier-private-reports"
LOG_DIR="$REPO/automation/logs"
STATE_DIR="$REPO/automation/state"
DATE="$(date +%F)"

mkdir -p "$LOG_DIR" "$STATE_DIR" "$REPO/reports/private"
printf '{"name":"Nightly Slack digest","type":"launchd","status":"running","updated":"%s"}\n' "$(date -u +%FT%TZ)" > "$STATE_DIR/nightly-slack-digest.json"

finish() {
  status="$1"
  printf '{"name":"Nightly Slack digest","type":"launchd","status":"%s","updated":"%s"}\n' "$status" "$(date -u +%FT%TZ)" > "$STATE_DIR/nightly-slack-digest.json"
}
trap 'finish failed' ERR

if [ ! -d "$PRIVATE/.git" ]; then
  git clone --single-branch --branch private-reports \
    "https://git.soma.salesforce.com/madison-moore/system-multiplier.git" "$PRIVATE"
fi

mkdir -p "$PRIVATE/daily"
cp "$REPO/automation/config/slack-channels.json" "$PRIVATE/slack-channels.json"
cp "$REPO/automation/prompts/nightly-slack-digest.md" "$PRIVATE/nightly-slack-digest.md"

PROMPT="$(cat "$REPO/automation/prompts/nightly-slack-digest.md")

Private report repository: $PRIVATE
Today's date: $DATE
Write the Markdown report to $PRIVATE/daily/$DATE-slack-digest.md and update $PRIVATE/daily/reports.js. Do not write reports into the application repository. Do not read DMs or any channel absent from $REPO/automation/config/slack-channels.json."

cd "$REPO"
"$CLAUDE" -p \
  --model sonnet \
  --max-budget-usd 10 \
  --permission-mode dontAsk \
  --no-session-persistence \
  --add-dir "$PRIVATE" \
  --allowedTools "Read,Write,Edit,mcp__plugin_slack_slack__slack_read_channel,mcp__plugin_slack_slack__slack_read_thread,mcp__plugin_slack_slack__slack_search_public" \
  -- "$PROMPT" > "$LOG_DIR/$DATE.log" 2>&1

cp "$PRIVATE/daily/reports.js" "$REPO/reports/private/reports.js"
cp "$PRIVATE/daily/$DATE-slack-digest.md" "$REPO/reports/private/$DATE-slack-digest.md"

cd "$PRIVATE"
git add daily
if ! git diff --cached --quiet; then
  git commit -m "Add $DATE Slack digest"
  git push origin private-reports
fi

finish completed
