# Morning Slack Digest

Read `automation/config/slack-channels.json` first. Analyze only listed public channels for activity since previous report or, when no prior report exists, previous 24 hours.

## Privacy boundary

- Never read direct messages, group DMs, 1:1 messages, or unlisted channels.
- Include a thread whenever Madison Moore is tagged, but only when its parent channel is listed.
- Do not post, react, edit, or send Slack messages.
- Preserve source links and timestamps.

## Analysis

Prioritize `primary_action_projects` for requests, commitments, decisions, risks, blockers, and dates. Use `research_learning` for relevant insights, product changes, customer evidence, methods, and learning opportunities. Use `tips_workflows` to select one fresh, concrete tip, example, tool use, or workflow worth trying.

The Learn card should feel conversational and specific. Prefer formats such as:

- "Hey, [person] used [tool/method] to [result]. Check it out."
- "New workflow to try: [short workflow]. Use it when [situation]."

Name the person when attribution is available. Explain why it is relevant to Madison's design or AI practice. Include one small next step and source link. Never invent a result, workflow, or attribution. If nothing useful appeared since the previous report, say so rather than recycling an old tip.

For every tagged thread include:

1. Original message and source link
2. Short overview
3. What is needed from Madison
4. Recommended follow-up timing
5. Editable scripted response

Separate facts, interpretations, and recommendations. Do not treat discussion as a decision. Deduplicate cross-posts. Exclude routine chatter and items with no plausible relevance.

## Output

Create `reports/daily/YYYY-MM-DD-slack-digest.md` with a morning brief covering activity since the previous report:

- Today's overview
- Act today, maximum 3
- Decisions needed, maximum 2
- Tagged threads
- Primary project changes
- Research and learning, maximum 3, with the first item reserved for one fresh conversational tip or workflow when available
- Watch or ignore
- Sources reviewed

Then update `reports/daily/reports.js`. It must assign `window.SYSTEM_MULTIPLIER_REPORTS` to an array of newest-first objects using this contract:

```js
window.SYSTEM_MULTIPLIER_REPORTS = [{
  date: "YYYY-MM-DD",
  title: "Nightly Slack digest",
  overview: "Short synthesis",
  reportPath: "reports/private/YYYY-MM-DD-slack-digest.md",
  actions: [{title: "...", detail: "...", source: "https://..."}],
  decisions: [{title: "...", detail: "...", source: "https://..."}],
  tagged: [{channel: "...", message: "...", overview: "...", needed: "...", timing: "...", script: "...", source: "https://..."}],
  learning: [{title: "...", detail: "...", source: "https://..."}]
}];
```

Keep existing valid report objects and prepend new report. Commit changed report files and push current branch. Do not modify application source.
