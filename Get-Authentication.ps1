
function Get-Authenticate {
    param (
        $domain = 'inucn.com'
$serverFQDN = $server + '.' + $domain
#Set Username
$user = [Environment]::UserName
$username = $user + '@' + $domain
#Set INUCN Credentials
#$pswdFile = read-host -Prompt "Enter INUCN Password" -assecurestring | convertfrom-securestring | `
#    out-file C:\Users\$user\Documents\inucn.txt
$password = Get-Content C:\Users\$user\Documents\inucn.txt | ConvertTo-SecureString
$inucnCred = new-object -typename System.Management.Automation.PSCredential `
    -argumentlist $username, $password
    )
    
}




