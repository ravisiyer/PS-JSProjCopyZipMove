# List Suite Documentation

This documentation has been provided by Gemini and has been reviewed and edited by me. 

**Date created:** 25 Mar 2026

## Summary

The `List` folder contains a suite of PowerShell scripts designed for highly efficient, customized directory traversal. Because standard cmdlets like `Get-ChildItem -Recurse` traverse the entire folder tree before filtering, they are extremely slow when operating on software development projects containing massive dependency folders like `node_modules` or `.git`. 

To solve this, these scripts implement a custom recursion engine that intercepts and prunes excluded folders *before* traversing into them, resulting in dramatically faster execution times. The scripts are primarily used to preview what will be copied by the `CopyWoXF` tools, or to quickly locate recently modified files within active workspaces.

---

## Script Categories

### 1. The Core Recursion Engine
**`ListItemWoXF.ps1`**
This is the foundational engine of the suite. It manually recursively lists items in a directory but accepts a list of folders to exclude. Crucially, it returns rich `[System.IO.FileInfo]` and `[System.IO.DirectoryInfo]` objects rather than simple strings, allowing downstream scripts to easily filter and sort by properties like `LastWriteTime`.

### 2. General Listing Wrappers
These scripts act as user-friendly wrappers around `ListItemWoXF.ps1`, formatting the object output into clean console logs (typically `[LastWriteTime] [FullName]`).

* **`ListWoXF.ps1`:** The standard wrapper. Lists all files and folders while respecting the default tech-stack exclusion lists.
* **`ListAll.ps1`:** A simple wrapper that forces the `ExcludeNone` flag, bypassing all exclusions to list absolutely everything in the target directory.

### 3. Time-Based Listing & Aggregation
* **`ListMaxAgeWoXF.ps1`:** Filters the recursive output to only show items modified within the last `MaxAge` days. It includes a powerful `UniqueParentFolder` (`upf`) flag that aggregates the results, showing only the parent directories of modified files rather than spamming the console with hundreds of individual files.
* **`ListLastModWoXF.ps1`:** Sorts the workspace and returns the top `N` (default 10) most recently modified files/folders. Extremely useful for quickly finding where you left off in a project. It includes an optional UTC flag for timestamp conversions.

### 4. Targeted Search Utility
**`FindFldrsWoXF.ps1`**
Unlike the other scripts, this implements its own distinct recursion engine optimized for *finding* specific heavy folders (like `node_modules` or `target`) rather than listing contents. Once it finds a matched folder, it reports it and *halts* recursing into it (saving massive amounts of time). It keeps a running tally of matches across the workspace.

### 5. Reference Material
**`RecurseListFilesDirs.ps1`**
The original, un-modified reference script adapted from a web article showing how to bypass `-Recurse`. Retained purely as a baseline reference for the custom recursion logic.

---

## Known Issues & Future Enhancements (Technical Debt Log)

When time permits, the following minor bugs and refactoring opportunities have been identified for future updates:

### Bug Fixes / Minor Corrections
* **Parameter Safety (Spaces in Paths):** In wrappers like `ListWoXF.ps1` and `ListMaxAgeWoXF.ps1`, the base script is invoked via a string command (e.g., `ListItemWoXF.ps1 $Path $ExcludeFolders`). Because `$Path` is not wrapped in quotes, passing a directory name with spaces (e.g., `C:\My Project`) will cause parsing errors.
* **Array Comparison Quirks:** In `ListItemWoXF.ps1` and `FindFldrsWoXF.ps1`, checks like `$ExcludeFoldersArray -Contains ($item)` rely on PowerShell implicitly casting a `DirectoryInfo` object to a string. It would be much safer and more explicit to use `-Contains $item.Name`.
* **Double Backslashes:** Path building uses string concatenation (`"$path\$itemname"`). If `$path` already ends with a backslash (like a drive root), it results in ugly double backslashes (`C:\\folder`). Using `Join-Path` is the standard fix.

### Refactoring Targets (DRY & Modernization)
* **Invoke-Expression Risk Awareness:** `Invoke-Expression` has some security risks. `Invoke-Expression` could be replaced with the call operator (`&`) but that makes it more complex to show exactly which command will be executed in a prompt and then execute that command.

* **Strong Parameter Typing:** Scripts manually validate things like numbers (using Regex for `MaxAge`) or use binary strings (`"y"` for UTC, `"upf"` for Unique). These should be updated to use idiomatic PowerShell types like `[int]$MaxAge` and `[switch]$UniqueParentFolder`.
* **Duplicate Formatting Logic:** The output string format (`"$($_.LastWriteTime) $($_.FullName)"`) is repeated across almost all wrapper scripts and could be centralized.
