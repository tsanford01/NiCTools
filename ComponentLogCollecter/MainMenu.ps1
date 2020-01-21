
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Write-host "My directory is $dir"
Push-location $dir

. .\Show-Menu.ps1
. .\Set-UserCreds.ps1

#Set Domain
function Set-Domain {
    $domain = ""
    $Section = "Domain"
    $dom = $PSScriptRoot + "\domains.txt"
    $list = get-content $dom
    $domain = Show-menu -List $list -Section $Section
    return $domain
}
$domain = Set-Domain
write-host $domain

#Set-Product
function Set-Product {
    $product = ""
    $Section = "Product"
    #$pro = "C:\Users\travis.sanford\Documents\GitHub\NiCTools\ComponentLogCollecter\products.txt"
    $pro = $PSScriptRoot + "\products.txt"
    $list = get-content $pro
    $product = Show-menu -List $list -Section $Section
    return $product
}
$product = Set-Product
write-host $product

#Set Authentication
#$MyCred = Set-UserCreds -domain $domain
$mycred = Set-UserCreds -domain $domain


#Set the environment
#Set-Environment.ps1
function Set-Environment {
    $Section = "Environment"
    $environments = $PSScriptRoot + "\$domain" + "Environments.txt"
    $envlist = get-content $environments
    $enviro = Show-menu -List $envlist
    return $enviro
}
$enviro = Set-Environment
write-host $enviro


#Set the module (configs, servicenames, processes, logfiles)
#Set-Component.ps1
function Set-Components {
    $Section = "Component"
    $components = $PSScriptRoot + "\Components.txt"
    #Get-Content needs a explicit delimiter set so that when we have 1 single option it will not try to go byte by byte instead of line by line. This is per Dev.
    $complist = get-content $components
    $component = Show-menu -List $complist
    return $component
}
$component = Set-Components
write-host $component

#Set-Timeframe for query set

#Set Infratools query via tag variables

#Call Infratools via tags

#Modify config files to debug
#modify-configfile.ps1

#repair services and validate success
#repair-Service.ps1

#modify config files to info
#modify-configfile.ps1
#$deploy = "$PSScriptRoot + "\Get-ComponentLogFiles""

#Upload log collector script to destination "deploy"
#<function Deploy-Collector
#{
#Copy-Item -Path "$deploy" -Destination
# }
#Deploy-Collector



#Collect logs
#Collect-logs.ps1

#optional zip logs
#zip-files.ps1