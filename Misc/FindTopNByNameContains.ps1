# This script is a wrapper for the FindByNameContains script, allowing you to
# easily limit the output to a specified number of lines.

param (
    [string]$Path = ".",
    [string]$SearchString = "",
    [int]$Count = 10 # If you change this, also update the usage text.
)

# Function to display usage information for the script.
function Show-Usage {
    param ($cmdName)
    Write-Host "--------------------"
    Write-Host "Script Usage:"
    Write-Host "  $cmdName -Path <path> -SearchString <string> [-Count <number>]"
    Write-Host " "
    Write-Host ("The script lists files and folders whose name contains given SearchString, " + 
    "in last modified order.")
    Write-Host "The list is limited to Count entries (default: 10)."
    Write-Host " "
    Write-Host "Example:"
    Write-Host "  $cmdName -Path 'C:\Users\MyName\Documents' -SearchString 'Backup-Info' -Count 5"
    Write-Host " "
    Write-Host "To show this help text, use: $cmdName /?"
    Write-Host "--------------------"
}

# Check if the user passed the '/?' parameter to show usage.
if ($null -eq $Path -or $Path -eq "/?") {
    Show-Usage $myInvocation.InvocationName
    exit 0
}

# Check if the search string is empty before running the command.
if ([string]::IsNullOrEmpty($SearchString)) {
    Write-Error "A search string parameter is required."
    Show-Usage $myInvocation.InvocationName
    exit 1
}

# Write-Host "Searching for the top $Count items whose name contains '$SearchString' in '$Path'..."

# The core command: It calls the FindByNameContains script, and uses
# Select-Object to efficiently stop the search after the required number of items
# have been found.
# The PowerShell pipeline is pull-based; Select-Object requests data and cancels
# the upstream command when its limit is reached.
$Cmd = "FindByNameContains -Path $Path -SearchString $SearchString | Select-Object -First $Count"
Write-Host "Executing command: $Cmd"
FindByNameContains -Path $Path -SearchString $SearchString | Select-Object -First $Count  

# Can't use: Invoke-Expression $Cmd
# as that, I am told, breaks the pipeline. 