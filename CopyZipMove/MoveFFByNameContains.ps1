# MoveFFByNameContains.ps1
#
# This script moves files and folders based on name patterns to a specified target folder.

<#
.SYNOPSIS
    Moves files and folders matching specified name patterns to a target folder.

.DESCRIPTION
    This script automates the process of organizing files and folders by moving
    them from a source path to a designated target folder based on partial name matches.
    It provides interactive prompts for confirmation before performing any actions,
    such as creating the target folder or moving items. A summary of all actions
    is displayed upon completion.

.PARAMETER Path
    Specifies the source directory to scan for files and folders.
    Defaults to the current directory.

.PARAMETER FFNamePatternsToMove
    A collection of strings representing parts of names of files or folders to move.
    Items that contain any of these patterns will be moved.
    Example: 'Others', 'ReactNative', 'DotNet'

.PARAMETER TargetFolder
    The name of the folder within the source Path where matching items will be moved.
    This folder will be created if it does not exist.
    Example: 'CurrProj'

.EXAMPLE
    .\MoveFFByNameContains.ps1 -Path "C:\Projects" -FFNamePatternsToMove @('Backend', 'Frontend') -TargetFolder "Sorted"
    Moves any files or folders containing 'Backend' or 'Frontend' from 'C:\Projects'
    to 'C:\Projects\Sorted', with confirmation prompts.

.EXAMPLE
    .\MoveFFByNameContains.ps1 -FFNamePatternsToMove @('Logs', 'Archives') -TargetFolder "Cleanup"
    Moves items with 'Logs' or 'Archives' in their name from the current directory
    to a folder named 'Cleanup' within the current directory.

.EXAMPLE
    .\MoveFFByNameContains.ps1 /?
    Displays detailed usage and parameter information for the script.
#>
param(
    [string]$Path = (Get-Location).Path,
    [string[]]$FFNamePatternsToMove,
    [string]$TargetFolder,
    [switch]$Usage
)

# Function to display usage information
function Show-Usage {
    Get-Help -Full $PSCommandPath
    exit
}

# Check for '/?' parameter to show usage
if ($Usage -or ($FFNamePatternsToMove -eq $null) -or ($TargetFolder -eq $null)) {
    if ($args[0] -eq '/?') {
        Show-Usage
    } else {
        Write-Warning "Missing required parameters: FFNamePatternsToMove and TargetFolder."
        Show-Usage
    }
}

# Log arrays for summary
$createdFolders = @()
$movedItems = @()

# Step 1: Pre-scan for all items to be moved before any action
Write-Host "Scanning for files and folders in '$Path'..." -ForegroundColor Cyan
$allFoundItems = @()
foreach ($pattern in $FFNamePatternsToMove) {
    $itemsToMove = Get-ChildItem -Path $Path -Force | Where-Object { $_.Name -like "*$pattern*" }
    $allFoundItems += $itemsToMove
}

# If no items are found, exit gracefully
if ($allFoundItems.Count -eq 0) {
    Write-Host "No files or folders found matching any of the specified patterns. Exiting." -ForegroundColor Yellow
    exit
}

# Construct the full path to the target folder
$targetPath = Join-Path -Path $Path -ChildPath $TargetFolder

# Step 2: Check and create the target folder if necessary
if (-not (Test-Path -Path $targetPath -PathType Container)) {
    Write-Host "Action: Target folder '$targetPath' does not exist." -ForegroundColor Yellow
    $prompt = "Do you want to create the folder '$targetPath'?"
    if ($host.UI.PromptForChoice($prompt, 'Create folder', @('&Yes', '&No'), 0) -eq 0) {
        New-Item -Path $targetPath -ItemType Directory | Out-Null
        $createdFolders += $targetPath
        Write-Host "Folder created: $targetPath" -ForegroundColor Green
    } else {
        Write-Host "Operation cancelled by user." -ForegroundColor Red
        exit
    }
}

# Step 3: Move the found items
foreach ($item in $allFoundItems) {
    $destination = Join-Path -Path $targetPath -ChildPath $item.Name
    
    # Check if the item already exists in the destination
    if (Test-Path -Path $destination) {
        Write-Warning "Skipping '$($item.Name)' as an item with the same name already exists in '$targetPath'."
        continue
    }

    Write-Host "Action: Moving '$($item.FullName)' to '$targetPath'." -ForegroundColor Yellow
    $prompt = "Do you want to move '$($item.Name)' to '$targetPath'?"
    if ($host.UI.PromptForChoice($prompt, 'Move item', @('&Yes', '&No'), 0) -eq 0) {
        Move-Item -Path $item.FullName -Destination $targetPath -Force -ErrorAction Stop
        $movedItems += $item.FullName
        Write-Host "Moved '$($item.Name)'." -ForegroundColor Green
    } else {
        Write-Host "Move of '$($item.Name)' cancelled by user." -ForegroundColor Red
    }
}

# ---
# Display summary of actions
# ---
Write-Host "---" -ForegroundColor White
Write-Host "## Summary of Actions" -ForegroundColor Cyan
Write-Host "---" -ForegroundColor White

Write-Host "Script finished." -ForegroundColor Cyan

# Step 4: Display summary of actions
if ($createdFolders.Count -gt 0) {
    Write-Host "The following folders were created:" -ForegroundColor Green
    $createdFolders
}

if ($movedItems.Count -gt 0) {
    Write-Host "The following items were moved:" -ForegroundColor Green
    $movedItems
}

if ($createdFolders.Count -eq 0 -and $movedItems.Count -eq 0) {
    Write-Host "No actions were performed." -ForegroundColor Yellow
}