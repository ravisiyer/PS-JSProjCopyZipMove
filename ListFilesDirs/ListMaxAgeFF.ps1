# List last modified in x days, files and folders (excl. special folders) OR only unique parent folder names
# It uses ExcludeDirsRecurseListFilesDirs.ps1 to do the main work
#
param ($MaxAge="1", $ExcludeFoders="", $Unique="")
function Usage {
  param ($cmdName)
  Write-Host Usage: $cmdName [MaxAge] ['upf']
  Write-Host Usage: If MaxAge is not specified`, default value of 1 [day] is used
  Write-Host Usage: If second parameter is specified`, it has to be 'upf' [without quotes]. 
  Write-Host Usage: If upf is specified`, only unique parent folder names are listed.
  Write-Host Usage: If upf is not specified`, files and folders are listed.
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
  ExcludeDirsRecurseListFilesDirs.ps1 | Where-Object { ((get-date)-$_.LastWriteTime).days -lt $MaxAge } `
  | ForEach-Object {Split-Path -Parent $_.FullName} | Select-Object -unique 

} else {
  ExcludeDirsRecurseListFilesDirs.ps1 | Where-Object { ((get-date)-$_.LastWriteTime).days -lt $MaxAge } `
  | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}

}
