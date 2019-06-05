$List = @(Cat -Path C:\Scripts\Lists\Enviros.txt)

function Show-Menu { 
    param ( 
        [string]$Title = 'Server Choices'
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
            $enviro = Read-Host "What Environment? Prod or Lab?"
            if ($enviro -like "Lab") {
                $domain = 'ucn\'
                $user = [Environment]::UserName
                $username = $domain + $user
    
                $password = Get-Content C:\Users\$user\Documents\inucn.txt | ConvertTo-SecureString
                $inucnCred = New-Object -typename System.Management.Automation.PSCredential `
                    -argumentlist $username, $password
        
                $VCs = 'eng-vmvce01.in.lab'
                foreach ($vc in $vcs) {
                    Connect-VIServer -Server $VC -Credential $inucnCred
                } 
            }
    
            else {
                $domain = 'inucn.com'
                $user = [Environment]::UserName
                $username = $user + '@' + $domain
                $VCs = 'lax-vmvce01.inucn.com', 'dal-vmvce01.inucn.com'
    
                $password = Get-Content C:\Users\$user\Documents\inucn.txt | ConvertTo-SecureString
                $inucnCred = New-Object -typename System.Management.Automation.PSCredential `
                    -argumentlist $username, $password
        
                foreach ($vc in $vcs) {
                    Connect-VIServer -Server $VC -Credential $inucnCred
                } 
            }
    
            $Servername = Read-Host "What computers do you want to get?"
    
            $outFile = "\\corpfs03.ucn.net\DFS-Root\AppOps\Engage\Tools\Scripts\Lists\$servername" + "list.csv"
    
            foreach ($Vc in $Vcs) {
                $Servers = Get-VM -Name "*$Servername*" -Server $Vc | Select Name 
                $Servers | Out-File $outFile
                Write-Host "Your file is located @ $outFile"
            }
        }
        'q' { 
            return 
        } 
    } 
    pause 
} 
until ($input -eq 'q') 
     
