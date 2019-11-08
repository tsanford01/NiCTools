
function Zip-Files( $zipfilename, $sourcedir ) {
    Add-Type -Assembly System.IO.Compression.FileSystem
    $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
        $zipfilename, $compressionLevel, $false)
}

#Example
#   $path = "Files"
#   $zipfile = "D:\temp\$path" + ".zip"
#   Zip-Files -zipfilename $zipfile -sourcedir $NewPath

function Unzip-Files {
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

#Example
#    Unzip-Files "C:\a.zip" "C:\a"

$user = [Environment]::UserName
$machinename = [Environment]::MachineName



if ($components = "playback") { 

    $componentArray = @(
        "retriever"
        'playback'
        'SNMP'
        'stream'
        'storageprepare'
           )
}

elseif ($components = "Screens") {
    $componentArray = @(
        'call_server'
        'ScreenCapture'
        'SIPStack'
        'RCM'
       )
}



elseif ($components = "Streaming") {
    $componentArray = @(
        'screen'
        'callserver'
        'NiceApplications'
    )
}
<#
elseif ($components = "Screens") {
    $componentArray = @(
        'screen'
        'callserver'
    )
}
elseif ($components = "Screens") {
    $componentArray = @(
        'screen'
        'callserver'
    )
}
elseif ($components = "Screens") {
    $componentArray = @(
        'screen'
        'callserver'
    )
}
#>
<#
'WCF'
'connectionmanager'
'ipcapture'
'kai'
'rtvb'
'keepalive'
'monitor'
'realtimevoicebuffering'
'recorder'
'rsm'

'sipstack'
'textcapture'
'observer'
'encryption'
'log'
#>

$datetime = get-date -f MMddmm
$temp = "D:\temp\"
$logpath = 'D:\Program Files\NICE Systems\Logs\'
$path = "$components" + "Files" + "-" + "$machinename" + "-" + "$datetime"
$zip = "$path" + ".zip"
$zipfile = "$temp" + "$zip"
$NewPath = "$temp" + "$path"
New-Item -Path $NewPath -ItemType Directory

foreach ($component in $componentArray) {
    $string = [regex] "$component"


    #$logs = Get-ChildItem -Path $logpath - -Filter *"$string"*.*
    $logs = gci -Path $logpath | ? -FilterScript { $_.name -match "$string" }

    foreach ($log in $logs) {

        Copy-Item -Filter *.* -Path $log.FullName -Recurse -Destination $NewPath 

    }
    #Copy-Item -Filter *"$string"*.* -ErrorAction SilentlyContinue -Path "$logpath\" + "$string*"" -Destination $NewPath
    #Copy-Item -Filter *.* -Path 'D:\Program Files\NICE Systems\Logs\RetrieverWCFService' -Recurse -Destination $NewPath
    #Copy-Item -Filter *.* -Path 'D:\Program Files\NICE Systems\Logs\RetrieverWCFService.SystemFramework\Log' -Recurse -Destination $NewPath
    #Copy-Item -Filter *.* -Path 'D:\Program Files\NICE Systems\Logs\RetrieverWCFService.WCFPublisher\Log' -Recurse -Destination $NewPath
    #Copy-Item -Filter *.DMP -Path "C:\Users\$user\AppData\Local\Temp\" -Recurse -Destination $NewPath

}

Zip-Files -zipfilename $zipfile -sourcedir $NewPath
$Storage = "\\lax-enarc02\S$\ComponentLogFiles\"
$Storagefile = "$Storage" + "$Zip"
Move-Item -Path $zipfile "$storageDest"

if (Test-Path -Path $Storagefile) {
    Remove-Item -Path $NewPath -Recurse -Force -ErrorAction SilentlyContinue
}





