# Misc Suite Documentation

This documentation has been provided by Gemini and has been reviewed and edited by me. 

**Date created:** 25 Mar 2026

## Summary

The `Misc` folder contains a collection of utility scripts that support the broader backup, development, and system management workflows. Rather than fitting strictly into the "Copy" or "Zip" categories, these tools provide highly targeted functionalities—such as searching for files by name, creating standardized daily backup folders, creating quick timestamped file versions, and acting as a quick-reference index for the entire repository.

---

## Script Categories

### 1. Search & Discovery Utilities
**`FindByNameContains.ps1`**
A targeted search utility that finds files or folders matching a specific naming pattern (e.g., "Backup-Info") and sorts them chronologically by `LastWriteTime`. Crucially, it outputs a highly readable custom object containing a calculated `RelativePath` and a `DaysSinceLastWrite` property, making the output perfect for console viewing.

**`FindTopNByNameContains.ps1`**
A highly efficient, pull-based wrapper around `FindByNameContains.ps1`. It uses `Select-Object -First N` to truncate the search results. Because PowerShell pipelines are pull-based, this efficiently halts the upstream search as soon as the target count is met.

**`PSScriptsListLastMod.ps1`**
A specialized tool for managing this repository. It recursively searches for `.ps1` files and lists the top `N` most recently modified scripts. This is incredibly useful for quickly picking up development work exactly where you left off.

### 2. Backup & File Management Utilities
**`MakeFolderTodayName.ps1`**
A daily workflow automation script. It creates a new directory named with the current date (`yyyyMMdd`) in a specified destination folder (defaulting to a backup drive). This is often used as a prerequisite step for bulk moving files into a daily backup archive.

**`CopyFileWDtTm.ps1`**
A robust, idiomatic PowerShell script that creates a quick, versioned backup of an individual file. It grabs the target file and safely copies it, appending a timestamp (e.g., `YYYYMMDD-HHMM`) right before the file extension. 

### 3. Repository Index
**`MyPSScripts.ps1`**
An interactive "cheat sheet" or table of contents. When executed, it prints a categorized list of all active scripts in the repository along with a brief description of what they do.

---

## Known Issues & Future Enhancements (Technical Debt Log)

When time permits, the following minor bugs and refactoring opportunities have been identified for future updates:

### Bug Fixes / Minor Corrections
* **`CopyFileWDtTm.ps1` Documentation:** In the comment-based help block at the top of the script, the `.EXAMPLE` section refers to the script incorrectly as `.\Copy-WithTimestamp.ps1`.
* **String `.Replace()` Bug Risk (`FindByNameContains.ps1`):** When calculating the relative path, the script uses `$_.FullName.Replace($basePath, '')`. If the base path string coincidentally appears deeper inside the folder structure, `.Replace()` will corrupt the output string. A safer approach is `.Substring($basePath.Length)`.

### Refactoring Targets (DRY & Modernization)
* **Pipeline Consumption vs. `Write-Host` (`PSScriptsListLastMod.ps1`):** The script formats its final output using `Write-Host`, which prints beautifully to the console but destroys the PowerShell objects. Refactoring to use native output or `Select-Object` would allow the output to be piped to other commands.
* **Performance Optimization (`FindByNameContains.ps1`):** The script currently retrieves all files recursively and then filters them in memory via `Where-Object { $_.Name -like "*Search*" }`. In massive directories, this is slow. Utilizing the provider-level `-Filter` parameter on `Get-ChildItem` would push the search to the file system level and vastly improve performance.
* **Pipeline Safety Awareness (`FindTopNByNameContains.ps1`):** Unlike other scripts in the repository that use `Invoke-Expression` to print and run a command string, this script correctly avoids it. Using `Invoke-Expression` inside a pipeline destroys rich object integrity and breaks pull-based efficiency.
* **Path Concatenation (`MakeFolderTodayName.ps1`):** The script manually builds the path via string concatenation (`$DestinationFolder + "\" + $TodaysDate`). Using `Join-Path` is a safer, more standard approach to avoid double backslashes.
* **Strong Parameter Typing:** Across several scripts, strongly typing parameters in the `param` block (e.g., `[int]$Count`, `[int]$TopFewCount`) would add a layer of automatic validation.
* **Dynamic Discovery (`MyPSScripts.ps1`):** The repository index is currently hardcoded and requires manual maintenance whenever a script is added or removed. A future iteration could dynamically discover and parse script summaries from the `cmds` directory.
* **Invoke-Expression Risk Awareness:** `Invoke-Expression` has some security risks. `Invoke-Expression` could be replaced with the call operator (`&`) but that makes it more complex to show exactly which command will be executed in a prompt and then execute that command.
