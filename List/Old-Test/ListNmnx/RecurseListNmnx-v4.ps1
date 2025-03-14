# Recursively goes through Get-ChildItem returned object for files and directories of current working directory
# OR user specified directory listing directories matching $ListFolders entries and not recursing into them.
# It also does not recurse into folders present in $ExcludeFolders variable.
#
# Usage: script-name [optional-path] 
#
# Adapted from Getting files and folders recursively in PowerShell…without using -Recurse!,
# https://cloudrun.co.uk/powershell/getting-files-and-folders-recursively-in-powershell-without-using-recurse/

# Param ( $path = $pwd)
# When executed in some folders without optional-path parameter, above code results in this error:
# Method invocation failed because [System.Management.Automation.PathInfo] does not contain a method named 'trim'.
# Below code runs without error for same condition
Param ([string] $path = $pwd)
$ListFolders="node_modules",".next"
$ExcludeFolders = ".git","node_modules",".next"
$ListFolderOccurrences = 0

function Usage {
  param ($cmdName)
  Write-Host "Usage: $cmdName [optional-path]"
}

function get-folders {
    Param ($path)
    $items = Get-ChildItem -Force $path 
    foreach ($item in $items) {
      if (($item) -is [System.IO.DirectoryInfo]) { 
          if ($ListFolders -Contains ($item)) {
             Write-Output $path\$item
             $script:ListFolderOccurrences++
            #  $ListFolderOccurrences++ Does not increment across recursions
            #  Write-Host ListFolderOccurences: $ListFolderOccurrences
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

"$ListFolderOccurrences folders found matching folder list: $NmnxFolders. " +
  "Note that subfolders within matched folders are ignored." | Write-Output
