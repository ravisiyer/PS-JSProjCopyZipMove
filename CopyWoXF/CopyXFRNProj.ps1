# Wrapper script to invoke CopyXFProj.ps1 for a ReactNative project

param (
    [string]$InputFolder = ""
)

if ("" -eq $InputFolder -or $InputFolder -eq "/?") {
    Write-Host "Copy all source files and folders of a React Native (web and mobile) project."`n
    Write-Host "Usage: $($myInvocation.InvocationName) -InputFolder <PathToReactNativeProject>"`n
    Write-Host CopyXFProj.ps1 is invoked to do the copy`n
    exit 1
}

& CopyXFProj.ps1 -InputFolder $InputFolder -ProjectType ReactNative
