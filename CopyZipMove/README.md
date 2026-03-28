# CopyZipMove Suite Documentation

This documentation has been provided by Gemini and has been reviewed and edited by me. 

**Date created:** 24 Mar 2026

## Summary

The `CopyZipMove` folder contains the high-level "orchestrator" and "combo" scripts of the project. Rather than performing low-level file operations directly, these scripts intelligently chain together the specialized utilities from the `CopyWoXF` and `ZipMove` folders to form complete, automated backup-and-cleanup pipelines.

These scripts are primarily designed to handle the complex workflow of safely backing up software development projects as few zip files. Note that zip files are particularly useful for backup to cloud storage. The scripts automate the tedious process of staging the files, stripping out heavy/regeneratable dependencies, compressing the results (which, in case of backup to cloud storage, minimizes network API overhead), and safely cleaning up the staging area.

---

## Script Categories

### 1. The Core Orchestrator
**`CpXFZipMv.ps1`**
This is the central pipeline engine. It executes a strict 5-step process for a single input folder:
1. **Prepare & Copy:** Creates a timestamped temporary folder and uses `CopyWoXF.ps1` to copy files into it (applying exclusions and/or MaxAge).
2. **Validate:** Checks if files were actually copied (gracefully exiting if a MaxAge filter resulted in 0 files).
3. **Package:** Uses `ZipFldrWDtTm.ps1` to compress the temporary folder.
4. **Archive:** Prompts the user, then uses `MoveToBack.ps1` to move the final `.zip` file to the backup destination.
5. **Cleanup:** Prompts the user (allowing polite skipping), then uses `MoveToMDLWDtTm.ps1` to safely move the intermediate temporary folder to the `MayDeleteLater` directory.

### 2. Pipeline Wrappers & Batch Managers
**`CpZipMv.ps1`**
A simple wrapper around `CpXFZipMv.ps1` that acts as the "Full 1:1 Backup" command. It hardcodes the `ExcludeFolders` parameter to `ExcludeNone`, bypassing all tech-stack filters to copy and zip absolutely everything in the source directory.

**`PrMaxAgeMFCpXF7ZipMv.ps1`**
The advanced batch-processing manager. It allows you to configure a single run that backs up multiple disparate projects in sequence.
* Uses a hashtable to map specific sub-folders to their respective project types (e.g., `@{'ReactNativeApp'='ReactNative'; 'BackendAPI'='DotNet'}`).
* Dynamically sources `ProjectTypeExcludes.ps1` to apply the correct exclusion filters for each specific project.
* Prompts for a single `MaxAge` value to apply across all projects (allows specifying a number of days for an incremental backup, or `-` for a full backup).
* Hardcodes `7z` to guarantee hidden `.git` folders are included.
* Provides interactive prompts allowing you to selectively skip individual projects during the batch run.

**`CpXFProj7ZipMv.ps1`**
A smart single-folder orchestrator. It accepts the path to a specific project folder and its project type, resolves the paths safely, and delegates the backup operation to `PrMaxAgeMFCpXF7ZipMv.ps1`.

**Stack-Specific Wrappers (`CpXFRNProj7ZipMv.ps1`, `CpXFAndroidProj7ZipMv.ps1`, `CpXFDotNetProj7ZipMv.ps1`)**
Minimal, ergonomic wrappers for `CpXFProj7ZipMv.ps1`. They allow you to trigger a properly filtered backup for a specific tech stack without needing to remember or type the `ProjectType` string.

### 3. Post-Backup Organization
**`MoveByNameContains.ps1`**
A highly interactive, pattern-based sorting tool. It is used to sweep through a staging area (like a daily backup folder) and neatly categorize the generated `.zip` files into specific target folders based on partial name matches (e.g., matching `-XF` or `ReactNative`). It wraps matched patterns in wildcards implicitly and prompts for confirmation before creating folders or moving files.

---

## Known Issues & Future Enhancements

### The `MoveByNameContains.ps1` Parameter Bug
* **Issue:** Not specifying the `TargetFolder` parameter does not result in the expected error message. Because PowerShell defaults unpassed `[string]` parameters to an empty string `""` instead of `$null`, the current validation check `($null -eq $TargetFolder)` evaluates to False and the script fails silently later on.
* **Proposed Fix:** A new file named `MoveByNameContains-BugFixAttempt.ps1` has been created containing the fix (replacing the check with `[string]::IsNullOrWhiteSpace($TargetFolder)`). 
* **Status:** Due to the infrequent use of this script, the investment of time to test the bug fix and integrate it into the main script has been postponed until a later, more suitable time.

### Refactoring Targets
* **Path Reconstruction in `CpXFZipMv.ps1`:** The script currently uses manual string concatenation with hardcoded backslashes (`\`) to build the `$OutputFolder` path. When technical debt is addressed, this should be modernized by using the `Join-Path` cmdlet to ensure cross-platform compatibility and better handling of trailing slashes.
* **Duplicate Code Consolidation:** Just like the rest of the repository, shared logic (like the `$host.UI.PromptForChoice` blocks) can eventually be extracted into reusable helper functions to make these top-level scripts even leaner.
