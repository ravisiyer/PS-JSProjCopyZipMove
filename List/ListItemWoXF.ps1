﻿# Recursively outputs Get-ChildItem returned object for files and directories of current working directory
# OR user specified directory excluding specified/default folders (e.g. node_modules and .next folders).
#
# Usage: script-name [optional-path ExcludeFolders] | next-cmd
# Usage Examples:
# Lists last modified time followed by full path for each folder & file in current directory
# excluding default folders
# script-name | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# Lists last modified time followed by full path for each folder & file in Test1 directory
# excluding default folders
# script-name Test1 | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# Lists last modified time followed by full path for each folder & file in current directory
# that was last modifed on 4.05.2024 (4th May) or 5.05.2024
# excluding default folders
# script-name | where { ((get-date('5.05.2024'))-$_.LastWriteTime).days -lt 1 } | 
# ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# Lists last modified time followed by full path for each folder & file in current directory
# that was last modifed in past 1 day i.e. 24 hours
# excluding default folders
# script-name | where { ((get-date)-$_.LastWriteTime).days -lt 1 } |
# ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# build and .git directories are excluded
# script-name Test "build .git" | Where-Object { ((get-date)-$_.LastWriteTime).days -lt 3700 } | 
# ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# node_modules directory is excluded
# script-name Test "node_modules" | Where-Object { ((get-date)-$_.LastWriteTime).days -lt 3700 } | 
# ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# ExcludeNone results in no files and folders being excluded (all are included).
# script-name Test ExcludeNone | Where-Object { ((get-date)-$_.LastWriteTime).days -lt 3700 } |
# ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# Adapted from Getting files and folders recursively in PowerShell…without using -Recurse!,
# https://cloudrun.co.uk/powershell/getting-files-and-folders-recursively-in-powershell-without-using-recurse/

Param ($path = $pwd, $ExcludeFolders="")
$ExcludeNoneFlag="ExcludeNone"
function Usage {
  param ($CmdName)
  Write-Host "Output (list) files and folders excluding specified/default folders."`n
  Write-Host Usage: $CmdName [Path ExcludeFolders]`n
  Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
  Write-Host ExcludeFolders is a space separated list like: `"node_modules .next intermediates .gradle`"
  Write-Host Special value of $ExcludeNoneFlag can be passed as ExcludeFolders to not use exclude option at all [include all in copy]
  Write-Host /? passed as first parameter shows this help message.
}

if ($Path -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

$ExcludeFoldersDefault = ".git node_modules .next .gradle .idea .cache .expo"

# Special flag to not specify Exclude Directories option at all  
if ( $ExcludeNoneFlag -eq $ExcludeFolders )  {
  $ExcludeFolders = "" 
} elseif (( "" -eq $ExcludeFolders  ) -or ("-" -eq $ExcludeFolders)) {
  $ExcludeFolders = $ExcludeFoldersDefault
}
$ExcludeFoldersArray = $($ExcludeFolders -split " ")

write-host "ListItemWoXF: Excluded folders:" $ExcludeFoldersArray `n
function get-folders {
    Param ($path)
    $items = Get-ChildItem -Force $path 
    foreach ($item in $items) {
        if (($item) -is [System.IO.DirectoryInfo]) { 
           if ($ExcludeFoldersArray -Contains ($item)) {
             # Use write-host below insead write-output to write only to console and not to piped output
             # This will prevent below line from tripping up next command in pipeline that expects an 
             # object returned by Get-ChildItem for a specific file or folder
             # write-host "***write-host*** Skipping excluded folder and its contents: $path\$item"
           } else {
           write-output $item 
           $itemname = $item.Name
           $fullpath = "$path\$itemname"
           get-folders $fullpath #Recursively list if it is a directory
           }
        }
        if (($item) -is [System.IO.FileInfo]) { 
            write-output $item 
         }
    }
}

get-folders $path
