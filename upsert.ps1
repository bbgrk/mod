param(
    [Parameter(Mandatory = $true)]
    [string]$JsonPath,

    [Parameter(Mandatory = $true)]
    [System.Uri]$WebhookUrl
)
if (-not (Test-Path $JsonPath)) {
    throw "JSON file not found at path: $JsonPath"
}
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
    $body      = $messageContent | ConvertTo-Json -Depth 100 -Compress
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $builder = [System.UriBuilder]$WebhookUrl
    if ($messageId) {
        $builder.Path = "$($WebhookUrl.AbsolutePath)/messages/$messageId"
        $method = "Patch"
    } else {
        $builder.Path = $WebhookUrl.AbsolutePath
        $method = "Post"
    }
    $builder.Query = "wait=true&with_components=true"
    $uri = $builder.Uri.AbsoluteUri
    try {
       Invoke-RestMethod -Method $method -Uri $uri -Body $bodyBytes -Headers $headers
       Write-Output "[$method] OK"
    } catch {
       Write-Error "[$method] FAILED: $($_.Exception.Message)"
    }
}