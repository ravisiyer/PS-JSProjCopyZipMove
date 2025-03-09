param ($InputFolder="", $AddDatePrefix="Y")
$OutputFolder = ""
# $OutputSuffix ="-maxage"
function Usage {
  param ($cmdName)
  Write-Host Usage: $cmdName Input-Folder-Name [AddDatePrefix]
  Write-Host If AddDatePrefix is not specified, default value of "Y" is used
  Write-Host If AddDatePrefix is "Y" current date as yyyyMMdd- will be prefixed to Input-Folder-Name to generate output zip file name
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
# $OutputZipFile = $TodayDate + $InputFolder + ".zip"

if ("Y" -eq $AddDatePrefix) {
    $TodayDate = Get-Date -Format "yyyyMMdd-"
    $OutputZipFile = $TodayDate + $OutputZipFile
}
If (Test-Path -path $OutputZipFile) {
  Write-Host "Output Zip filename with auto prefix: '$OutputZipFile' already exists. Aborting!"
  exit 1
} 

# $Cmd = "Compress-Archive -Path $InputFolder -DestinationPath $OutputZipFile"
# $Cmd = "Compress-Archive -Confirm -Path $InputFolder -DestinationPath $OutputZipFile"
$Cmd = "Compress-Archive -Path $InputFolder -DestinationPath $OutputZipFile"
Write-Host "Command to be executed: $Cmd"

$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
$Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)

if (1 -eq $Choice)
{
    Write-Host "Aborted!"
    exit 1
}

Invoke-Expression $Cmd