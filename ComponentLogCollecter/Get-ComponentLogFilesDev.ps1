$components = 'playback'
$time = 1

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

#function Unzip-Files {
#    param([string]$zipfile, [string]$outpath)
#    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
#}

#Example
#    Unzip-Files "C:\a.zip" "C:\a"

$user = [Environment]::UserName
$machinename = [Environment]::MachineName

if ($components = "playback") {

    $componentArray = @(
        "retriever"
        'playback'
        'stream'
        'storageprepare'
        'screen'
        'callserver'
        'NiceApplications'
    )
}

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
'screencapture'
'sipstack'
'textcapture'
'observer'
'encryption'
'log'
#>

$datetime = Get-Date -Format “ddMMyyyyhhmmss”
$temp = "D:\temp\"
$path = "$components" + "-" + "$machinename" + "-" + "$datetime"
$zip = "$path" + ".zip"
$zipfile = "$temp" + "$zip"
$NewPath = "$temp" + "$path"
New-Item -Path $NewPath -ItemType Directory

#Non Zipped Files

$logpath = 'D:\Program Files\NICE Systems\Logs\*\log'

foreach ($component in $componentArray) {
    $string = [regex] "$component"
    $timeline = (Get-Date).AddDays(-$time)

    #$logs = Get-ChildItem -Path $logpath* -Recurse | Where-Object -FilterScript { $_.Name -match "$string" -and $_.LastWriteTime -lt $timeline }
    $logs = Get-ChildItem -Path $logpath* -Exclude "*WCF*.*", "*Framework*.*", "*.zip" -Recurse | Where-Object { $_.LastWriteTime -lt $timeline } | Where-Object -FilterScript { $_.Name -match "$string" }

    foreach ($log in $logs) {
        Write-host $log.FullName


        Copy-Item -Filter *$string*.* -Path $log.FullName -Recurse -Destination $NewPath | Where-Object { $_.LastWriteTime -lt $timeline } | Where-Object -FilterScript { $_.Name -match "$string" }

    }
}
#Zip File Handling
$logpath = 'D:\Program Files\NICE Systems\Logs\*\archive'
foreach ($component in $componentArray) {
    $string = [regex] "$component"
    $timeline = (Get-Date).AddDays(-$time)
    $zipcount = 0

    #$logs = Get-ChildItem -Path $logpath* -Recurse | Where-Object -FilterScript { $_.Name -match "$string" -and $_.LastWriteTime -lt $timeline }
    $logs = Get-ChildItem -Path $logpath* -Exclude "*WCF*.*", "*Framework*.*" -Include "*.zip" -Recurse | Where-Object { $_.LastWriteTime -lt $timeline } | Where-Object -FilterScript { $_.Name -match "$string" }


    foreach ($log in $logs) {
        Write-host $log.FullName
        $temppath = $temp + "unzipping_folder"
        if (Test-Path $temppath) {
            Copy-Item -Filter *$string*.* -Path $log.FullName -Recurse -Destination $tempPath | Where-Object { $_.LastWriteTime -lt $timeline } | Where-Object -FilterScript { $_.Name -match "$string" }
        }
        else {
            New-Item -Path $temppath -ItemType Directory
            Copy-Item -Filter *$string*.* -Path $log.FullName -Recurse -Destination $tempPath | Where-Object { $_.LastWriteTime -lt $timeline } | Where-Object -FilterScript { $_.Name -match "$string" }
        }



        $zipcount = 0
        $extractDir = $temppath
        $folders = Get-ChildItem -Directory $temppath | Measure-Object | % { $_.Count }

        $zip = [System.IO.Compression.ZipFile]::OpenRead($log)
        Do {
            foreach ($item in $zip.Entries) {

                try {

                    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($item, (Join-Path -Path $extractDir -ChildPath $item.FullName), $false)

                }
                catch {

                    $count = 0
                    $extension = $item.FullName.Substring($item.FullName.LastIndexOf('.'))
                    $fileName = $item.FullName.Substring(0, $item.FullName.LastIndexOf('.'))
                    $found = $false

                    do {

                        if (!(Test-Path (Join-Path -Path $extractDir -ChildPath "$fileName ($count)$extension"))) {

                            $found = $true

                        }
                        else {

                            $count++

                        }

                    } until ($found -eq $true)

                    $newFileName = "$fileName ($count)$extension"

                    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($item, (Join-Path -Path $extractDir -ChildPath $newFileName), $false)

                }

            }

            Move-Item -Filter *$string*.* -Path $temppath.FullName -Recurse -Destination $NewPath | Where-Object { $_.LastWriteTime -lt $timeline } | Where-Object -FilterScript { $_.Name -match "$string" }
            $zipcount++
            #rm "$log\*.zip"
        } While ($Zipcount -lt $folders)
    }
}

<#
Zip-Files -zipfilename $zipfile -sourcedir $NewPath
$Storage = "\\lax-enarc02\S$\ComponentLogFiles\$components"
$Storagefile = "$Storage" + "\" + "$Zip"
$StorageTest = Test-Path -Path $Storage

if ($StorageTest) {

Move-Item -Path $zipfile "$Storage"
}
else {
New-Item -Path $Storage -ItemType Directory
$Storage = "\\lax-enarc02\S$\ComponentLogFiles\$components"
$StorageTest = Test-Path -Path $Storage
if ($StorageTest){
Move-Item -Path $zipfile "$Storage"
if (Test-Path -Path $Storagefile) {
   Remove-Item -Path $NewPath -Recurse -Force -ErrorAction SilentlyContinue
}
}
}
$Storagefile = "$Storage" + "\" + "$Zip"
if (Test-Path -Path $Storagefile) {
   Remove-Item -Path $NewPath -Recurse -Force -ErrorAction SilentlyContinue
}
#>