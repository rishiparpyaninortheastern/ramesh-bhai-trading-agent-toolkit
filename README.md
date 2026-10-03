# Ramesh Bhai Trading Agent Toolkit

I started this as a small experiment: what would it take to make an agent-assisted investing workflow feel less like a black box?

The answer was not a clever stock-picking model. It was the unglamorous work around it—clear boundaries, plain-English notes, a record of what happened, and a deliberate refusal to treat automation as a substitute for judgment. Markets are not predictable; this project is about making the operational parts visible, reviewable, and safer.

This repository contains the public-safe notification and audit utilities from that experiment. It does **not** include brokerage credentials, account data, trading signals, or a promise of returns.

> **Status:** Live trading is intentionally paused. This is a portfolio project and a small record of how I think about safe automation. It is designed for research or paper trading unless a separately reviewed policy explicitly enables execution.

## The goal

The goal was to separate three things that are too often blurred together:

- **Research:** What did we look at, and why did it matter?
- **Operations:** What did an agent do, what did it decide not to do, and where is that written down?
- **Execution:** If real money is ever involved, what explicit policy, controls, and human oversight must exist first?

This public repository focuses on the first two. Execution belongs in a separate, private environment with its own security review and risk policy.

## What I built

- A PowerShell utility for concise Discord status alerts.
- A local JSONL event ledger that redacts common secrets and long numeric identifiers.
- A quick terminal view of recent agent activity.
- Git ignore rules that keep secrets, credentials, logs, and local operating policies out of source control.

## What I was trying to get right

Most automation failures are not dramatic bugs. They are small omissions: a secret copied into a config file, an alert without context, or a decision nobody can reconstruct later. So the project intentionally leans toward small, inspectable tools.

- Alerts should be brief enough to read, but useful enough to explain what changed.
- Logs should tell a story in ordinary language, not just preserve machine events.
- Sensitive details should stay local by default.
- A “no action” decision deserves a record too.

For the longer project narrative—including what changed during the build and what I would tackle next—see [Project story](docs/PROJECT_STORY.md).

## Guardrails I kept coming back to

1. **Secrets stay local.** Webhook URLs, broker credentials, tokens, certificates, account information, and runtime logs do not belong in Git.
2. **Decisions should be readable.** An agent should leave behind a plain-language explanation, not a mysterious trail of API calls.
3. **Keep access narrow.** The alert utility reads its webhook from an environment variable and never stores it.
4. **Research comes first.** Any brokerage integration should be separate from research and subject to its own reviewed risk policy.
5. **No magic-return claims.** Investing carries risk. This is operational tooling, not investment advice.

## Run it locally

### What you’ll need

- Windows PowerShell 5.1+ or PowerShell 7+
- A Discord webhook stored outside the repository, if alerts are desired

If you want alerts, set the webhook in your local user or process environment:

```powershell
$env:DISCORD_WEBHOOK_URL = 'https://discord.com/api/webhooks/…'
```

Please do not commit that value, add it to a prompt, or paste it into an issue or pull request.

### Send a test alert

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\send-discord-alert.ps1 `
  -Title 'Research status' `
  -Message 'Paper-trading workflow initialized. No order was placed.'
```

### Write an audit event

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\write-agent-log.ps1 `
  -Agent 'Ramesh Bhai Scout' `
  -EventType research_run `
  -Status completed `
  -Summary 'Reviewed a paper-trading candidate. No order was placed.'
```

### Inspect recent events

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\get-agent-log.ps1 -Last 20
```

Events are written locally to `data/agent-events.jsonl`, which is intentionally ignored by Git.

## Repository layout

```text
scripts/
  send-discord-alert.ps1  # Validates and sends a Discord webhook payload
  write-agent-log.ps1     # Records redacted local JSONL audit events
  get-agent-log.ps1       # Formats recent audit events for the terminal
```

## Before you publish or share it

- [x] No webhook URL or brokerage credential is committed.
- [x] No account balances, account numbers, order IDs, or runtime logs are committed.
- [x] Local secret and log patterns are ignored by Git.
- [x] Alert input is validated and audit summaries are redacted.
- [ ] Review staged files before every push: `git diff --cached --check`

## Project timeline

- **August 2026:** Built the first local automation utilities, safety controls, and audit workflow.
- **September 2026:** Prepared a public-safe repository: scrubbed the scope, added setup notes, and kept local policy and runtime data out of Git.
- **October 2026:** Expanded the documentation into a clearer narrative for future sharing and a longer Medium write-up.

## Disclaimer

This repository is for educational and operational-tooling purposes. It is not financial, legal, or tax advice. Nothing here guarantees investment performance or authorizes unattended brokerage activity.
