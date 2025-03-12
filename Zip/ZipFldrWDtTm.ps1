param ($InputFolder="", $AddDateTimePrefix="Y")
function Usage {
  param ($cmdName)
  Write-Host "Zip folder or file with Date and Time prefix by default in output zip filename."`n
  Write-Host Usage: $cmdName Input-Folder-Name [AddDatePrefix]`n
  Write-Host If AddDatePrefix is not specified, default value of "Y" is used.
  Write-Host If AddDatePrefix is "Y", current date time as yyyyMMdd-HHmm- will be prefixed to Input-Folder-Name `
    to generate output zip file name.`n
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
    # Write-Host "Input parameter (folder name) had starting dot and backslash which was stripped" 
}
$len = $InputFolder.length
if ("\" -eq $InputFolder.substring($len-1,1)) {
  $InputFolder = $InputFolder.substring(0, $len-1)
  # Write-Host "Input parameter (folder name) had trailing backslash which was stripped" 
}

If ( -not (Test-Path -path $InputFolder -PathType Container)) {
  If (Test-Path -path $InputFolder) {
    Write-Host "Parameter specified: '$InputFolder' is not a directory. Aborting!"
  } Else {
    Write-Host "Parameter specified: '$InputFolder' does not exist. Aborting!"
  }
  Usage $myInvocation.InvocationName
  exit 1
}

$OutputZipFile = $InputFolder + ".zip"

if ("Y" -eq $AddDateTimePrefix) {
    $NowDateTime = Get-Date -Format "yyyyMMdd-HHmm-"
    $OutputZipFile = $NowDateTime + $OutputZipFile
}
If (Test-Path -path $OutputZipFile) {
  Write-Host "Output Zip filename with auto prefix: '$OutputZipFile' already exists. Aborting!"
  exit 1
} 

$Cmd = "Compress-Archive -Path $InputFolder -DestinationPath $OutputZipFile"
Write-Host "Command to be executed: $Cmd"
Write-Host "Note that hidden folders (including .git) will be excluded from the output zip file as that is how Compress-Archive works."
Write-Host " To include hidden folders, use 7-zip (outside of this script)."
$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
$Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)

if (1 -eq $Choice)
{
    Write-Host "Aborted!"
    exit 1
}

try {
  Invoke-Expression $Cmd
}
catch {
  Write-Error "Above command threw exception: $($PSItem.ToString())"
  exit 1
}

Write-Host Above command executed.
exit 0
