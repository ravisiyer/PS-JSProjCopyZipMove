# Recursively goes through Get-ChildItem returned object for files and directories of current working directory
# OR user specified directory listing directories matching $ListFolders entries and not recursing into them.
# It also does not recurse into folders present in $ExcludeFolders variable.
#
# Usage: script-name [optional-path] 
#
# Adapted from Getting files and folders recursively in PowerShell…without using -Recurse!,
# https://cloudrun.co.uk/powershell/getting-files-and-folders-recursively-in-powershell-without-using-recurse/

Param ($path = $pwd)
$ListFolders="node_modules",".next"
$ExcludeFolders = ".git","node_modules",".next"

function Usage {
  param ($cmdName)
  Write-Host Usage: $cmdName [optional-path]
}

function get-folders {
    Param ($path)
    $items = Get-ChildItem -Force $path 
    foreach ($item in $items) {
      # write-host $path\$item
      if (($item) -is [System.IO.DirectoryInfo]) { 
          if ($ListFolders -Contains ($item)) {
            # if ($ExcludeFolders -Contains ($item)) {
             write-host $path\$item
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
  # Write-Host "Input parameter (folder name) had trailing backslash which was stripped" 
}

If ( -not (Test-Path -path $path -PathType Container)) {
  If (Test-Path -path $path) {
    Write-Host "Parameter specified: '$path' is not a directory. Aborting!"
  } Else {
    Write-Host "Parameter specified: '$path' does not exist. Aborting!"
  }
  Usage $myInvocation.InvocationName
  exit 1
}

get-folders $path