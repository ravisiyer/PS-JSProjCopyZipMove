param (
    [string]$InputFolder,
    [hashtable]$ProjectDirsAndTypes
)

# During deployment to user's cmds directory, ProjectTypeExcludes.ps1 will be in same directory as this script.
# During development, it will be in the parent directory.
if (Test-Path -Path "$PSScriptRoot\ProjectTypeExcludes.ps1") {
    . "$PSScriptRoot\ProjectTypeExcludes.ps1"
} else {
    . "$PSScriptRoot\..\ProjectTypeExcludes.ps1"
}

$ExcludeNoneFlag="ExcludeNone"
$ExcludeDirsFlag="ExcludeDirs:"

function Show-Usage {
    param ($cmdName)
    Write-Host This script is a wrapper around CpXFZipMv script tailored for backup copy with MaxAge using 7zip.
    Write-Host User is prompted for MaxAge. Multiple folders can be copied, each with exclude folders based on its project type.`n
    Write-Host "Usage: `n`n`t$cmdName -InputFolder <path> -ProjectDirsAndTypes <hashtable>" -f Yellow
    Write-Host "-InputFolder <path>                : The source folder containing the projects. (Mandatory)"
    Write-Host "-ProjectDirsAndTypes <hashtable>   : A hashtable of directory names and their corresponding project types. (Mandatory)"
    Write-Host "Special value of $ExcludeNoneFlag can be passed as ProjectType to not use exclude option at all [include all in copy]"
    Write-Host "Special value of $ExcludeDirsFlag can be passed as ProjectType to exclude specified directories which are provided in the project type itself, after the colon in the flag."
    Write-Host "`nExamples:"
    Write-Host "`nExample 1: Basic usage with a single project type:"
    Write-Host "$cmdName -InputFolder 'C:\Users\xyz-user\CurrProj' -ProjectDirsAndTypes @{'ReactNative'='ReactNative'}"
    Write-Host "`nExample 2: Usage with $ExcludeNoneFlag :"
    Write-Host "$cmdName -InputFolder 'C:\Users\xyz-user' -ProjectDirsAndTypes @{'ReqData'='$ExcludeNoneFlag'}"
    Write-Host "`nExample 3: Usage with $ExcludeDirsFlag :"
    Write-Host "$cmdName -InputFolder 'C:\Users\xyz-user' -ProjectDirsAndTypes @{'Back-Info'='$ExcludeDirsFlag Logs Temp'}"
    Write-Host "`nExample 4: Usage with multiple project types:"
    Write-Host "$cmdName -InputFolder 'C:\Users\xyz-user\CurrProj' -ProjectDirsAndTypes @{'ReactNative'='ReactNative'; 'DotNet'='DotNet'; 'MERN'='Others'}"
    Write-Host "`nExample 5: Usage with $ExcludeDirsFlag and . as InputFolder :"
    Write-Host "[Needs to be run from the directory containing the project Back-Info]"
    Write-Host "$cmdName -InputFolder . -ProjectDirsAndTypes @{'Back-Info'='$ExcludeDirsFlag Logs Temp'}"
}

if (-not $InputFolder -or $InputFolder -eq "/?" -or -not $ProjectDirsAndTypes) {
    Write-Host "Missing one or more mandatory parameters." -f Red
    Show-Usage $myInvocation.InvocationName
    exit
}

Write-Host "In dir: $pwd"
$MaxAge = Read-Host -Prompt "Please specify MaxAge [1]"
if ([string]::IsNullOrWhiteSpace($MaxAge)) {
	$MaxAge = 1
}

# Loop through each project directory and type from the provided hashtable
foreach ($ProjDir in $ProjectDirsAndTypes.GetEnumerator()) {
    $DirName = $ProjDir.Key
    $ProjectType = $ProjDir.Value
    $ProjTypeInputFolder = Join-Path -Path $InputFolder -ChildPath $DirName

    # Validate ProjectType
    if ($ProjectType -eq $ExcludeNoneFlag) {
        $ExcludeFolders = $ProjectType
    } elseif ($ProjectType -like "$ExcludeDirsFlag*") {
        $ExcludeFolders = $ProjectType.Replace($ExcludeDirsFlag, "").Trim()
    } elseif ($ProjectType -notin $validTypes) {
        Write-Host "Invalid ProjectType specified: '$ProjectType' for Directory '$DirName'"
        Write-Host "Skipping this directory."
        continue
    } else {
        $ExcludeFolders = $ProjectTypeExcludes[$ProjectType]
    }

    If (Test-Path -Path $ProjTypeInputFolder -PathType Container) {
        Write-Host "CpXFZipMv '$ProjTypeInputFolder' $MaxAge Y Y '$ExcludeFolders'"
        $Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&yes", "&no")
        $Choice = $host.UI.PromptForChoice("", "Proceed?", $Choices, 1)
        if (1 -eq $Choice)
        {
            Write-Host "Skipping this directory."
            continue
        }
        CpXFZipMv $ProjTypeInputFolder $MaxAge Y Y "$ExcludeFolders"
    }
}
