# Wrapper script to invoke CpXFProj7ZipMv.ps1 for a ReactNative project

param (
    [string]$InputFolder = "",
    [string]$MaxAge = "-"
)

if ("" -eq $InputFolder -or $InputFolder -eq "/?") {
    Write-Host "Copy, zip, and move all source files and folders of a React Native (web and mobile) project."`n
    Write-Host "Usage: $($myInvocation.InvocationName) -InputFolder <PathToReactNativeProject> [-MaxAge <string>]"`n
    Write-Host "CpXFProj7ZipMv.ps1 is invoked to do the operation"`n
    exit 1
}

& CpXFProj7ZipMv.ps1 -InputFolder $InputFolder -ProjectType ReactNative -MaxAge $MaxAge
