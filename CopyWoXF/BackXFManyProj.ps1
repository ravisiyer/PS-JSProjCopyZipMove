param (
    [string]$InputFolder,
    [string]$OutputFolder,
    [string]$LogFile,
    [hashtable]$ProjectDirsAndTypes
)

function Show-Usage {
    Write-Host "Usage: `n`n`t$($myInvocation.InvocationName) -InputFolder <path> -OutputFolder <path> -ProjectDirsAndTypes <hashtable> 
    [-LogFile <path>]" -f Yellow
    Write-Host "-InputFolder <path>                : The source folder containing the projects. (Mandatory)"
    Write-Host "-OutputFolder <path>               : The destination folder for the backups. (Mandatory)"
    Write-Host "-ProjectDirsAndTypes <hashtable>   : A hashtable of directory names and their corresponding project types. (Mandatory)"
    Write-Host "-LogFile <path>                    : (Optional) The path to the log file."
    Write-Host "`nExamples:"
    Write-Host "`nExample 1: Basic usage with a single project type:"
    Write-Host "$($myInvocation.InvocationName) -InputFolder 'C:\Users\xyz-user\CurrProj' -OutputFolder 'E:\Back-XF-CurrProj' -ProjectDirsAndTypes @{'ReactNative'='ReactNative'}"
    Write-Host "`nExample 2: Usage with multiple project types:"
    Write-Host "$($myInvocation.InvocationName) -InputFolder 'C:\Users\xyz-user\CurrProj' -OutputFolder 'E:\Back-XF-CurrProj' -ProjectDirsAndTypes @{'ReactNative'='ReactNative'; 'DotNet'='DotNet'; 'MERN'='Others'}"
}

if (-not $InputFolder -or $InputFolder -eq "/?" -or -not $OutputFolder -or -not $ProjectDirsAndTypes) {
    Write-Host "Missing one or more mandatory parameters." -f Red
    Show-Usage
    exit
}

$CopyCmd = "CopyXFProj"

# Loop through each project directory and type from the provided hashtable
foreach ($ProjDir in $ProjectDirsAndTypes.GetEnumerator()) {
    $DirName = $ProjDir.Key
    $ProjectType = $ProjDir.Value
    
    $ProjTypeInputFolder = Join-Path -Path $InputFolder -ChildPath $DirName
    $ProjTypeOutputFolder = Join-Path -Path $OutputFolder -ChildPath $DirName
    
    If (Test-Path -Path $ProjTypeInputFolder -PathType Container) {
        # $Cmd = "$CopyCmd -InputFolder $ProjTypeInputFolder -ProjectType '$ProjectType' -OutputFolder $ProjTypeOutputFolder -LogFile $LogFile"
        $Cmd = "$CopyCmd -InputFolder $ProjTypeInputFolder -ProjectType '$ProjectType' -OutputFolder $ProjTypeOutputFolder"
        If ($LogFile) {
            $Cmd += " -LogFile $LogFile"
        }
        Write-Host "Invoking $Cmd"
        Invoke-Expression $Cmd
    }
}
