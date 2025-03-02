# Recursively outputs Get-ChildItem returned object for files and directories of current working directory
# OR user specified directory but excludes folders and their contents present in $ExcludeFolders variable
# in script
#
# Usage: script-name [optional-path] | next-cmd
# Usage Examples:
# Lists last modified time followed by full path for each folder & file in current directory
# excluding folders whose names are in $ExcludeFolders and such folders' contents
# script-name | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# Lists last modified time followed by full path for each folder & file in Test1 directory
# excluding folders whose names are in $ExcludeFolders and such folders' contents
# script-name Test1 | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# Lists last modified time followed by full path for each folder & file in current directory
# that was last modifed on 4.05.2024 (4th May) or 5.05.2024
# excluding folders whose names are in $ExcludeFolders and such folders' contents
# script-name | where { ((get-date('5.05.2024'))-$_.LastWriteTime).days -lt 1 } | 
# ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# Lists last modified time followed by full path for each folder & file in current directory
# that was last modifed in past 1 day i.e. 24 hours
# excluding folders whose names are in $ExcludeFolders and such folders' contents
# script-name | where { ((get-date)-$_.LastWriteTime).days -lt 1 } |
# ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
#
# Adapted from Getting files and folders recursively in PowerShell…without using -Recurse!,
# https://cloudrun.co.uk/powershell/getting-files-and-folders-recursively-in-powershell-without-using-recurse/

Param ($path = $pwd)
$ExcludeFolders = ".git","node_modules",".next"

function get-folders {
    Param ($path)
    $items = Get-ChildItem -Force $path 
    foreach ($item in $items) {
        if (($item) -is [System.IO.DirectoryInfo]) { 
           if ($ExcludeFolders -Contains ($item)) {
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