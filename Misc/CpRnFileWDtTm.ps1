<#
.SYNOPSIS
    Copies or renames a file to a new name with a timestamp suffix.

.DESCRIPTION
    This script takes a single mandatory parameter, which is the path to a file.
    It then creates a new filename by appending a timestamp in the format YYYYMMDD-HHMM
    before the original file extension. By default, the script copies the original file to this
    new filename, preserving the file's original extension. If the -Rename switch is provided,
    it renames the file instead.

.PARAMETER FilePath
    The full path to the file to be copied or renamed. This parameter is mandatory.

.PARAMETER Rename
    A switch parameter. If specified, the file will be renamed instead of copied.

.EXAMPLE
    .\CpRnFileWDtTm.ps1 -FilePath "C:\Users\User\Documents\report.docx"
    
    This will copy the file to a new file named like "C:\Users\User\Documents\report_v-20231027-1530.docx"

.EXAMPLE
    .\CpRnFileWDtTm.ps1 -FilePath "C:\Users\User\Documents\report.docx" -Rename
    
    This will rename the file to a new file named like "C:\Users\User\Documents\report_v-20231027-1530.docx"
#>
param (
    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [switch]$Rename
)

# --- 1. Validate Input and Prepare Paths ---

# Use Test-Path to check if the file exists. If not, exit with an error.
if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
    Write-Error "Error: The specified file '$FilePath' does not exist."
    exit 1
}

# Get the directory, base name, and extension of the original file.
# Using Split-Path and Get-Item is a robust way to handle paths.
$fileInfo = Get-Item -Path $FilePath
$directory = $fileInfo.DirectoryName
$fileNameWithoutExtension = $fileInfo.BaseName
$fileExtension = $fileInfo.Extension

# --- 2. Generate the New Filename with Timestamp ---

# Get the current date and time.
$currentDateTime = Get-Date

# Format the date and time as a string: YYYYMMDD-HHMM
# 'yyyy' = 4-digit year, 'MM' = 2-digit month, 'dd' = 2-digit day
# 'HH' = 24-hour hour, 'mm' = 2-digit minute
$timestamp = $currentDateTime.ToString("yyyyMMdd-HHmm")

# Construct the new filename with the timestamp suffix.
# Use Join-Path to ensure correct path separators are used.
$newFileName = "$($fileNameWithoutExtension)-v$timestamp$fileExtension"
$newFilePath = Join-Path -Path $directory -ChildPath $newFileName

# --- 3. Check for existing file and perform the copy ---

# Check if a file with the new name already exists.
if (Test-Path -Path $newFilePath -PathType Leaf) {
    $action = if ($Rename) { "rename" } else { "copy" }
    Write-Error "Error: The destination file '$newFilePath' already exists. Aborting $action."
    exit 1
}

if ($Rename) {
    Write-Host "Renaming '$FilePath' to '$newFilePath'..."
} else {
    Write-Host "Copying '$FilePath' to '$newFilePath'..."
}

try {
    if ($Rename) {
        # Use Rename-Item to perform the file rename.
        Rename-Item -Path $FilePath -NewName $newFileName
        Write-Host "File renamed successfully." -ForegroundColor Green
    } else {
        # Use Copy-Item to perform the file copy.
        # The -Force parameter is no longer needed since we are checking for existence.
        Copy-Item -Path $FilePath -Destination $newFilePath
        Write-Host "File copied successfully." -ForegroundColor Green
    }

    Write-Host "New file location: $newFilePath"

} catch {
    # Catch any errors during the copy or rename process and display a friendly message.
    $action = if ($Rename) { "rename" } else { "copy" }
    Write-Error "An error occurred during file ${action}: $($_.Exception.Message)"
    exit 1
}
