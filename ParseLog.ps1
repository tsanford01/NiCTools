$script = {
    $path = "C:\Users\travis.sanford\Desktop\Investigation Folder\M7C6 Log.txt"
    $String = [regex] "\d{11}(?<=ContactId\s=\s\d{11})"
    $file = Get-ChildItem $Path
    Get-Content $file[0].Fullname -ErrorAction SilentlyContinue | Select-String "$String" | measure

}
$ContactArray = @()
$path = "C:\Users\travis.sanford\Desktop\Investigation Folder\M7C6 Log.txt"
$ContactID = [regex] "\d{11}(?<=ContactId\s=\s\d{11})"
$InteractionID = [regex] "\d{19}(?<=InteractionID\s=\s\d{19})"
$ContactSearch = [regex] $ContactID + ".*" + $InteractionID
$file = Get-ChildItem $Path
Get-Content $file[0].Fullname -ErrorAction SilentlyContinue | Select-String "$ContactID", "$InteractionID" | 