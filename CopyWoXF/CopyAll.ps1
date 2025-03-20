# Copy all files and folders. No folders are excluded. 
param ($InputFolder="", $OutputFolder="")
function Usage {
    param ($cmdName)
    Write-Host "Copy all files and folders. No folders are excluded."`n
    Write-Host Usage: $cmdName InputFolder OutputFolder `n
    Write-Host CopyWoXF.ps1 is invoked to do the copy
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
  
if ( "" -eq $OutputFolder  ) {
    write-host "Output folder not specified."
    Usage $myInvocation.InvocationName
    exit 1
}

If (Test-Path -path $OutputFolder) {
    Write-Host "Output folder/directory: '$OutputFolder' already exists. Aborting!"
    exit 1
} 
  
$Cmd = "CopyWoXF '$InputFolder' ExcludeNone - '$OutputFolder'"
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd