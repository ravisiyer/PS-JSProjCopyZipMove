param ($InputFolder="", $ExcludeFolders="")
function Usage {
    param ($cmdName)
    Write-Host This script is a wrapper around CpXFZipMv script tailored for backup copy with MaxAge using 7zip.
    Write-Host User is prompted for MaxAge.`n
    Write-Host Usage: $cmdName InputFolder [ExcludeFolders]`n
    Write-Host ExcludeFolders is passed as given to CpXFZipMv. By default it is empty string.
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

Write-Host "In dir: $pwd"

$MaxAge = Read-Host -Prompt "Please specify MaxAge [1]"

if ([string]::IsNullOrWhiteSpace($MaxAge)) {
	$MaxAge = 1
}

Write-Host "CpXFZipMv '$InputFolder' $MaxAge Y Y $ExcludeFolders"
$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
$Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)
if (1 -eq $Choice)
{
  Write-Error "Aborted!"
  exit 1
}

CpXFZipMv $InputFolder $MaxAge Y Y $ExcludeFolders
