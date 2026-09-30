# Ramesh Bhai Trading Agent Toolkit

A small, safety-first toolkit for operating and auditing a local, agent-assisted investing workflow. It contains notification and audit-log utilities—not brokerage credentials, account data, trading signals, or a promise of returns.

> **Status:** The live-trading workflow is intentionally paused. This repository is published as a portfolio/project artifact and should be run in research or paper-trading mode unless a separate, explicit operating policy enables it.

## What is included

- A PowerShell utility for sending concise Discord status alerts.
- A local JSONL event ledger with built-in redaction for common secrets and long numeric identifiers.
- A terminal command to inspect recent agent events.
- Git ignore rules that keep secrets, credentials, logs, and local operating policies out of source control.

## Design principles

1. **No secrets in Git.** Webhook URLs, broker credentials, tokens, certificates, account information, and runtime logs stay local.
2. **Human-readable audit trail.** Agents record plain-language decisions and outcomes before reporting them.
3. **Least privilege.** Notification tooling reads its webhook only from an environment variable; it does not persist the value.
4. **Research before execution.** Any brokerage integration should be isolated from research and should require a separately reviewed risk policy.
5. **No performance claims.** Investing involves risk; this project is operational tooling, not investment advice.

## Quick start

### Prerequisites

- Windows PowerShell 5.1+ or PowerShell 7+
- A Discord webhook stored outside the repository, if alerts are desired

Set the webhook only in your local user or process environment:

```powershell
$env:DISCORD_WEBHOOK_URL = 'https://discord.com/api/webhooks/…'
```

Do not commit that value, add it to a prompt, or copy it into an issue or pull request.

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

## Security checklist before publishing

- [x] No webhook URL or brokerage credential is committed.
- [x] No account balances, account numbers, order IDs, or runtime logs are committed.
- [x] Local secret and log patterns are ignored by Git.
- [x] Alert input is validated and audit summaries are redacted.
- [ ] Review staged files before every push: `git diff --cached --check`

## Project timeline

- **August 2026:** Initial local automation utilities, safety controls, and audit workflow created.
- **September 2026:** Public-safe documentation and repository hygiene prepared.

## Disclaimer

This repository is for educational and operational-tooling purposes. It is not financial, legal, or tax advice. Nothing here guarantees investment performance or authorizes unattended brokerage activity.
