# List last modified files and folders (few like 10 based on script setting) excluding special folders by default.
# It uses ListItemWoXF.ps1 to do the main work
#
# Usage examples:
# Default folders are excluded
# script-name  
#
# Default folders are excluded
# script-name test 
#
# build and .git folders are excluded
# script-name test "build .git"
#
# node_modules folder is excluded
# script-name test "node_modules"
#
# no folders are excluded (all are included)
# script-name test ExcludeNone
#
param ($Path = $pwd, $TopFewCount=10, $ExcludeFolders="", $UTC="")

function Usage {
  param ($CmdName)
  Write-Host "List few last modified files and folders excluding specified/default folders."`n
  Write-Host Usage: $CmdName [Path TopFewCount ExcludeFolders UTC]`n
  Write-Host This script relies on ListItemWoXF.ps1 to do the work.
  Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
  Write-Host TopFewCount is the number of top few items shown. Default value is 10
  Write-Host ExcludeFolders is passed as given to ListItemWoXF.ps1
  Write-Host If ExcludeFolders is omitted`, default value of `"`" is passed to ListItemWoXF.ps1
  Write-Host If UTC is Y or y then time is additionally shown in UTC. Default value is empty string and so UTC time is not shown.
  Write-Host /? passed as first parameter shows this help message.
}

if ($Path -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

# Define the base command without the final output formatting
$baseCommand = "ListItemWoXF.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | Select-Object -first $TopFewCount"

# Define the output format string based on the UTC flag
if ($UTC -eq "y") { # -eq is case-insensitive
    $outputFormat = 'Write-Host "$($_.LastWriteTime), UTC:$($_.LastWriteTimeUtc) $($_.FullName)"'
} else {
    $outputFormat = 'Write-Host "$($_.LastWriteTime) $($_.FullName)"'
}

# Combine the base command and the output format string
$Cmd = "$baseCommand | ForEach-Object {$outputFormat}"

# Display the final command to the user
Write-Host "Executing command: $Cmd"

# Execute the final command
Invoke-Expression -Command $Cmd

# if ($UTC -eq "y" -or $UTC -eq "Y") {
#   $Cmd = "ListItemWoXF.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | " +
#         "Select-Object -first $TopFewCount | ForEach-Object {Write-Host `"`$(`$_.LastWriteTime), UTC:`$(`$_.LastWriteTimeUtc) `$(`$_.FullName)`"}"
#   Write-Host "Executing command: $Cmd"

#   ListItemWoXF.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | `
#     Select-Object -first $TopFewCount | ForEach-Object {Write-Host "$($_.LastWriteTime), UTC:$($_.LastWriteTimeUtc) $($_.FullName)"}
# } else {
#   $Cmd = "ListItemWoXF.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | " +
#         "Select-Object -first $TopFewCount | ForEach-Object {Write-Host `"`$(`$_.LastWriteTime) `$(`$_.FullName)`"}"
#   Write-Host "Executing command: $Cmd"

#   ListItemWoXF.ps1 $Path $ExcludeFolders | Sort-Object -Descending -Property LastWriteTime | `
#     Select-Object -first $TopFewCount | ForEach-Object {Write-Host "$($_.LastWriteTime) $($_.FullName)"}
# } 
