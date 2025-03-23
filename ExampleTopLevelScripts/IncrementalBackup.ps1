# Replace FolderName and LogFile variables as needed
$InputFolderName = "C:\Users\{username}\CurrProjects"
$OutputFolderName = "E:\Back-XF-CurrProjects"
$LogFile = "Logs\CurrProjects-log.txt"

$Cmd = "Copywoxf $InputFolderName - - $OutputFolderName $LogFile"
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd  
pause