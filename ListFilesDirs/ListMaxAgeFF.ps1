# List last modified in x days, files and folders OR only unique parent folder names, (excl. special folders by default)
# It uses ExcludeDirsRecurseListFilesDirs.ps1 to do the main work
#
# Usage examples:
# Default folders are excluded
# script-name test 4000
#
# build and .git folders are excluded
# script-name test 4000 "build .git"
#
# node_modules folder is excluded
# script-name test 4000 "node_modules"
#
# no folders are excluded (all are included)
# script-name test 4000 ExcludeNone
#
param ($Path = $pwd, $MaxAge="1", $ExcludeFolders="", $Unique="")

function Usage {
  param ($CmdName)
  Write-Host "List last modified in x days, files and folders OR only unique parent folder names, (excl. special folders by default)"`n
  Write-Host Usage: $CmdName [Path MaxAge Exclude-Folders-List UniqueParentFolder]`n
  Write-Host This script relies on ExcludeDirsRecurseListFilesDirs.ps1 to do the work.
  Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
  Write-Host If MaxAge is not specified`, default value of 1 [day] is used
  Write-Host Exclude-Folders-List is passed as given to ExcludeDirsRecurseListFilesDirs.ps1
  Write-Host If Exclude-Folders-List is omitted`, default value of `"`" is passed to ExcludeDirsRecurseListFilesDirs.ps1
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
  Write-Host Files and folders output by ExcludeDirsRecurseListFilesDirs.ps1 will be listed [Unique is ""]
} elseif ($Unique -eq "upf") { 
  Write-Host Only unique parent folder names in output of ExcludeDirsRecurseListFilesDirs.ps1 will be listed [Unique is `"upf`"]
} else {
  Usage $myInvocation.InvocationName
  exit 1
}

if ($Unique -eq "upf") {
  ExcludeDirsRecurseListFilesDirs.ps1 $Path $ExcludeFolders | Where-Object { ((get-date)-$_.LastWriteTime).days -lt $MaxAge } `
  | ForEach-Object {Split-Path -Parent $_.FullName} | Select-Object -unique 
} else {
  ExcludeDirsRecurseListFilesDirs.ps1 $Path $ExcludeFolders | Where-Object { ((get-date)-$_.LastWriteTime).days -lt $MaxAge } `
  | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
}
