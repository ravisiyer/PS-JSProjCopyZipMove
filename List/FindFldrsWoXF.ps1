# Finds and lists folders/directories with names matching $FindFolders array elements
# in a user specified folder/directory or current directory. It also provides a total count of the folders it finds and lists.
# It ignores subfolders within the matching $FindFolders array elements (node_modules and .next) it finds.
# It also ignores folders present in $ExcludeFolders array 
# Usage Examples:
#
# In working directory, find and list default FindFolders and exclude default ExcludeFolders
# script-name 
#
# In Test directory, find and list default FindFolders and exclude default ExcludeFolders
# script-name Test
#
# In Test directory, find and list node_modules and .next folders and exclude default ExcludeFolders
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
$ExcludeNoneFlag="ExcludeNone"
function Usage {
  param ($cmdName)
  Write-Host "Find and list folders with names matching passed FindFolders excluding specified/default folders."
  Write-Host "The default values for this command helps to locate folders that can be deleted from inactive projects as these"
  Write-Host "folder contents can be regenerated from main project source files (like node_modules can be regenerated from package.json)."
  Write-Host "FindFolders by default is .gitignore type of folders like node_modules and .next which in most list scripts" 
  Write-Host "are exclude folders by default."
  Write-Host "Further note that for this script, the ExcludeFolders by default is a folder like .git" `n
  # Uppercase first letter Path specified as parameter to this command is set to $path by Powershell
  # As code uses a mix of first letter uppercase and first letter lowercase variable names, I did not want to change $path variable alone
  # to $Path
  Write-Host "Usage: $cmdName [Path, FindFolders, ExcludeFolders]" `n
  Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
  Write-Host FindFolders is a space separated list like: `"node_modules .next intermediates .gradle`"
  Write-Host ExcludeFolders is a space separated list like: `".git xyz`"
  Write-Host Special value of $ExcludeNoneFlag can be passed as ExcludeFolders to not use exclude option at all [include all in find]
  Write-Host "To skip optional parameters but specify a following parameter, use - (hyphen character) to skip"
  Write-Host "/? passed as first parameter shows this help message."`n
}

if ($path -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
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

# Special flag to not specify Exclude Directories option at all  
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
    Write-Error "Path parameter specified: '$path' is not a directory. Aborting!"
  } Else {
    Write-Error "Path parameter specified: '$path' does not exist. Aborting!"
  }
  Usage $myInvocation.InvocationName
  exit 1
}

get-folders $path

Write-Host `n"$FindFoldersOccurrences folders found matching find folders list." `
  "Note that subfolders within matched folders are ignored."
Write-Host  `n
