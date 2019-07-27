$enviro = Read-Host "What Environment? Prod or Lab?"

#Set Lab Credentials
if ($enviro -like "Lab") {
    $domain = 'ucn\'
    $user = [Environment]::UserName
    $username = $domain + $user

    $LabCreds = Test-Path -Path C:\Users\$user\Documents\Lab.txt
    
    if ($LabCreds = 'False') {
        $pswdFile = read-host -Prompt "Enter Lab Password" -assecurestring | convertfrom-securestring | `
            out-file C:\Users\$user\Documents\Lab.txt
    }
    else {
        $password = Get-Content C:\Users\$user\Documents\Lab.txt | ConvertTo-SecureString
    }
    $MyCred = New-Object -typename System.Management.Automation.PSCredential `
        -argumentlist $username, $password

    $VC = 'eng-vmvce01.in.lab'
    Connect-VIServer -Server $VC -Credential $MyCred
}

else {
    $domain = 'inucn.com'
    $user = [Environment]::UserName
    $username = $user + '@' + $domain
    
    $ProdCreds = Test-Path -Path C:\Users\$user\Documents\Prod.txt
    
    if ($ProdCreds = 'False') {
        $pswdFile = read-host -Prompt "Enter Prod Password" -assecurestring | convertfrom-securestring | `
            out-file C:\Users\$user\Documents\Prod.txt
    }
    else {
        $password = Get-Content C:\Users\$user\Documents\Prod.txt | ConvertTo-SecureString
    }

    $MyCred = New-Object -typename System.Management.Automation.PSCredential `
        -argumentlist $username, $password

    foreach ($vc in $vcs) {
        $VCs = 'lax-vmvce01.inucn.com', 'dal-vmvce01.inucn.com', 'lax-vmvce01.inucn.com'
        Connect-VIServer -Server $VC -Credential $MyCred
    } 
}