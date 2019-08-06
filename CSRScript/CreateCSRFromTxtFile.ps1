#Create a CSR for Servers from a Text File


$ServerList = $PSScriptRoot + "\Servers.txt"
$CSRTemplate = $PSScriptRoot + "\CSRTemplate.inf"
$CSR = $PSScriptRoot + "\CSRTemplate"

$TARGETDIR = $PSScriptRoot + "\Completed"
if (!(Test-Path -Path $TARGETDIR )) {
    New-Item -ItemType directory -Path $TARGETDIR
}

$COMPLETECSR = $PSScriptRoot + "\Completed"

$servers = Get-Content $ServerList
foreach ($server in $servers) {
    $CSRName = $CSR + "$server.inf"
    (Get-Content $CSRTemplate) | Foreach-Object { $_ -replace "@sitename", $server -replace "@domain", $server } | Set-Content $CSRName

    $CSRTemplateNew = $CSRName
    write-host "Creating Certificate Request" -ForegroundColor Yellow
    certreq -new $CSRTemplateNew $COMPLETECSR\$Server.req
    write-host "Done!" -ForegroundColor Yellow


    $Created = test-path -Path $COMPLETECSR\$Server.req

    if ($Created = "True") {
        Remove-Item -Path $CSRTemplateNew
    }
}