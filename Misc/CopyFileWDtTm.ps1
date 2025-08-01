<#
.SYNOPSIS
    Copies a file to a new name with a timestamp suffix.

.DESCRIPTION
    This script takes a single mandatory parameter, which is the path to a file.
    It then creates a new filename by appending a timestamp in the format YYYYMMDD-HHMM
    before the original file extension. The script copies the original file to this
    new filename, preserving the file's original extension.

.PARAMETER FilePath
    The full path to the file to be copied. This parameter is mandatory.

.EXAMPLE
    .\Copy-WithTimestamp.ps1 -FilePath "C:\Users\User\Documents\report.docx"
    
    This will copy the file to a new file named like "C:\Users\User\Documents\report_v-20231027-1530.docx"
#>
param (
    [Parameter(Mandatory = $true)]
    [string]$FilePath
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
    Write-Error "Error: The destination file '$newFilePath' already exists. Aborting copy."
    exit 1
}

Write-Host "Copying '$FilePath' to '$newFilePath'..."

try {
    # Use Copy-Item to perform the file copy.
    # The -Force parameter is no longer needed since we are checking for existence.
    Copy-Item -Path $FilePath -Destination $newFilePath

    Write-Host "File copied successfully." -ForegroundColor Green
    Write-Host "New file location: $newFilePath"

} catch {
    # Catch any errors during the copy process and display a friendly message.
    Write-Error "An error occurred during file copy: $($_.Exception.Message)"
    exit 1
}
