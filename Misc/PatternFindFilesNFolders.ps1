# This script searches for files containing a specific string
# and sorts the results by the latest modification date.

param (
    [string]$SearchString = ""
)

# Function to display usage information for the script.
function Show-Usage {
    param ($cmdName)
    Write-Host "--------------------"
    Write-Host "Script Usage:"
    Write-Host "  $cmdName <string-to-search>"
    Write-Host " "
    Write-Host "Example:"
    Write-Host "  $cmdName 'Backup-Info'"
    Write-Host " "
    Write-Host "To show this help text, use: $cmdName /?"
    Write-Host "--------------------"
}

# Check if the user passed the '/?' parameter to show usage.
if ($SearchString -eq "/?") {
    Show-Usage $myInvocation.InvocationName
    exit 0
}

# Check if the search string is empty.
if ([string]::IsNullOrEmpty($SearchString)) {
    Write-Error "A search string parameter is required."
    Show-Usage $myInvocation.InvocationName
    exit 1
}

Write-Host "Searching for files containing '$SearchString'..."

# The core logic of the script:
# 1. Get-ChildItem with -Recurse finds all files in the current directory and subdirectories.
# 2. Where-Object filters the output to only include items where the FullName (the full path) contains the search string.
# 3. Sort-Object sorts the filtered files by their LastWriteTime property in descending order (latest first).
# 4. Format-Table displays the results in a clean table format.
try {
    Get-ChildItem -Recurse |
    Where-Object { $_.FullName -like "*$SearchString*" } |
    Sort-Object -Property LastWriteTime -Descending |
    Format-Table FullName, LastWriteTime, Length
}
catch {
    Write-Error "An error occurred while running the script: $_"
}

