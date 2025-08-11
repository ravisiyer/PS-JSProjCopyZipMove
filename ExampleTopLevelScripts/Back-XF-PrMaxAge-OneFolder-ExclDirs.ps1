$InputFolder = "c:\XY"
$BackupTopLevelFolder = "E:\FewDaysBkup"

FindByNameContains $BackupTopLevelFolder 'Backup-Info'

cd $InputFolder

PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder $InputFolder -ProjectDirsAndTypes @{ 'Backup-Info'='ExcludeDirs: Logs'}

pause

