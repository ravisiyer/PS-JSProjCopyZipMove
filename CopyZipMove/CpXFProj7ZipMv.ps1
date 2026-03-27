param (
    [string]$InputFolder = "",
    [string]$ProjectType = "",
    [string]$MaxAge = "-"
)

# During deployment to user's cmds directory, ProjectTypeExcludes.ps1 will be in same directory as this script.
# During development, it will be in the parent directory.
if (Test-Path -Path "$PSScriptRoot\ProjectTypeExcludes.ps1") {
    . "$PSScriptRoot\ProjectTypeExcludes.ps1"
} else {
    . "$PSScriptRoot\..\ProjectTypeExcludes.ps1"
}

if (-not $ProjectType) {
    $ProjectType = $DefaultProjectType
}

$ExcludeNoneFlag="ExcludeNone"
$ExcludeDirsFlag="ExcludeDirs:"

function Show-Usage {
    param ($cmdName)
    Write-Host "This script acts as a single-folder wrapper around PrMaxAgeMFCpXF7ZipMv.ps1."
    Write-Host "It orchestrates the backup of a single project folder using its specific project type exclusions."`n
    Write-Host "Usage: `n`n`t$cmdName -InputFolder <path> [-ProjectType <string>] [-MaxAge <string>]" -f Yellow
    Write-Host "-InputFolder <path>   : The full path to the specific project folder. (Mandatory)"
    Write-Host ("-ProjectType <string> : Project type. Valid types: {0}. Default: {1}" -f ($validTypes -join ", "), $DefaultProjectType)
    Write-Host "                        Special values like $ExcludeNoneFlag or '$ExcludeDirsFlag ...' are also supported."
    Write-Host "-MaxAge <string>      : Optional. Positive integer for days, or '-' to ignore MaxAge. Default: '-'"
}

if ($InputFolder -eq "/?" -or $InputFolder -eq "") {
    Show-Usage $myInvocation.InvocationName
    exit 1
}

If (-not (Test-Path -Path $InputFolder -PathType Container)) {
    If (Test-Path -Path $InputFolder) {
        Write-Host "InputFolder parameter specified: '$InputFolder' is not a directory. Aborting!" -ForegroundColor Red
    } Else {
        Write-Host "InputFolder parameter specified: '$InputFolder' does not exist. Aborting!" -ForegroundColor Red
    }
    Show-Usage $myInvocation.InvocationName
    exit 1
}

# Validate ProjectType
if ($ProjectType -ne $ExcludeNoneFlag -and $ProjectType -notlike "$ExcludeDirsFlag*" -and $ProjectType -notin $validTypes) {
    Write-Host "Invalid ProjectType specified: '$ProjectType'" -ForegroundColor Red
    Show-Usage $myInvocation.InvocationName
    exit 1
}

# Resolve full path to handle relative paths like "." safely
$ResolvedInputFolder = (Resolve-Path -Path $InputFolder).ProviderPath
$ParentPath = Split-Path -Path $ResolvedInputFolder -Parent
$FolderName = Split-Path -Path $ResolvedInputFolder -Leaf

Write-Host "Delegating to PrMaxAgeMFCpXF7ZipMv.ps1 for single folder '$FolderName' of type '$ProjectType' with MaxAge '$MaxAge'..."

# Pass the parent path to the multi-folder orchestrator and map the leaf folder name to its project type
PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder $ParentPath -ProjectDirsAndTypes @{ $FolderName = $ProjectType } -MaxAge $MaxAge
