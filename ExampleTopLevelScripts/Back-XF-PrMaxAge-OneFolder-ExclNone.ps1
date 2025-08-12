$InputFolder = "c:\XY"
$BackupTopLevelFolder = "E:\FewDaysBkup"

# The `Out-String -Stream` command is needed as otherwise the FindByNameContains command output is not shown (or perhaps shown later)
# I don't follow why that happens but don't have time to study and understand.
FindByNameContains $BackupTopLevelFolder 'RegXYData' | Out-String -Stream | Select-Object -First 10

Write-Host "`nAbove list is the top 10 files or folders in last modified descending order (latest first)`n"
# FindTopNByNameContains $BackupTopLevelFolder 'RegXYData'

cd $InputFolder
PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder $InputFolder -ProjectDirsAndTypes @{ 'RegXYData'='ExcludeNone'}

pause

