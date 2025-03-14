# List virtually all (modified in last around 10 years), files and folders (excl. special folders)
param ($Path = $pwd)
function Usage {
    param ($CmdName)
    Write-Host "List virtually all files and folders (modified in last around 10 years) excluding specified/default folders."`n
    Write-Host Usage: $CmdName [Path]`n
    Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
    Write-Host /? passed as first parameter shows this help message.
}

if ($Path -eq "/?") { 
    Usage $myInvocation.InvocationName
    exit 0
}
  
$Cmd = "ListMaxAgeFF.ps1 $Path 3700"
Write-Host "Invoking command: $Cmd"
Invoke-Expression $Cmd

