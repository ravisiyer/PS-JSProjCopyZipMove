# Wrapper script to invoke CpXFProj7ZipMv.ps1 for an Android project

param (
    [string]$InputFolder = "",
    [string]$MaxAge = "-"
)

if ("" -eq $InputFolder -or $InputFolder -eq "/?") {
    Write-Host "Copy, zip, and move all source files and folders of an Android project."`n
    Write-Host "Usage: $($myInvocation.InvocationName) -InputFolder <PathToAndroidProject> [-MaxAge <string>]"`n
    Write-Host "CpXFProj7ZipMv.ps1 is invoked to do the operation"`n
    exit 1
}

& CpXFProj7ZipMv.ps1 -InputFolder $InputFolder -ProjectType Android -MaxAge $MaxAge
