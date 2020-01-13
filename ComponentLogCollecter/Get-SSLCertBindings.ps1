using namespace System.Collections.Generic

function Show-Menu { 
    #using namespace System.Collections.Generic --Make sure this is at the top of the script
    param (
        [String]$Section = 'Please Select' + " $Section",
        [Parameter(Mandatory = $true)] $List
        #[REF]$output
    ) 
    $Listcount = ($List.Count - 1)
    cls 
    
    $ListVals = [List[int]]@(0..$Listcount)
    Write-Host "================ $Section ================" 
    for ($ListVal = 0; $ListVal -lt $List.length; $Listval++) {
        #$ListVal in $ListVals) 
        Write-Host $ListVal": Press `"$ListVal`" for" $List[$ListVal]

    } 
    Write-Host "Q: Press 'Q' to quit."
    $val = Read-Host "Please make a selection"
    $output = $list[$val]
    return $output
}

#Set Domain
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Write-host "My directory is $dir"
Push-location $dir

function Set-UserCreds {
    param(
        [string]$domain
        #[REF]$MyCred
    )
    $noCreds = "true"
    if ($domain -like "NULL") {
        $domain = Read-Host "What Environment? Prod, Lab or Other?"
        $noCreds = "false"
    }
    
    #Set Lab Credentials
    if ($domain -like "Lab") {
        $domainname = 'ucn\'
        $user = [Environment]::UserName
        $username = $domainname + $user
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

    elseif ($domain -like "Prod") {
        $domainname = 'inucn.com'
        $user = [Environment]::UserName
        $username = $user + '@' + $domainname
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


    }
    elseif ($domain -like "Other") {
        
        $domainname = Read-Host "Please Set domain name"
        $user = [Environment]::UserName
        $LabCreds = Test-Path -Path "C:\Users\$user\Documents\$domainname.txt"
        if ($LabCreds -like 'False') {
            $username = $domainname + $user
            $ConfirmDomain = Read-Host "$username, Is this correct? Y or N?"
            if ($ConfirmDomain -contains "N") {
                $username = $user + '@' + $domainname
                $ConfirmDomain = Read-Host "$username, Is this correct? Y or N?"
                if ($ConfirmDomain -contains "N") {
                    $username = Read-Host "Please write username and domain in the format required"
                }
            }
            
            $pswdFile = read-host -Prompt "Enter $domainname Password" -assecurestring | convertfrom-securestring | `
                out-file C:\Users\$user\Documents\$domainname.txt
        }
        else {
            $password = Get-Content C:\Users\$user\Documents\$domainname.txt | ConvertTo-SecureString
        }
        $MyCred = New-Object -typename System.Management.Automation.PSCredential `
            -argumentlist $username, $password
        $noCreds = "false"
    }
    elseif ($noCreds -like "true") {
        Write-Host "No Domain Selected"
        $domain = "NULL"
        Set-UserCreds -domain NULL
    }
    return $MyCred
}

. .\Show-Menu.ps1
. .\Set-UserCreds.ps1
$domain = "NULL"
$Section = "Domain"
$dom = $PSScriptRoot + "\domains.txt"
$list = get-content $dom
$domain = Show-menu -List $list -Section $Section

#Set Authentication
$MyCreds = Set-UserCreds -domain $domain


#<#
$Servers = (
    "lax-enapp01",
    "lax-enapp02",
    "lax-eninc01",
    "lax-eninc02",
    "lax-eninc05",
    "lax-eninc06",
    "lax-eninc07",
    "lax-eninc08",
    "lax-eninc09",
    "lax-eninc10",
    "lax-enstr01",
    "lax-enstr02",
    "lax-enair01",
    "lax-enair02",
    "lax-enair03",
    "lax-enair04",
    "lax-enair05",
    "lax-enair06",
    "lax-enair07",
    "lax-enair08",
    "lax-enair09",
    "lax-enair10",
    "lax-enair11",
    "lax-enair12",
    "lax-enair13",
    "lax-enarc01",
    "lax-enarc02",
    "lax-enint01",
    "lax-endbs01",
    "lax-endbs02",
    "lax-endms01",
    "lax-endms02",
    "lax-ensen01"
)
#>


foreach ($Server in $Servers) {

    $LogFile = "F:\TestOutput\$Server.certbindings.txt"
    
    $admin = Invoke-Command -ComputerName $Server -ErrorAction SilentlyContinue -Credential $MyCreds -ScriptBlock { netsh http show sslcert }
$Admin | out-file $logFile -Force

}
