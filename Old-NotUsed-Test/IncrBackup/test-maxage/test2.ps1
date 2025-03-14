# You could do it like this, but where's the fun in that? This also returns everything in a single array.
# $folders = Get-ChildItem C:\temp -Recurse
$path = "C:\Users\Ravi-user\Desktop\Temp"
# $ErrorActionPreference = "SilentlyContinue"

function get-folders {
    Param ($path)
    $items = Get-ChildItem -Force $path 
    foreach ($item in $items) {
        # List all the folders
        
        # if ($item.Mode -eq "d-----") {  # Does not handle hidden directories
          # write-host $item.gettype();  # System.IO.DirectoryInfo
        #if ($item.gettype() -eq "System.IO.DirectoryInfo") { 
          # (get-date) -is [DateTime]
        if (($item) -is [System.IO.DirectoryInfo]) { 
           write-host $path\$item -foregroundcolor Red
           $itemname = $item.Name
           $fullpath = "$path\$itemname"
           $array += $fullpath
           get-folders $fullpath #Recursively list if it is a directory
        }
        # Print out any files
        # if ($item.Mode -eq "-a----") {
           # write-host $item.gettype();  # System.IO.FileInfo
        #if ($item.gettype() -eq "System.IO.FileInfo") { 
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