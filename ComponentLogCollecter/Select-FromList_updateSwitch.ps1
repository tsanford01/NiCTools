using namespace System.Collections.Generic
#.\Set-UserCreds.ps1


$Path = $PSScriptRoot + "\Playback_Tool_Options.txt"
$List = @(Cat -Path $Path)

function Show-Menu { 
    #using namespace System.Collections.Generic --Make sure this is at the top of the script
    param ( 
        [string]$Title = 'Please Select'
    ) 
    $Listcount = ($List.Count - 1)
    cls 
    
    $ListVals = [List[int]]@(0..$Listcount)
    Write-Host "================ $Title ================" 
    for ($ListVal = 0; $ListVal -lt $List.length; $Listval++) {
        #$ListVal in $ListVals) 
        Write-Host $ListVal": Press `"$ListVal`" for" $List[$ListVal]

    } 
    Write-Host "Q: Press 'Q' to quit."         
} 

function Set-Switch {

}
    
do { 
    Show-Menu 

    $input = Read-Host "Please make a selection"
    $n = 0
    
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
            $NewValue = $input
            'You chose option #3 for ' + "$NewValue"
            $domain = Read-Host "What Environment? Prod, Lab or Other?"
            Set-UserCreds -domain $domain
            #Set-UserCreds
            .\Repair-PlaybackStreaming.ps1
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
        'q' { 
            return 
        } 
    } 
    pause 
} 
until ($input -eq 'q') 
     
