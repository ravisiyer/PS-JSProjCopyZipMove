# List last modified files and folders (few like 10 based on script setting) excluding special folders by default.
# It uses ExcludeDirsRecurseListFilesDirs.ps1 to do the main work
#
# Usage examples:
# Default folders are excluded
# script-name  
#
# Default folders are excluded
# script-name test 
#
# build and .git folders are excluded
# script-name test "build .git"
#
# node_modules folder is excluded
# script-name test "node_modules"
#
# no folders are excluded (all are included)
# script-name test ExcludeNone
#
param ($Path = $pwd, $ExcludeFolders="")

function Usage {
  param ($CmdName)
  Write-Host "List last modified files and folders (few like 10 based on script setting) excluding special folders by default."`n
  Write-Host Usage: $CmdName [Path Exclude-Folders-List]`n
  Write-Host This script relies on ExcludeDirsRecurseListFilesDirs.ps1 to do the work.
  Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
  Write-Host Exclude-Folders-List is passed as given to ExcludeDirsRecurseListFilesDirs.ps1
  Write-Host If Exclude-Folders-List is omitted`, default value of `"`" is passed to ExcludeDirsRecurseListFilesDirs.ps1
  Write-Host /? passed as first parameter shows this help message.
}

if ($Path -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

$Cmd = "ExcludeDirsRecurseListFilesDirs.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | " +
  "Select-Object -first 10 | ForEach-Object {Write-Host `$_.LastWriteTime `$_.FullName}"

Write-Host "Executing command: $Cmd"
# Invoke-Expression $Cmd ... Does not work as $_ creates an issue; Note that ForEach-Object $ needs to be escaped in Write-Host string
ExcludeDirsRecurseListFilesDirs.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | `
  Select-Object -first 10 | ForEach-Object {Write-Host $_.LastWriteTime $_.FullName}
