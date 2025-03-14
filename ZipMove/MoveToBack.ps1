#
param ($InputFolderOrFile="", $BackupFolder="")
$BackupFolderDefault = "E:\TempBack"

function Usage {
  param ($cmdName)
  Write-Host "Move InputFolderOrFile to BackupFolder."`n
  Write-Host Usage: $cmdName InputFolderOrFile [BackupFolder]`n
  Write-Host BackupFolder is the final copy location. By default it is: $BackupFolderDefault
  Write-Host /? passed as first parameter shows this help message.`n
}

if ($InputFolderOrFile -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

if ( "" -eq $InputFolderOrFile  ) {
  write-error "Input folder or file not specified."
  Usage $myInvocation.InvocationName
  exit 1
}

If ( -not (Test-Path -path $InputFolderOrFile)) {
  Write-Error "Input folder or file parameter specified: '$InputFolderOrFile' does not exist. Aborting!"
  Usage $myInvocation.InvocationName
  exit 1
}

if (( "" -eq $BackupFolder  ) -or ("-" -eq $BackupFolder)) {
    $BackupFolder = $BackupFolderDefault
}

$MoveCmd = "Move-Item -Path $InputFolderOrFile -Force -Destination $BackupFolder"
Write-Host `n"Move command to be executed:"
Write-Host $MoveCmd

$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
$Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)

if (1 -eq $Choice)
{
  Write-Error "Aborted!"
  exit 1
} else {
  try {
    Invoke-Expression $MoveCmd
  }
  catch {
    Write-Error "Above command threw exception: $($PSItem.ToString())"
    exit 1
  }
}

Write-Host
exit 0
