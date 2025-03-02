param ($InputFolder="")
$OutputFolder = ""
$OutputSuffix ="-wo-nmnx"
function Usage {
  param ($cmdName)
  Write-Host Usage: $cmdName Source-Folder-Name
}

if ( "" -eq $InputFolder  ) {
    write-host "Input folder not specified."
    Usage $myInvocation.InvocationName
    exit 1
  }

$InputFolder = $InputFolder.trim()

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

$OutputFolder = $InputFolder + $OutputSuffix
If (Test-Path -path $OutputFolder) {
  Write-Host "Output folder/directory name with auto suffix: '$OutputFolder' already exists. Aborting!"
  exit 1
} 

Write-Host "Command to be executed (for readability of below output, single quotes are added around folder names ..." 
Write-Host "but these added single quotes are not passed to robocopy command):", `n
Write-Host "robocopy '$InputFolder' '$OutputFolder' /E /XD node_modules .next", `n
$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
$Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)

if (1 -eq $Choice)
{
    Write-Host "Aborted!"
    exit 1
}

robocopy $InputFolder $OutputFolder /E /XD node_modules .next
