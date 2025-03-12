# List last modified files and folders (few like 10 based on script setting) excluding special folders by default.
# It uses ListItemWoXF.ps1 to do the main work
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
param ($Path = $pwd, $TopFewCount=10, $ExcludeFolders="")

function Usage {
  param ($CmdName)
  Write-Host "List few last modified files and folders excluding specified/default folders."`n
  Write-Host Usage: $CmdName [Path TopFewCount Exclude-Folders-List]`n
  Write-Host This script relies on ListItemWoXF.ps1 to do the work.
  Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
  Write-Host TopFewCount is the number of top few items shown. Default value is 10
  Write-Host Exclude-Folders-List is passed as given to ListItemWoXF.ps1
  Write-Host If Exclude-Folders-List is omitted`, default value of `"`" is passed to ListItemWoXF.ps1
  Write-Host /? passed as first parameter shows this help message.
}

if ($Path -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

$Cmd = "ListItemWoXF.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | " +
  "Select-Object -first $TopFewCount | ForEach-Object {Write-Host `$_.LastWriteTime `$_.FullName}"
Write-Host "Executing command: $Cmd"

ListItemWoXF.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | `
  Select-Object -first $TopFewCount | ForEach-Object {Write-Host $_.LastWriteTime $_.FullName}
