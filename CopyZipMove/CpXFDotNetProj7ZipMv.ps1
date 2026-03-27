# Wrapper script to invoke CpXFProj7ZipMv.ps1 for a DotNet project

param (
    [string]$InputFolder = "",
    [string]$MaxAge = "-"
)

if ("" -eq $InputFolder -or $InputFolder -eq "/?") {
    Write-Host "Copy, zip, and move all source files and folders of a DotNet project."`n
    Write-Host "Usage: $($myInvocation.InvocationName) -InputFolder <PathToDotNetProject> [-MaxAge <string>]"`n
    Write-Host "CpXFProj7ZipMv.ps1 is invoked to do the operation"`n
    exit 1
}

& CpXFProj7ZipMv.ps1 -InputFolder $InputFolder -ProjectType DotNet -MaxAge $MaxAge
