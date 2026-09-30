[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1, 1900)]
    [string]$Message,

    [ValidateLength(1, 80)]
    [string]$Title = 'Ramesh Bhai Alert'
)

$webhookUrl = $env:DISCORD_WEBHOOK_URL
if ([string]::IsNullOrWhiteSpace($webhookUrl)) {
    $webhookUrl = [Environment]::GetEnvironmentVariable('DISCORD_WEBHOOK_URL', 'User')
}

if ([string]::IsNullOrWhiteSpace($webhookUrl)) {
    throw 'DISCORD_WEBHOOK_URL is not configured.'
}

$webhookUri = [Uri]$webhookUrl
if ($webhookUri.Scheme -ne 'https' -or $webhookUri.Host -notin @('discord.com', 'discordapp.com')) {
    throw 'DISCORD_WEBHOOK_URL must be an HTTPS Discord webhook URL.'
}

$payload = @{
    username = 'Ramesh Bhai'
    content  = "**$Title**`n$Message"
} | ConvertTo-Json -Compress

Invoke-RestMethod -Method Post -Uri $webhookUri -ContentType 'application/json' -Body $payload | Out-Null
