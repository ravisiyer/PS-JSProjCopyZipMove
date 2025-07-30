# Copy all source files and folders of a project
param (
    [string]$InputFolder = "",
    [string]$ProjectType = "Others"
)
function Usage {
    param ($cmdName)
    Write-Host "Copy all source files and folders of a project."`n
    Write-Host "Usage: $cmdName InputFolder ProjectType"
    Write-Host "ProjectType: ReactNative, Android, DotNet, Others"
    Write-Host "If ProjectType is not specified, default is: Others"`n
    Write-Host "CopyWoXF.ps1 is invoked to do the copy"`n
}

if ($InputFolder -eq "/?") { 
    Usage $myInvocation.InvocationName
    exit 0
}

if ("" -eq $InputFolder) {
    Write-Host "Input folder not specified."
    Usage $myInvocation.InvocationName
    exit 1
}

If (-not (Test-Path -path $InputFolder -PathType Container)) {
    If (Test-Path -path $InputFolder) {
        Write-Host "InputFolder parameter specified: '$InputFolder' is not a directory. Aborting!"
    } Else {
        Write-Host "InputFolder parameter specified: '$InputFolder' does not exist. Aborting!"
    }
    Usage $myInvocation.InvocationName
    exit 1
}

# Validate ProjectType
$validTypes = @("ReactNative", "Android", "DotNet", "Others")
if ($ProjectType -notin $validTypes) {
    Write-Host "Invalid ProjectType specified: '$ProjectType'"
    Usage $myInvocation.InvocationName
    exit 1
}

switch ($ProjectType) {
    "ReactNative" { $exclude = "node_modules android ios .expo .gradle" }
    "Android"     { $exclude = "build release .gradle .idea" }
    "DotNet"      { $exclude = "bin obj node_modules" }
    "Others"      { $exclude = "node_modules .next .gradle .idea .cache .expo build target" }
}

$Cmd = "CopyWoXF '$InputFolder' `"$exclude`""
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd