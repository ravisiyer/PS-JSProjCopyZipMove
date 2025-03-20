#
param ($InputFolder="", $Use7zip = "N", $UseTodaySubFolder="N", $AddDateTimePrefix="Y", $BackupFolder="")
$BackupFolderDefault = "E:\TempBack"

function Usage {
  param ($cmdName)
  Write-Host "Zip folder or file with Date and Time prefix by default in output zip filename + Move OutputZipFile to BackupFolder"`n
  Write-Host Usage: $cmdName InputFolder [Use7zip UseTodaySubFolder AddDateTimePrefix BackupFolder]`n
  Write-Host If Use7zip is "Y" then 7zip is used instead of Compress-Archive to create zip file.
  Write-Host " By default, Use7zip is N and then Compress-Archive is used to create zip file."
  Write-Host " Compress-Archive does not include hidden folders and files (including .git). 7zip includes hidden folders and files."
  Write-Host "If UseTodaySubFolder (default N) is Y, if required, create sub-folder with name of today's date as yyyyMMdd in BackupFolder."
  Write-Host "If UseTodaySubFolder is Y, final copy location is sub-folder with today's date as name in BackupFolder, else it is BackupFolder."
  Write-Host If AddDateTimePrefix is not specified, default value of "Y" is used.
  Write-Host If AddDateTimePrefix is "Y", current date time as yyyyMMdd-HHmm- will be prefixed to InputFolder `
    to generate output zip file name.
  Write-Host By default BackupFolder is: $BackupFolderDefault
  Write-Host /? passed as first parameter shows this help message.`n
}

if ($InputFolder -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

if ( "" -eq $InputFolder  ) {
  write-error "Input folder not specified."
  Usage $myInvocation.InvocationName
  exit 1
}

$InputFolder = $InputFolder.trim()

$len = $InputFolder.length
if (($len -gt 1) -and (".\" -eq $InputFolder.substring(0,2))) {
    $InputFolder = $InputFolder.substring(2,$len-2)
}
$len = $InputFolder.length
if ("\" -eq $InputFolder.substring($len-1,1)) {
  $InputFolder = $InputFolder.substring(0, $len-1)
}

If ( -not (Test-Path -path $InputFolder -PathType Container)) {
  If (Test-Path -path $InputFolder) {
    Write-Host "InputFolder parameter specified: '$InputFolder' is not a directory. Aborting!"
  } Else {
    Write-Host "InputFolder parameter specified: '$InputFolder' does not exist. Aborting!"
  }
  Usage $myInvocation.InvocationName
  exit 1
}

if (( "" -eq $BackupFolder  ) -or ("-" -eq $BackupFolder)) {
    $BackupFolder = $BackupFolderDefault
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
if ("Y" -eq $Use7zip) {
  $Cmd = "7z a '$OutputZipFile' '$InputFolder' "
} else {
  $Cmd = "Compress-Archive -Path '$InputFolder' -DestinationPath '$OutputZipFile'"
  Write-Host "Note that hidden folders (including .git) will be excluded from the output zip file as that is how Compress-Archive works."
  Write-Host " To include hidden folders, use 7-zip by passing parameter Use7zip as Y ."
}

Write-Host "Command to be executed: $Cmd"

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

$MoveCmd = "Move-Item -Path '$OutputZipFile' -Destination '$DestinationFolder'"
Write-Host `n"Move OutputZipFile command to be executed:"
Write-Host $MoveCmd

$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
$Choice = $host.UI.PromptForChoice("", "Proceed (or skip)?", $Choices, 1)

if (1 -eq $Choice)
{
  Write-Host "Skipped!"
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
