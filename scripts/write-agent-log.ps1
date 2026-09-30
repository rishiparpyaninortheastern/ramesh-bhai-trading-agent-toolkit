[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('Ramesh Bhai Scout', 'Ramesh Bhai Execution Desk')]
    [string]$Agent,

    [Parameter(Mandatory)]
    [ValidateSet('research_run', 'candidate', 'no_trade', 'policy_check', 'position_check', 'order_proposed', 'order_submitted', 'order_filled', 'order_rejected', 'order_cancelled', 'risk_stop', 'forced_exit', 'daily_summary', 'system')]
    [string]$EventType,

    [Parameter(Mandatory)]
    [ValidateSet('started', 'completed', 'skipped', 'failed')]
    [string]$Status,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1, 5000)]
    [string]$Summary
)

function Protect-LogText {
    param([string]$Text)

    $redacted = $Text
    $redacted = $redacted -replace 'https://(?:discord(?:app)?\.com)/api/webhooks/[^\s]+', '[REDACTED_DISCORD_WEBHOOK]'
    $redacted = $redacted -replace '\b(?:ghp|gho|ghu|ghs|github_pat)_[A-Za-z0-9_]+\b', '[REDACTED_TOKEN]'
    $redacted = $redacted -replace '(?i)\b(?:api[_-]?key|secret|password|authorization|token)\s*[:=]\s*\S+', '[REDACTED_CREDENTIAL]'
    $redacted = $redacted -replace '\b\d{8,}\b', '[REDACTED_NUMBER]'
    return $redacted
}

$projectRoot = Split-Path -Parent $PSScriptRoot
$logDirectory = Join-Path $projectRoot 'data'
$logPath = Join-Path $logDirectory 'agent-events.jsonl'

New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null

$event = [ordered]@{
    timestamp_utc = [DateTime]::UtcNow.ToString('o')
    agent        = $Agent
    event_type   = $EventType
    status       = $Status
    summary      = Protect-LogText $Summary
}

$event | ConvertTo-Json -Compress | Add-Content -LiteralPath $logPath -Encoding utf8
Write-Output "Logged $EventType event for $Agent."
