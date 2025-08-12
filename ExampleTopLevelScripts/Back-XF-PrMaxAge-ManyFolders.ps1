$InputTopLevelFolder = "C:\Users\some-user"
$BackupTopLevelFolder = "E:\FewDaysBkup"
$InputFolderLeaf = "CurrProj"

$InputFolder = Join-Path -Path $InputTopLevelFolder -ChildPath $InputFolderLeaf

# The `Out-String -Stream` command is needed as otherwise the FindByNameContains command output is not shown (or perhaps shown later)
# I don't follow why that happens but don't have time to study and understand.
FindByNameContains $BackupTopLevelFolder $InputFolderLeaf | Out-String -Stream | Select-Object -First 10

Write-Host "`nAbove list is the top 10 files or folders in last modified descending order (latest first)`n"

# FindTopNByNameContains $BackupTopLevelFolder $InputFolderLeaf

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

MoveByNameContains $DestinationFolder  @('Others-XF', 'ReactNative-XF', 'DotNet-XF', 'Android-XF', 'Common-XF') `
    $InputFolderLeaf

pause
