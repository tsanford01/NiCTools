$List = @(Cat -Path "C:\Users\tony.valtinson\OneDrive - inContact, Inc\Power Shell\domain.xlsx")

function Show-Menu { 
    param ( 
        [string]$Title = 'Domain Choices'
    ) 
    $Listcount = ($List.Count - 1)
    cls 
    #using namespace System.Collections.Generic
    $ListVals = [List[int]]@(0..$Listcount)
    Write-Host "================ $Title ================" 
    for ($ListVal = 0; $ListVal -lt $List.length; $Listval++) {
        #$ListVal in $ListVals) 
        Write-Host $ListVal": Press $ListVal for" $List[$ListVal]"."
    } 
    Write-Host "Q: Press 'Q' to quit."         
} 
   
    function Get-Authenticate {
    param (
        [CmdletBinding()]
            [Parameter(Mandatory=$true)]
        [string] "Which domain would you like inucn or in?"
        [string] $domain
        )
    process (
        Write-Host ("The Domain chosen is " + $domain)
        
    )
        if ($domain){
        param (
        $Server = Get-Server
        )

        elseif (false)
        Write-Error [-Message] "Invalid Domain, please try again."
        }

    
        if ($Server){
        $serverFQDN = $server + '.' + $domain
        }

        elseif (false){
        Write-Error [-Message] "Invalid server, please try again."
        }

    param(
        $user = Get-User
    )
 
    if ($user){
        $username = $user + '@' + $domain
    }
    elseif (false) {
        Write-Error [-Message] "Invalid Username, please try again."
    }
}


do { 
    Show-Menu 

    $input = Read-Host "Please make a selection" 
    switch ($input) {
        '1' { 
            cls
            $NewValue = $input
            'You chose option #1 for ' + "$NewValue"
                
        } '2' { 
            cls 
            'You chose option #2' 
        } '3' { 
            cls 
            'You chose option #3' 
        }'4' { 
            cls 
            'You chose option #4' 
        } '5' { 
            cls 
            'You chose option #5' 
        } '6' { 
            cls 
            'You chose option #6'
        } '7' { 
            cls 
            'You chose option #7' 
        } '8' { 
            cls 
            'You chose option #8' 
        } '9' { 
            cls 
            'You chose option #9'
        } '0' { 
            cls 
            'You chose option #0'

        }
    
    }
}  until ($input -eq 'q')


 #Set INUCN Credentials
#$pswdFile = read-host -Prompt "Enter INUCN Password" -assecurestring | convertfrom-securestring | `
  #  out-file C:\Users\$user\Documents\inucn.txt
$password = Get-Content C:\Users\$user\Documents\inucn.txt | ConvertTo-SecureString

if ($password){
$inucnCred = new-object -typename System.Management.Automation.PSCredential `
    -argumentlist $username, $password
}
 elseif(false){
$pswdFile = read-host -Prompt "Enter INUCN Password" -assecurestring | convertfrom-securestring | `
    out-file C:\Users\$user\Documents\inucn.txt
 }


    



