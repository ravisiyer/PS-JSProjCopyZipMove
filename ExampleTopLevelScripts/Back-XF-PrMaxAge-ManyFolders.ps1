$InputTopLevelFolder = "C:\Users\some-user"
$BackupTopLevelFolder = "E:\FewDaysBkup"
$InputFolderLeaf = "CurrProj"

$InputFolder = Join-Path -Path $InputTopLevelFolder -ChildPath $InputFolderLeaf

FindByNameContains $BackupTopLevelFolder $InputFolderLeaf

Set-Location $InputFolder

# ` (backtick) is used to continue the command on the next line
# As per Gemini when the hashtable parameter is split across multiple lines, backtick is not needed
# But I have used it and it works fine
PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder $InputFolder `
-ProjectDirsAndTypes @{ `
    'Others'='Others'; `
    'ReactNative'='ReactNative'; `
    'DotNet'='DotNet'; `
    'Android'='Android'; `
    'Common'='Others' `
}

$TodaysDate = Get-Date -Format "yyyyMMdd"
$DestinationFolder = Join-Path -Path $BackupTopLevelFolder -ChildPath $TodaysDate

Write-Output "After PrMaxAgeMFCpXF7ZipMv execution. Checking if destination folder $DestinationFolder exists."

If ( -not (Test-Path -path $DestinationFolder)) {
	Write-Error "Incremental backup folder for today: $DestinationFolder not found"
	exit
}

MoveFFByNameContains $DestinationFolder  @('Others-XF', 'ReactNative-XF', 'DotNet-XF', 'Android-XF', 'Common-XF') `
    $InputFolderLeaf

pause
