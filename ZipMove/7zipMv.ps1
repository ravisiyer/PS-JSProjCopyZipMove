param ($InputFolder="")
function Usage {
    param ($cmdName)
    Write-Host This script is a wrapper around ZipMv script tailored for zip with Use7zip Y and UseTodaySubFolder Y.`n
    Write-Host Usage: $cmdName InputFolder`n
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

$Cmd = "ZipMv '$InputFolder' Y Y"
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd
