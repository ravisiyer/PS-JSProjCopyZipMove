$InputFolder = "c:\XY"
$BackupTopLevelFolder = "E:\FewDaysBkup"

FindByNameContains $BackupTopLevelFolder 'RegXYData'

cd $InputFolder
PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder $InputFolder -ProjectDirsAndTypes @{ 'RegXYData'='ExcludeNone'}

pause
