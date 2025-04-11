# Copy all source files and folders of an Android or React Native project
param ($InputFolder="")
function Usage {
    param ($cmdName)
    Write-Host "Copy all source files and folders of an Android or React Native project."`n
    Write-Host Usage: $cmdName InputFolder`n
    Write-Host CopyWoXF.ps1 is invoked to do the copy`n
}
  
if ($InputFolder -eq "/?") { 
    Usage $myInvocation.InvocationName
    exit 0
}
  
if ( "" -eq $InputFolder  ) {
    write-host "Input folder not specified."
    Usage $myInvocation.InvocationName
    exit 1
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

$Cmd = "CopyWoXF '$InputFolder' `"node_modules build release .gradle`""
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd