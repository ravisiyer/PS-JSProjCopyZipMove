param ($DestinationFolder="E:\TempBack")
$TodaysDate = Get-Date -Format "yyyyMMdd"
$NewFolderPath = $DestinationFolder + "\" + $TodaysDate
If (Test-Path -path $NewFolderPath) {
    Write-Host "Folder/file: '$TodaysDate' already exists in Destination Folder: $DestinationFolder . Aborting!"
    exit 1
} 
New-Item -Path $DestinationFolder -Name $TodaysDate -ItemType "directory"
