# Copy all source files and folders of a project
param (
    [string]$InputFolder = "",
    [string]$ProjectType,
    [string]$MaxAge="",
    [string]$OutputFolder="",
    [string]$LogFile=""
)

. "$PSScriptRoot\ProjectTypeExcludes.ps1"

if (-not $ProjectType) {
    $ProjectType = $DefaultProjectType
}

function Usage {
    param ($cmdName)
    Write-Host "Copy all source files and folders of a project."`n
    Write-Host "Usage: $cmdName InputFolder ProjectType MaxAge OutputFolder LogFile"
    Write-Host ("ProjectType: {0}" -f ($validTypes -join ", "))
    Write-Host ("If ProjectType is not specified, default is: {0}`n" -f $DefaultProjectType)
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
if ($ProjectType -notin $validTypes) {
    Write-Host "Invalid ProjectType specified: '$ProjectType'"
    Usage $myInvocation.InvocationName
    exit 1
}

$exclude = $ProjectTypeExcludes[$ProjectType]

$Cmd = "CopyWoXF -InputFolder '$InputFolder' -ExcludeFolders `"$exclude`" -MaxAge '$MaxAge' -OutputFolder '$OutputFolder' -LogFile '$LogFile'"
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd