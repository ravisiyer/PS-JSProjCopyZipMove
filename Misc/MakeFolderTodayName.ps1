param ($DestinationFolder="E:\TempBack")
function Usage {
    param ($cmdName)
    Write-Host "Make (create) folder with today's date (yyyyMMdd) as name."`n
    Write-Host Usage: $cmdName [DestinationFolder]`n
    Write-Host DestinationFolder is the location where the new folder will be created. By default it is: "E:\TempBack" .
    Write-Host "New folder name will be today's date as yyyyMMdd ."
    Write-Host /? passed as first parameter shows this help message.`n
}

if ($DestinationFolder -eq "/?") { 
    Usage $myInvocation.InvocationName
    exit 0
}

If ( -not (Test-Path -path $DestinationFolder -PathType Container)) {
    If (Test-Path -path $DestinationFolder) {
      Write-Error "DestinationFolder parameter specified: '$DestinationFolder' is not a directory. Aborting!"
    } Else {
      Write-Error "DestinationFolder parameter specified: '$DestinationFolder' does not exist. Aborting!"
    }
    Usage $myInvocation.InvocationName
    exit 1
  }
  
$TodaysDate = Get-Date -Format "yyyyMMdd"
$NewFolderPath = $DestinationFolder + "\" + $TodaysDate
If (Test-Path -path $NewFolderPath) {
    Write-Error "Folder/file: '$TodaysDate' already exists in Destination Folder: $DestinationFolder . Aborting!"
    exit 1
} 

$NewCmd = "New-Item -Path $DestinationFolder -Name $TodaysDate -ItemType directory"
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
  
Write-Host Above command executed.
exit 0
