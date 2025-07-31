# Wrapper script to invoke CopyXFProj.ps1 for an Android project

param (
    [string]$InputFolder = ""
)

if ("" -eq $InputFolder -or $InputFolder -eq "/?") {
    Write-Host "Copy all source files and folders of an Android project.`n"
    Write-Host "Usage: $($myInvocation.InvocationName) -InputFolder <PathToAndroidProject>`n"
    Write-Host "CopyXFProj.ps1 is invoked to do the copy.`n"
    exit 1
}

& CopyXFProj.ps1 -InputFolder $InputFolder -ProjectType Android
