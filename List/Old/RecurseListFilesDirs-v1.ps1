# Recursively lists full path of files (in yellow) and directories (in green) of current working directory OR
# user specified directory using write-host.
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
           write-host $path\$item -foregroundcolor Green
           $itemname = $item.Name
           $fullpath = "$path\$itemname"
           $array += $fullpath
           get-folders $fullpath #Recursively list if it is a directory
        }
        # Print out any files
        if (($item) -is [System.IO.FileInfo]) { 
            write-host $path\$item -foregroundcolor Yellow
            $itemname = $item.Name
            $fullpath = "$path\$itemname"
            $array += $fullpath
         }
    }
# Return the array with all subfolders in in case you want to do something else with it
return $array
}

$subfolders = get-folders $path
