#Set Domain
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Write-host "My directory is $dir"
Push-location $dir

. .\Show-Menu.ps1
. .\Set-UserCreds.ps1
$domain = "NULL"
$Section = "Domain"
$dom = $PSScriptRoot + "\domains.txt"
$list = get-content $dom
$domain = Show-menu -List $list -Section $Section

#Set Authentication
$MyCreds = Set-UserCreds -domain $domain


#Set the environment
#Set-Environment.ps1
$Section = "Environment"
$environments = $PSScriptRoot + "\$domain" + "Environments.txt"
$envlist = get-content $environments
$enviro = Show-menu -List $envlist
$enviro
#Set the module (configs, servicenames, processes, logfiles)
#Set-Module.ps1



#Modify config files to debug
#modify-configfile.ps1

#repair services and validate success
#repair-Service.ps1

#modify config files to info
#modify-configfile.ps1

#Collect logs
#collect-logs.ps1

#optional zip logs
#zip-files.ps1