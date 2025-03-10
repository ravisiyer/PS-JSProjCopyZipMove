# Finds and lists folders/directories with names matching $FindFolders array elements
# in a user specified folder/directory or current directory. It also provides a total count of the folders it finds and lists.
# It ignores subfolders within the matching $FindFolders array elements (node_modules and .next) it finds.
# It also ignores folders present in $ExcludeFolders array 
# Usage Examples:
#
# In working directory, find and list default find-folders-list and exclude default exclude-folders-list
# script-name 
#
# In Test directory, find and list default find-folders-list and exclude default exclude-folders-list
# script-name Test
#
# In Test directory, find and list node_modules and .next folders and exclude default exclude-folders-list
# script-name Test "node_modules .next"
#
# In Test directory, find and list node_modules folders and exclude .git folders
# script-name Test "node_modules" ".git"
#
# In Test directory, find and list .git folders and exclude target folders
# script-name Test ".git" "target"
#
# The script uses Get-ChildItem calling it recursively.
#
# Adapted from Getting files and folders recursively in PowerShell…without using -Recurse!,
# https://cloudrun.co.uk/powershell/getting-files-and-folders-recursively-in-powershell-without-using-recurse/

Param ([string] $path = "", $FindFolders = "", $ExcludeFolders = "")
function Usage {
  param ($cmdName)
  Write-Host "Usage: $cmdName [optional-path, Find-Folders-List, Exclude-Folders-List]"
  Write-Host - for parameter results in default value being used for that parameter
  Write-Host ExcludeNone results in no files and folders being excluded (all are included).
}

$pathDefault = $pwd
if (( "" -eq $path  ) -or ("-" -eq $path)) {
    $path = $pathDefault
}

$FindFoldersDefault = "node_modules .next .gradle intermediates .expo target"
$ExcludeFoldersDefault = ".git"

if (( "" -eq $FindFolders  ) -or ("-" -eq $FindFolders)) {
    $FindFolders = $FindFoldersDefault
}
$FindFoldersArray = $($FindFolders -split " ")
  
write-host "Find folders:" $FindFoldersArray 

$ExcludeNoneFlag="ExcludeNone"

# Special flag to not specify Exclude Directtories option at all  
if ( $ExcludeNoneFlag -eq $ExcludeFolders )  {
  $ExcludeFolders = "" 
} elseif (( "" -eq $ExcludeFolders  ) -or ("-" -eq $ExcludeFolders)) {
  $ExcludeFolders = $ExcludeFoldersDefault
}
$ExcludeFoldersArray = $($ExcludeFolders -split " ")

write-host "Excluded folders:" $ExcludeFoldersArray 

$FindFoldersOccurrences = 0

function get-folders {
    Param ($path)
    $items = Get-ChildItem -Force $path 
    foreach ($item in $items) {
      if (($item) -is [System.IO.DirectoryInfo]) { 
          if ($FindFoldersArray -Contains ($item)) {
             Write-Output $path\$item
             $script:FindFoldersOccurrences++
           } else {
            if ($ExcludeFoldersArray -Contains ($item)) {
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

"$FindFoldersOccurrences folders found matching find folders list. " +
  "Note that subfolders within matched folders are ignored." | Write-Output
