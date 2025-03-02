param ($InputFolder="")
$OutputFolder = ""
$OutputSuffix ="-wo-nmnx"
function Usage {
  param ($cmdName)
  Write-Host Usage: $cmdName Source-Folder-Name
}

function TrailingBackslash {

  Write-Host "Input parameter (folder name): '$InputFolder' ends with backslash."
  # Write-Host "Note that robocopy seems to trip up if directory name is in quotes and ends in backslash."
  Write-Host "To keep this script file simple, I am not handling the condition of input folder/directory name",
   "ending in backslash."
  # Write-Host "You may please consider using robocopy manually."
  # Write-Host "Note that adding a space after trailing backslash before ending quote is said to fix the robocopy issue."
  Write-Host "Aborting!"
  exit 1
}


if ( "" -eq $InputFolder  ) {
    write-host "Input folder not specified."
    Usage $myInvocation.InvocationName
    exit 1
  }

$len = $InputFolder.length
# Write-Host "Last character of input folder is: "  $InputFolder.substring($len-1,1)
if ("\" -eq $InputFolder.substring($len-1,1)) {
  TrailingBackslash
  exit 1
}

Write-Host "Input parameter (folder name) specified is: ", $InputFolder 
Write-Host "Note that powershell strips enclosing quote characters of parameters when passing them to script."

# If ( -not (Test-Path -path $x)) {} // syntax for testing not condition 

# If (Test-Path -path $InputFolder -PathType Container) {
#   Write-Host "Source/input folder/directory: '$InputFolder' exists."
# } Else {
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
# Write-Host $OutputFolder
If (Test-Path -path $OutputFolder) {
  Write-Host "Output folder/directory name with auto suffix: '$OutputFolder' already exists. Aborting!"
  exit 1
} 

Write-Host "Command to be executed: robocopy $InputFolder $OutputFolder /E /XD node_modules .next"
$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
$Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)

if (1 -eq $Choice)
{
    Write-Host "Aborted!"
    exit 1
}

robocopy $InputFolder $OutputFolder /E /XD node_modules .next
# exit $LASTEXITCODE