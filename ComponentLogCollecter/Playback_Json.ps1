$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptDir += "\playback.json"
#Getting information from the json file
#The we pass the output from Get-Content to ConvertFrom-Json Cmdlet
$JsonObject = Get-Content $ScriptDir | ConvertFrom-Json
 
#Right now we have an array which means that we have to index
#an element to use it
#$UserNum = Get-Random -Minimum 1 -Maximum 3
#$JsonObject.US1[0]
#$Service = 3 
#When indexed we can call the attributes of the elements
#Write-Host "Attributes individually printed"
#$JsonObject.US1[0].Servers[0].Services[0].Service
$JsonObject.US1[0].Servers[0].Services[0].Service[2].name
#$JsonObject.Users[$UserNum].Name
#$JsonObject.Users[$UserNum].Age
#$JsonObject.Users[$UserNum].City
#$JsonObject.Users[$UserNum].Country
#$JsonObject.Users[$UserNum].UserId