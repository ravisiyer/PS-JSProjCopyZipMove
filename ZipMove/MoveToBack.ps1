#
param ($InputFolderOrFile="", $UseTodaySubFolder="N", $BackupFolder="")
$BackupFolderDefault = "E:\TempBack"

function Usage {
  param ($cmdName)
  Write-Host "Move InputFolderOrFile to BackupFolder or TodaySubFolder in BackupFolder."`n
  Write-Host Usage: $cmdName InputFolderOrFile [UseTodaySubFolder BackupFolder]`n
  Write-Host "If UseTodaySubFolder (default N) is Y, if required, create sub-folder with name of today's date as yyyyMMdd in BackupFolder."
  Write-Host "If UseTodaySubFolder is Y, final copy location is sub-folder with today's date as name in BackupFolder, else it is BackupFolder."
  Write-Host By default BackupFolder is: $BackupFolderDefault
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

If ( -not (Test-Path -path $BackupFolder)) {
  Write-Error "BackupFolder parameter specified: '$BackupFolder' does not exist. Aborting!"
  Usage $myInvocation.InvocationName
  exit 1
}

$DestinationFolder = $BackupFolder

if ("Y" -eq $UseTodaySubFolder) {
  $TodaysDate = Get-Date -Format "yyyyMMdd"
  $DestinationFolder = Join-Path -Path $BackupFolder -ChildPath $TodaysDate
  If ( -not (Test-Path -path $DestinationFolder)) {
    $NewCmd = "New-Item -Path '$BackupFolder' -Name '$TodaysDate' -ItemType directory"
    Write-Host "New command to be executed: $NewCmd"
    
    $Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
    $Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)
    
    if (1 -eq $Choice)
    {
        Write-Host "Aborted!"
        exit 1
    }
    
    try {
        Invoke-Expression $NewCmd
    }
    catch {
        Write-Error "Above command threw exception: $($PSItem.ToString())"
        exit 1
    }
  }
}


# -Force seems to be needed to avoid access errors for hidden folders like .git
$MoveCmd = "Move-Item -Path '$InputFolderOrFile' -Force -Destination '$DestinationFolder'"
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
