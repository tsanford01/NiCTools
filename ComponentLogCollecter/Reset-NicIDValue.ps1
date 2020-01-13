#Set the Variables
$computer = "localhost"
$Service = "ScreenAgentService"
$datetime = get-date -f MMdd

#Finds the users that are logged into the computer
function Get-LoggedOnUser {
    param([string]$Computer)
    Get-WmiObject Win32_LoggedOnUser | Select Antecedent -Unique | % {"{0}" -f $_.Antecedent.ToString().Split('"')[3]} | Where-Object {$_ -notlike "*$" -and $_ -ne "NETWORK SERVICE" -and $_ -ne "LOCAL SERVICE" -and $_ -ne "SYSTEM" -and $_ -notlike "DWM*" -and $_ -ne "ANONYMOUS LOGON" -and $_ -ne "iusr" -and $_ -ne "DefaultAppPool" -and $_ -notlike "*-*-*-*" -and $_ -notlike "UMFD*"}
}

#changes the config file for the logged in user and restarts the Screen Agent Service
$OSLogins = Get-LoggedOnUser
foreach ($OSLogin in $OSLogins) {
    
    #These values are for testing, notepad is set up to test if a process is running without needing to have the vpn running. Change the # to the cpnui when ready.
    #$VPN = "vpnui"
    $VPN = "Notepad"
    
    $PathSASettings = "C:\ProgramData\NICE Systems\ScreenAgent\$OSLogin\Configuration\SASettings.xml"
    $Process = Get-Process | Where-object {$_.Name -like "$VPN"}
    If (Test-path -Path $PathSASettings) {
        
        #Sets up logging if desired remove the "#" on the Stop-Transcript below if you decide to use this
        #$transcript = "C:\ProgramData\NICE Systems\ScreenAgent\$OSLogin\logs\NicChangeLog" + "$datetime" + ".txt" #Set the location where you would like to log
        #Start-Transcript -Path "$transcript" -Append 
        
        if ($Process) {

            #writes this line to the log if the vpn is active
            "VPN active, setting the value and restarting the service"
            
            (Get-Content -Path $PathSASettings) | ForEach-Object { 
                $currentLine = $_
                IF ($currentLine -like "*<NicId value=`"0`" />*") {
                    $currentLine = $currentLine.Replace("0", "1")
                }
                ElseIf ($currentLine -like "*<UseTopNIC value=`"False`" />*") {
                $currentLine = $currentLine.Replace("False", "True")
                }
                $currentLine
            } | Set-Content -Path $PathSASettings 
            Restart-Service -Name $Service       
        }
        else {
            $ResNeeded = 0
            #writes this line to the code if the vpn is not active
            "VPN not active, setting value to 0 and restarting the service, or user Not Found or no action needed"
            
            (Get-Content -Path $PathSASettings) | ForEach-Object { 
                $currentLine = $_
                IF ($currentLine -like "*<NicId value=`"1`" />*") {
                    $currentLine = $currentLine.Replace("1", "0")
                    $ResNeeded = 1
                }
                ElseIf ($currentLine -like "*<UseTopNIC value=`"True`" />*") {
                $currentLine = $currentLine.Replace("True", "False")
                }
                $currentLine
            } | Set-Content -Path $PathSASettings
            if ($ResNeeded -eq 1) {
                Restart-Service -Name $Service 
            }
                  
        }        
    }
    Else {
        "User Not Found or no action needed"
    }   
}

#Stop-Transcript