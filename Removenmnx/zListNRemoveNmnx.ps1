# This script seems to be working in some limited tests I did. But it needs more testing before regular use.
# I don't have the time now for more testing.
#
# Lists AND attempts to delete folders/directories (with confirmation prompt) with names matching 
# $ListFolders array elements (currently: node_modules and .next),
# in a user specified folder/directory or current directory. It also provides a total count of the
# folders it lists and (attempts to) delete. 
# It ignores subfolders within the matching $ListFolders array elements (node_modules and .next) it finds.
# It also ignores folders present in $ExcludeFolders array (currently: .git).
# Usage: script-name [optional-path] 
#
# The script uses Get-ChildItem calling it recursively.
#
# Adapted from Getting files and folders recursively in PowerShell…without using -Recurse!,
# https://cloudrun.co.uk/powershell/getting-files-and-folders-recursively-in-powershell-without-using-recurse/

Param ([string] $path = $pwd)
$ListFolders="node_modules",".next"
$ExcludeFolders = ,".git"
$ListFolderOccurrences = 0

function Usage {
  param ($cmdName)
  Write-Host "Usage: $cmdName [optional-path]"
}

function delete-folder {
    Param ($folderPath)
# Simple function to delete passed folder after user confirmation. Note that the folder is deleted # 'permanently' (not sent to Recycle bin) as that seems to be the behaviour of Remove-Item cmdlet.
	If ( Test-Path $folderPath ) { Remove-Item $folderPath }
}

function get-folders {
    Param ($path)
    $items = Get-ChildItem -Force $path 
    foreach ($item in $items) {
      if (($item) -is [System.IO.DirectoryInfo]) { 
          if ($ListFolders -Contains ($item)) {
             Write-Output $path\$item
			 delete-folder $path\$item
             $script:ListFolderOccurrences++
           } else {
            if ($ExcludeFolders -Contains ($item)) {
              # skip this folder
            } else {
              $itemname = $item.Name
              $fullpath = "$path\$itemname"
              get-folders $fullpath #Recurse into directory
            }
           }
        }
    }
}
$path = $path.trim()
$len = $path.length
if ("\" -eq $path.substring($len-1,1)) {
  $path = $path.substring(0, $len-1)
  # Write-Output "Input parameter (folder name) had trailing backslash which was stripped" 
}

If ( -not (Test-Path -path $path -PathType Container)) {
  If (Test-Path -path $path) {
    Write-Error "Parameter specified: '$path' is not a directory. Aborting!"
  } Else {
    Write-Error "Parameter specified: '$path' does not exist. Aborting!"
  }
  Usage $myInvocation.InvocationName
  exit 1
}

get-folders $path
$NmnxFolders = $ListFolders -join ","

"$ListFolderOccurrences folders found matching folder list: $NmnxFolders. " | Write-Output
If ($ListFolderOccurrences -gt 0) {
	"These folders were attempted to be deleted (with confirmation prompt). " | Write-Output
}
