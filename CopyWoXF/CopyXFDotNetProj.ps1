# Wrapper script to invoke CopyXFProj.ps1 for a DotNet project

param (
    [string]$InputFolder = ""
)

if ("" -eq $InputFolder -or $InputFolder -eq "/?") {
    Write-Host "Copy all source files and folders of a DotNet project.`n"
    Write-Host "Usage: $($myInvocation.InvocationName) -InputFolder <PathToDotNetProject>`n"
    Write-Host "CopyXFProj.ps1 is invoked to do the copy.`n"
    exit 1
}

& CopyXFProj.ps1 -InputFolder $InputFolder -ProjectType DotNet
