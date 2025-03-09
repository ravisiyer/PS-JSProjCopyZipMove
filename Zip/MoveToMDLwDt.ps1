param ($InputFolderOrFile="", $AddDateTimePrefix="Y")
$MDLFolderName = "MayDeleteLater"
function Usage {
  param ($cmdName)
  Write-Host Usage: $cmdName Input-Folder-Or-File-Name [AddDateTimePrefix]
  Write-Host If AddDateTimePrefix is not specified, default value of "Y" is used
  Write-Host If AddDateTimePrefix is "Y" current date as yyyyMMdd-hhmm- will be prefixed to Input-Folder-or-File-Name 
  Write-Host when it is moved to MDL [MayDeleteLater] folder: $MDLFolderName
}

if ( "" -eq $InputFolderOrFile  ) {
    write-host "Input folder or file not specified."
    Usage $myInvocation.InvocationName
    exit 1
  }

$InputFolderOrFile = $InputFolderOrFile.trim()

$len = $InputFolderOrFile.length
if (($len -gt 1) -and (".\" -eq $InputFolderOrFile.substring(0,2))) {
    $InputFolderOrFile = $InputFolderOrFile.substring(2,$len-2)
    Write-Host "Input parameter (folder or file name) had starting dot and backslash which was stripped" 
}
$len = $InputFolderOrFile.length
if ("\" -eq $InputFolderOrFile.substring($len-1,1)) {
  $InputFolderOrFile = $InputFolderOrFile.substring(0, $len-1)
  Write-Host "Input parameter (folder or file name) had trailing backslash which was stripped" 
}

If ( -not (Test-Path -path $InputFolderOrFile)) {
    Write-Host "Parameter specified: '$InputFolderOrFile' does not exist. Aborting!"
    Usage $myInvocation.InvocationName
    exit 1
} 

# An alternative (better perhaps) is to use Split-Path -Path xyz -Resolve
# As I seem to already have the working solution below, I am keeping it as is
$InputFFDrive = ""
if ($InputFolderOrFile.length -ge 2) {
    if ($InputFolderOrFile.substring(1,1) -eq ":") {
        $InputFFDrive = $InputFolderOrFile.substring(0,1)
    }
}
if ("" -eq $InputFFDrive) {
    # Write-Host Current Drive is: $pwd.drive.name
    $InputFFDrive = $pwd.drive.name
}
Write-Host InputFFDrive is: $InputFFDrive
$MDLFolderPath =  $InputFFDrive + ":\" + $MDLFolderName
If ( -not (Test-Path -path $MDLFolderPath -PathType Container)) {
    If (Test-Path -path $MDLFolderPath) {
      Write-Host "$MDLFolderPath is a file! Aborting!"
      } Else {
      Write-Host "$MDLFolderPath does not exist. Aborting!"
    }
    Usage $myInvocation.InvocationName
    exit 1
}
Write-Host MDL [MayDeleteLater] folder path that will be used is: $MDLFolderPath


$FinalOutputFolderOrFile = $InputFolderOrFile 
if ("Y" -eq $AddDateTimePrefix) {
    $NowDateTime = Get-Date -Format "yyyyMMdd-hhmm-"
    $Leaf = Split-Path -Path $InputFolderOrFile -Leaf
    $FinalOutputFolderOrFileLeaf = $NowDateTime + $Leaf
    $Parent = Split-Path -Path $InputFolderOrFile -Parent
    if ("" -eq $Parent) {
        $FinalOutputFolderOrFile = $FinalOutputFolderOrFileLeaf
    } else {
        $FinalOutputFolderOrFile = $Parent + "\" + $FinalOutputFolderOrFileLeaf
    }
    # $RenCmd = "Rename-Item -Path $InputFolderOrFile -NewName $FinalOutputFolderOrFile"
    $RenCmd = "Rename-Item -Path $InputFolderOrFile -NewName $FinalOutputFolderOrFileLeaf"
    Write-Host "Rename Command to be executed: $RenCmd"

    $Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
    $Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)
    
    if (1 -eq $Choice)
    {
        Write-Host "Aborted!"
        exit 1
    }
    
    Invoke-Expression $RenCmd
} 

$MoveCmd = "Move-Item -Path $FinalOutputFolderOrFile -Destination $MDLFolderPath"

Write-Host "Move Command to be executed: $MoveCmd"

$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
$Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)

if (1 -eq $Choice)
{
    Write-Host "Aborted!"
    exit 1
}

Invoke-Expression $MoveCmd