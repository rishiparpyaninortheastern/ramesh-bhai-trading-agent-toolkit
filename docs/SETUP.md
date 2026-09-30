# Local Setup and Safety Notes

## Scope

This public repository contains only local notification and audit utilities. It does not include a brokerage client, a trading strategy engine, credentials, or user account data.

## Environment variables

`send-discord-alert.ps1` reads the `DISCORD_WEBHOOK_URL` value from the current process first, then the current Windows user's environment variables. Store it through your operating-system secret-management approach; do not write it to this repository or any committed `.env` file.

## Data handling

The audit utility writes to `data/agent-events.jsonl`. That directory is ignored by Git because audit records can include operational context that is not appropriate for a public repository.

`write-agent-log.ps1` redacts common webhook URLs, access-token prefixes, credential assignments, and long numbers before writing. Treat redaction as a guardrail, not a substitute for reviewing summaries before logging them.

## Suggested development workflow

1. Run tooling in paper-trading or research mode first.
2. Use non-sensitive test messages when verifying Discord delivery.
3. Inspect `git status` and `git diff --cached` before committing.
4. Keep brokerage execution adapters in a separate private repository with an explicit risk policy and independent security review.

## Testing without a webhook

The log utilities can be exercised without network access:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\write-agent-log.ps1 `
  -Agent 'Ramesh Bhai Execution Desk' `
  -EventType system `
  -Status completed `
  -Summary 'Local smoke test completed. No order was placed.'

powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\get-agent-log.ps1 -Last 5
```
