# List files and folders excluding specified/default folders.
#
# Usage examples:
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
    Write-Host "List files and folders excluding specified/default folders."`n
    Write-Host Usage: $CmdName [Path Exclude-Folders-List]`n
    Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
    Write-Host Exclude-Folders-List is passed as given to ListItemWoXF.ps1
    Write-Host If Exclude-Folders-List is omitted`, default value of `"`" is passed to ListItemWoXF.ps1
    Write-Host /? passed as first parameter shows this help message.
}

if ($Path -eq "/?") { 
    Usage $myInvocation.InvocationName
    exit 0
}

$Cmd = "ListItemWoXF.ps1 $Path $ExcludeFolders | ForEach-Object {`"`$(`$_.LastWriteTime) `$(`$_.FullName)`"}"
Write-Host "Executing command: $Cmd"
ListItemWoXF.ps1 $Path $ExcludeFolders | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
