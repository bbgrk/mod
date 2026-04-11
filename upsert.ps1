param(
    [Parameter(Mandatory = $true)]
    [string]$JsonPath,

    [Parameter(Mandatory = $true)]
    [string]$WebhookUrl
)

if (-not (Test-Path $JsonPath)) {
    throw "JSON file not found at path: $JsonPath"
}

$WebhookUrl = $WebhookUrl.Trim()
$jsonContent = Get-Content -Path $JsonPath -Raw -Encoding UTF8

try {
    $dataArray = $jsonContent | ConvertFrom-Json -ErrorAction Stop
} catch {
    throw "Invalid JSON format in file: $JsonPath"
}

$headers = @{
    "Content-Type" = "application/json; charset=utf-8"
}

foreach ($entry in $dataArray) {
    $messageId      = $entry.messageId
    $messageContent = $entry.messageContent

    # Serialize only the messageContent for the request body
    $body      = $messageContent | ConvertTo-Json -Depth 100 -Compress
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)

    if ($messageId) {
        $uri    = "$WebhookUrl/messages/$messageId"
        $method = "Patch"
    } else {
        $uri    = $WebhookUrl
        $method = "Post"
    }

    try {
        Invoke-RestMethod -Method $method -Uri $uri -Body $bodyBytes -Headers $headers
        Write-Output "[$method] $uri OK"
    } catch {
        Write-Error "[$method] $uri FAILED: $($_.Exception.Message)"
    }
}