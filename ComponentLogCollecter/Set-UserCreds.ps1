
function Set-UserCreds {
    $enviro = Read-Host "What Environment? Prod, Lab or Other?"
    $noCreds = "true"
    #param($enviro)
    #Set Lab Credentials
    if ($enviro -like "Lab") {
        $domain = 'ucn\'
        $user = [Environment]::UserName
        $username = $domain + $user
        $noCreds = "false"
        $LabCreds = Test-Path -Path "C:\Users\$user\Documents\Lab.txt"
    
        if ($LabCreds -like 'False') {
            $pswdFile = read-host -Prompt "Enter Lab Password" -assecurestring | convertfrom-securestring | `
                out-file C:\Users\$user\Documents\Lab.txt
        }
        else {
            $password = Get-Content C:\Users\$user\Documents\Lab.txt | ConvertTo-SecureString
        }
        $MyCred = New-Object -typename System.Management.Automation.PSCredential `
            -argumentlist $username, $password

        #$VC = 'eng-vmvce01.in.lab'
        #Connect-VIServer -Server $VC -Credential $MyCred
    }

    if ($enviro -like "Prod") {
        $domain = 'inucn.com'
        $user = [Environment]::UserName
        $username = $user + '@' + $domain
        $noCreds = "false"
        $ProdCreds = Test-Path -Path "C:\Users\$user\Documents\Prod.txt"
    
        if ($ProdCreds -like 'False') {
            $pswdFile = read-host -Prompt "Enter Prod Password" -assecurestring | convertfrom-securestring | `
                out-file C:\Users\$user\Documents\Prod.txt
        }
        else {
            $password = Get-Content C:\Users\$user\Documents\Prod.txt | ConvertTo-SecureString
        }

        $MyCred = New-Object -typename System.Management.Automation.PSCredential `
            -argumentlist $username, $password

        #foreach ($vc in $vcs) {
        #    $VCs = 'lax-vmvce01.inucn.com', 'dal-vmvce01.inucn.com', 'lax-vmvce01.inucn.com'
        #    Connect-VIServer -Server $VC -Credential $MyCred
        #} 
    }
    if ($enviro -like "Other") {
        
        $domain = Read-Host "Please Set domain name"
        $user = [Environment]::UserName
        $LabCreds = Test-Path -Path "C:\Users\$user\Documents\$domain.txt"
        if ($LabCreds -like 'False') {
            $username = $domain + $user
            $ConfirmDomain = Read-Host "$username, Is this correct? Y or N?"
            if ($ConfirmDomain -contains "N") {
                $username = $user + '@' + $domain
                $ConfirmDomain = Read-Host "$username, Is this correct? Y or N?"
                if ($ConfirmDomain -contains "N") {
                    $username = Read-Host "Please write username and domain in the format required"
                }
            }
            
            $pswdFile = read-host -Prompt "Enter $domain Password" -assecurestring | convertfrom-securestring | `
                out-file C:\Users\$user\Documents\$domain.txt
        }
        else {
            $password = Get-Content C:\Users\$user\Documents\$domain.txt | ConvertTo-SecureString
        }
        $MyCred = New-Object -typename System.Management.Automation.PSCredential `
            -argumentlist $username, $password
        $noCreds = "false"
    }
    elseif ($noCreds -like "true") {
        Write-Host "No Domain Selected"
        Set-UserCreds
    }
    return $MyCred
}