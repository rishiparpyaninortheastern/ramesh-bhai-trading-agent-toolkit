[CmdletBinding()]
param(
    [ValidateRange(1, 200)]
    [int]$Last = 20
)

$projectRoot = Split-Path -Parent $PSScriptRoot
$logPath = Join-Path $projectRoot 'data\agent-events.jsonl'

if (-not (Test-Path -LiteralPath $logPath)) {
    Write-Output 'No agent events have been logged yet.'
    return
}

$events = Get-Content -LiteralPath $logPath | ForEach-Object {
    if (-not [string]::IsNullOrWhiteSpace($_)) {
        try { $_ | ConvertFrom-Json } catch { $null }
    }
} | Where-Object { $_ }

$events |
    Select-Object -Last $Last |
    Select-Object timestamp_utc, agent, event_type, status, summary |
    Format-Table -Wrap
