# Recursively lists full path of files and directories of current working directory OR user specified directory
# using write-output.
#
# Usage: script-name [optional-path]
#
# Adapted from Getting files and folders recursively in PowerShell…without using -Recurse!,
# https://cloudrun.co.uk/powershell/getting-files-and-folders-recursively-in-powershell-without-using-recurse/

Param ($path = $pwd)

function get-folders {
    Param ($path)
    $items = Get-ChildItem -Force $path 
    foreach ($item in $items) {
        # List all the folders
        if (($item) -is [System.IO.DirectoryInfo]) { 
           write-output $path\$item 
           $itemname = $item.Name
           $fullpath = "$path\$itemname"
           get-folders $fullpath #Recursively list if it is a directory
        }
        # Print out any files
        if (($item) -is [System.IO.FileInfo]) { 
            write-output $path\$item 
         }
    }
}

get-folders $path