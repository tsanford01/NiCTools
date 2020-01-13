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
