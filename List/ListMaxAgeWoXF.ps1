# List last modified in x days, files and folders OR only unique parent folder names, (excl. special folders by default)
# It uses ListItemWoXF.ps1 to do the main work
#
# Usage examples:
# Folders and files modified in last 4 days are included but default folders are excluded, 
# script-name test 4
#
# Folders and files modified in last 1 day are included but build and .git folders are excluded
# script-name test 1 "build .git"
#
# Folders and files modified in last 10 days are included but node_modules folder is excluded
# script-name test 10 "node_modules"
#
# Folders and files modified in last 1 day are included and no folders are excluded
# script-name test 1 ExcludeNone
#
param ($Path = $pwd, $MaxAge="1", $ExcludeFolders="", $Unique="")

function Usage {
  param ($CmdName)
  Write-Host "List last modified in x days, files and folders OR only unique parent folder names, excluding specified/default folders"`n
  Write-Host Usage: $CmdName [Path MaxAge Exclude-Folders-List UniqueParentFolder]`n
  Write-Host This script relies on ListItemWoXF.ps1 to do the work.
  Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
  Write-Host If MaxAge is not specified`, default value of 1 [day] is used
  Write-Host Exclude-Folders-List is passed as given to ListItemWoXF.ps1
  Write-Host If Exclude-Folders-List is omitted`, default value of `"`" is passed to ListItemWoXF.ps1
  Write-Host If UniqueParentFolder is specified`, it has to be 'upf' [without quotes] and then`, only unique parent folder names are listed.
  Write-Host If UniqueParentFolder is not specified`, files and folders are listed.
  Write-Host /? passed as first parameter shows this help message.
}

if ($Path -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

# Ref: https://collectingwisdom.com/powershell-check-if-variable-is-number/
if (($MaxAge  -match "^[\d]+$") -and ($MaxAge -gt 0)) { 
  Write-Host MaxAge is $MaxAge
 } else {
  Usage $myInvocation.InvocationName
  exit 1
}

if ($Unique -eq "") {
  Write-Host Files and folders output by ListItemWoXF.ps1 will be listed [Unique is ""]
} elseif ($Unique -eq "upf") { 
  Write-Host Only unique parent folder names in output of ListItemWoXF.ps1 will be listed [Unique is `"upf`"]
} else {
  Usage $myInvocation.InvocationName
  exit 1
}

if ($Unique -eq "upf") {
  $Cmd = "ListItemWoXF.ps1 $Path $ExcludeFolders | Where-Object { ((get-date)-`$_.LastWriteTime).days -lt $MaxAge } " +
  "| ForEach-Object {Split-Path -Parent `$_.FullName} | Select-Object -unique "
  Write-Host "Executing command: $Cmd"
  ListItemWoXF.ps1 $Path $ExcludeFolders | Where-Object { ((get-date)-$_.LastWriteTime).days -lt $MaxAge } `
  | ForEach-Object {Split-Path -Parent $_.FullName} | Select-Object -unique 
} else {
  $Cmd = "ListItemWoXF.ps1 $Path $ExcludeFolders | Where-Object { ((get-date)-`$_.LastWriteTime).days -lt $MaxAge } " +
  "| ForEach-Object {`"`$(`$_.LastWriteTime) `$(`$_.FullName)`"}"
  Write-Host "Executing command: $Cmd"
  ListItemWoXF.ps1 $Path $ExcludeFolders | Where-Object { ((get-date)-$_.LastWriteTime).days -lt $MaxAge } `
  | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
}
