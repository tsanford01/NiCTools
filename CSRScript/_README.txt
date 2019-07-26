#Copy the CSRScript to D Partition
#Update the Servers.txt file with the hosts you want to generate a CSR for.
#CSR parameters may be adjusted as required in the CSRTemplate.ini

#Create a CSR for Servers from a Text File
$servers = Get-Content "D:\CSRScript\Servers.txt"
foreach ($server in $servers){
(Get-Content D:\CSRScript\CSRTemplate.inf) |Foreach-Object {$_ -replace "@sitename", $server -replace "@domain", $server }| Set-Content D:\CSRScript\CSRTemplate$server.inf
write-host "Creating Certificate Request" -ForegroundColor Yellow
certreq -new "D:\CSRScript\CSRTemplate.inf" c:\CSRScript\$Server.req
write-host "Done!" -ForegroundColor Yellow


#Example
#Servers.txt:

server1
server2
server3


#CSRTemplate.inf:

[Version] 
Signature="$Windows NT$"

[NewRequest]
Subject = "CN=@domain, O=NICE inContact, OU=WFO Architecture, L=Sandy, S=UT"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
MachineKeySet = TRUE
Exportable = TRUE
MachineKeySet = TRUE
Exportable = TRUE
MachineKeySet = TRUE
FriendlyName=@sitename

[EnhancedKeyUsageExtension]

OID=1.3.6.1.5.5.7.3.1 