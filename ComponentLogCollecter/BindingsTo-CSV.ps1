$EnviroName = "US1"
$Folder = "F:\TestOutput"
#$Folder | Get-ChildItem | Select Name

$files = $Folder | Get-ChildItem | Where { $_.extension -eq ".txt" }
$sslBindings = @()
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName
    
    
    #$server = $file.Substring($file.LastIndexOf("\") + 1).Replace(".certbindings.txt", "")
    $server = $file.name.Replace(".certbindings.txt", "")
 

    for ($I = 0; $I -lt $content.Count; $I++) {
        if ($content[$I].Contains("IP:port")) {
            $sslBindings += New-Object PSObject -Property @{
                Server        = $server
                "IP:port"     = ($content[$I] -split " : ")[1]
                Hash          = ($content[$I + 1] -split " : ")[1]
                ApplicationID = ($content[$I + 2] -split " : ")[1]
                StoreName     = ($content[$I + 3] -split " : ")[1]
            }
        }
    }
}
 

$sslBindings | Select Server, "IP:port", Hash, ApplicationID, StoreName | Export-Csv -Path "$Folder\$EnviroName.csv" -NoTypeInformation -Append

