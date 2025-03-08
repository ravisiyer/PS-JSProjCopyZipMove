# Copies contents of a folder/directory based on maxage but excludes some dirs like node_modules
# It uses Copywoxfldr script to do the main work.
#
param ($InputFolder="", $MaxAge="1", $ExcludeFolders="")
$OutputFolder = ""
$OutputSuffix ="-maxage"
function Usage {
  param ($cmdName)
  Write-Host Usage: $cmdName Source-Folder-Name [MaxAge Exclude-Folders-List]
  Write-Host If MaxAge is not specified, default value of 1 [day] is used
  Write-Host Exclude-Folders-List is passed as given to Copywoxfldr.ps1
  Write-Host If Exclude-Folders-List is omitted`, default value of - is passed to Copywoxfldr.ps1
  Write-Host "Output folder name is generated by concatenating today's date as yyyyMMdd- as prefix" `
    "and $OutputSuffix as suffix to Source-Folder-Name"
}

if ( "" -eq $InputFolder  ) {
    write-host "Input folder not specified."
    Usage $myInvocation.InvocationName
    exit 1
  }

$InputFolder = $InputFolder.trim()

$len = $InputFolder.length
if (($len -gt 1) -and (".\" -eq $InputFolder.substring(0,2))) {
    $InputFolder = $InputFolder.substring(2,$len-2)
    Write-Host "Input parameter (folder name) had starting dot and backslash which was stripped" 
}
$len = $InputFolder.length
if ("\" -eq $InputFolder.substring($len-1,1)) {
  $InputFolder = $InputFolder.substring(0, $len-1)
  Write-Host "Input parameter (folder name) had trailing backslash which was stripped" 
}

# Write-Host "Input parameter (folder name) is: '$InputFolder'" 
# Write-Host "Note that Powershell strips enclosing quote characters of parameters when passing them to script."

If ( -not (Test-Path -path $InputFolder -PathType Container)) {
  If (Test-Path -path $InputFolder) {
    Write-Host "Parameter specified: '$InputFolder' is not a directory. Aborting!"
  } Else {
    Write-Host "Parameter specified: '$InputFolder' does not exist. Aborting!"
  }
  Usage $myInvocation.InvocationName
  exit 1
}

$TodayDate = Get-Date -Format "yyyyMMdd-"
$OutputFolder = $TodayDate + $InputFolder + $OutputSuffix + "-" + $MaxAge
If (Test-Path -path $OutputFolder) {
  Write-Host "Output folder/directory name with auto prefix and suffix: '$OutputFolder' already exists. Aborting!"
  exit 1
} 

if ( "" -eq $ExcludeFolders  ) {
  $ExcludeFolders = "-"
}

#Write-Host Usage: $cmdName Source-Folder-Name [Exclude-Folders-List MaxAge Output-Folder-Name LogFile]
$Cmd = "Copywoxfldr $InputFolder $ExcludeFolders $MaxAge $OutputFolder"
# $Cmd = "Copywoxfldr $InputFolder - $MaxAge $OutputFolder"
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd