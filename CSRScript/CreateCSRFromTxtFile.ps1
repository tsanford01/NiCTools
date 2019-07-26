#Create a CSR for Servers from a Text File
$PSScriptRoot
$PSCommandPath


$ServerList = "F:\Tools\CSRScript\Servers.txt"
$CSRTemplate = "F:\Tools\CSRScript\CSRTemplate.inf"
$CSR = "F:\Tools\CSRScript\CSRTemplate"
$servers = Get-Content $ServerList
foreach ($server in $servers) {
    (Get-Content $CSRTemplate) | Foreach-Object { $_ -replace "@sitename", $server -replace "@domain", $server } | Set-Content $CSR$server.inf
}
$CSRTemplate = "$CSR$server.inf"
write-host "Creating Certificate Request" -ForegroundColor Yellow
certreq -new $CSRTemplate F:\Tools\CSRScript\CSRs\$Server.req
write-host "Done!" -ForegroundColor Yellow



