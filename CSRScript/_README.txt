#Copy the CSRScript Folder to a Directory
#Update the Servers.txt file with the hosts you want to generate a CSR for.
#CSR parameters may be adjusted as required in the CSRTemplate.inf

#Create a CSR for Servers from a Text File
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


#Example in Servers.txt
LAX-Servername.Domain.com

#CSRTemplate.inf:

#CSRTemplate.inf:

[Version] 
Signature="$Windows NT$"

[NewRequest]
Subject = "CN=@domain, O=NICE inContact, OU=WFO Architecture, L=Sandy, S=UT"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
KeySpec = 1
KeyLength = 2048
KeyUsage = 0xA0
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ProviderType = 12
MachineKeySet = True
Exportable = TRUE
FriendlyName=server1

[Strings]  
szOID_PKIX_KP_SERVER_AUTH = "1.3.6.1.5.5.7.3.1"