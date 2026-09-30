# Local Setup and Safety Notes

## Scope

This public repository is intentionally small. It contains local notification and audit utilities—not a brokerage client, a trading strategy engine, credentials, or user account data.

## Environment variables

`send-discord-alert.ps1` reads `DISCORD_WEBHOOK_URL` from the current process first, then from the current Windows user’s environment variables. Keep it in your operating system’s secret-management flow; never write it to this repository or a committed `.env` file.

## Data handling

The audit utility writes to `data/agent-events.jsonl`. Git ignores that directory because audit records can contain operational context that simply does not belong in a public repository.

`write-agent-log.ps1` redacts common webhook URLs, access-token prefixes, credential assignments, and long numbers before writing. Think of redaction as a seat belt, not an excuse to skip reviewing a summary before it is logged.

## Suggested development workflow

1. Start in paper-trading or research mode.
2. Use non-sensitive messages when testing Discord delivery.
3. Check `git status` and `git diff --cached` before each commit.
4. Keep any brokerage execution adapter in a separate private repository with an explicit risk policy and independent security review.

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
