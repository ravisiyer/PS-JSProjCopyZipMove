# Copy all source files and folders of a React Native (web and Android only) project
param ($InputFolder="")
function Usage {
    param ($cmdName)
    Write-Host "Copy all source files and folders of a React Native (web and Android only) project."`n
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

# Have not added ios folder as my development is on Windows where development build creates only
# android folder. Others who want to use this script on Macintosh may consider adding ios folder to last string 
# parameter below.
$Cmd = "CopyWoXF '$InputFolder' `"node_modules android`""
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd