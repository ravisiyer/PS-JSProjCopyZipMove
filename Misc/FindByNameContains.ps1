# This script searches for files and folders whose name contains a specific string
# and sorts the results by the latest modification date.

param (
    [string]$Path = ".",
    [string]$SearchString = ""
)

# Function to display usage information for the script.
function Show-Usage {
    param ($cmdName)
    Write-Host "--------------------"
    Write-Host "Script Usage:"
    Write-Host "  $cmdName -Path <path-to-search> -SearchString <string-to-search>"
    Write-Host " "
    Write-Host ("The script lists files and folders whose name contains given SearchString, " + 
    "in last modified order.")
    Write-Host " "
    Write-Host "Example:"
    Write-Host "  $cmdName -Path 'C:\Users\MyName\Documents' -SearchString 'Backup-Info'"
    Write-Host " "
    Write-Host "To show this help text, use: $cmdName /?"
    Write-Host "--------------------"
}

# Check if the user passed the '/?' parameter to show usage.
if ($null -eq $Path -or $Path -eq "/?") {
    Show-Usage $myInvocation.InvocationName
    exit 0
}

# Check if the search string is empty.
if ([string]::IsNullOrEmpty($SearchString)) {
    Write-Error "A search string parameter is required."
    Show-Usage $myInvocation.InvocationName
    exit 1
}

# --- Path Validation ---
# We'll check if the path exists before attempting to get items from it.
if (-not (Test-Path $Path)) {
    Write-Error "The specified path does not exist: $Path"
    exit 1
}

# Normalize the path for consistent display and calculations
$normalizedPath = (Get-Item $Path).FullName

Write-Host "Searching for items (files or folders) whose name contains '$SearchString' in path '$normalizedPath'..."

# The core logic of the script:
# 1. Get-ChildItem with -Recurse finds all files and folders in the specified path and subdirectories.
# 2. Where-Object filters the output to only include items where the Name (the file or folder name) contains the search string.
# 3. Sort-Object sorts the filtered items by their LastWriteTime property in descending order (latest first).
# 4. Select-Object creates a custom object with the desired properties. This allows the output to be piped to other commands.
try {
    # We create a new calculated property called 'RelativePath'
    # The Expression removes the base path from the FullName to give us the relative path
    $basePath = (Get-Item $Path).FullName
    $basePathWithSeparator = $basePath
    if ($basePathWithSeparator[-1] -ne '\') {
        $basePathWithSeparator += '\'
    }

    Get-ChildItem -Path $Path -Recurse |
    Where-Object { $_.Name -like "*$SearchString*" } |
    Sort-Object -Property LastWriteTime -Descending |
    Select-Object @{
        Name='RelativePath'
        Expression={
            if ($null -eq $_.FullName -or $_.FullName -eq $basePath) {
                # Handle the case where the starting path itself matches
                "."
            } else {
                # Get the part of the string after the base path and trailing backslash
                $_.FullName.Replace($basePathWithSeparator, '')
            }
        }
    }, LastWriteTime, Length, @{
        Name='DaysSinceLastWrite'
        Expression={(New-TimeSpan -Start $_.LastWriteTime -End (Get-Date)).Days}
    }
}
catch {
    Write-Error "An error occurred while running the script: $_"
}
