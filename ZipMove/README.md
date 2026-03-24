# ZipMove Suite Documentation

This documentation has been provided by Gemini and has been reviewed and edited by me. 

**Date created:** 24 Mar 2026

## Summary

The `ZipMove` folder contains a collection of utility scripts designed to handle the packaging (zipping) and safe relocation (moving) of files and folders. These scripts seamlessly integrate auto-timestamping and chronological sub-folder organization into the backup workflow. 

The tools in `ZipMove` are mostly tech-stack agnostic and can be used for any general file system backup or archival needs. But they are heavily used for software development (tech-stack) projects backup as well by scripts in the CopyZipMove folder.

Note that backing up software development project folders to cloud storage like Google Drive can be very slow if many individual files and folders are being backed up, especially on 4G mobile Internet which is what I use. Even when excluding heavy folders like `node_modules` (using `CopyWoXF`), a handful of MERN stack or React Native projects can easily contain hundreds of source files. This is largely due to `.git` tracking folders, which consist of many very small files. Because cloud services like Google Drive incur significant per-file upload overhead, uploading 5 consolidated zip files is drastically faster than uploading 200+ individual files. Therefore, these zip utility scripts are highly helpful for an efficient Google Drive backup workflow.

---

## Script Categories

### 1. Zipping Utilities
**`ZipFldrWDtTm.ps1`**
The core zipping engine. It compresses a directory while dynamically prefixing the output `.zip` file with a `yyyyMMdd-HHmm-` timestamp to prevent accidental overwrites of previous backups. It supports both the native `Compress-Archive` and `7z` (the latter being essential for including hidden folders and files like `.git`).

**`ZipMv.ps1`**
A dual-purpose script that acts as the primary backup tool. It combines the timestamped zipping logic of `ZipFldrWDtTm.ps1` and immediately moves the resulting archive to a designated backup destination. It also supports automatically routing the backup into a dynamically created `yyyyMMdd` sub-folder.

**`7zipMv.ps1`**
A convenience wrapper around `ZipMv.ps1`. It hardcodes the `Use7zip` and `UseTodaySubFolder` parameters to "Y", saving keystrokes for the most common workflow: backing up Git-tracked source code into an organized daily backup structure.

### 2. Moving & Relocation Utilities
**`MoveToBack.ps1`**
A dedicated utility for safely relocating an existing file or folder to the backup directory. It cleanly incorporates the daily organization strategy by optionally routing the item into a `yyyyMMdd` timestamped sub-folder (creating the folder automatically if it does not exist). It importantly uses the `-Force` flag to prevent failures when moving hidden/read-only items like Git directories.

**`MoveToMDLWDtTm.ps1`**
A custom, scriptable alternative to the Windows Recycle Bin. It stages a file or folder for future manual deletion by moving it to a `MayDeleteLater` (MDL) folder. To prevent naming collisions, it prepends the current timestamp to the item's name before moving it. For performance, it dynamically resolves the current drive and moves the item to the MDL folder *on that exact same drive*, ensuring the OS simply updates the file index rather than executing a lengthy cross-drive data transfer.

### 3. Source Control Utilities
**`GitModFilesZip.ps1`**
A specialized Git utility that bridges `git ls-files` and 7-Zip. It quickly packages up all tracked, uncommitted, modified files into a single `modified-files.zip` archive. This is highly useful for sharing a "patch" or a work-in-progress state without making commits.

---

## Design Choices & Safeguards

* **The MDL "Opt-In" Mechanism (`MoveToMDLWDtTm.ps1`):** 
  Unlike the backup scripts that automatically create missing destination folders, the `MoveToMDLWDtTm.ps1` script explicitly requires the `MayDeleteLater` folder to already exist at the root of the drive. This is an intentional safeguard. It forces the user to manually "prepare" a drive for this script, preventing accidental littering of temporary folders on drives that the user has not 'prepared' for this script.

---

## Known Issues & Future Enhancements (Technical Debt Log)

When time permits, the following minor bugs and refactoring opportunities have been identified for future updates:

### Bug Fixes / Minor Corrections
* **`ZipFldrWDtTm.ps1` File vs. Folder Logic:** The script's `Usage` help text claims it can "Zip folder or file". However, the internal validation uses `-PathType Container`, which explicitly rejects individual files and aborts. This needs to be reconciled.
* **`ZipFldrWDtTm.ps1` Missing `/?` Check:** Unlike `ZipMv.ps1`, this script is missing the block to intercept `/?`. Passing `/?` currently throws a path-parsing error instead of gracefully displaying the help menu.
* **`GitModFilesZip.ps1` Omits Newly Added Files and Hardcoded Overwrites:** The script omits newly added files. Also, it currently outputs to `modified-files.zip` statically, which will overwrite previous runs. Adding timestamp logic (e.g., `20260324-1130-modified-files.zip`) would make it safer. The script hardcodes the `C:\Program Files\7-Zip\7z.exe` path, which could be simplified to just `7z` if it's already in the system PATH.

### Refactoring Targets (DRY & Modernization)
* **Consolidate Zipping Logic:** `ZipMv.ps1` and `ZipFldrWDtTm.ps1` contain nearly identical code for their first halves. `ZipMv.ps1` should be refactored to simply invoke `ZipFldrWDtTm.ps1` and then execute the move.
* **Parameter Modernization:** Switch from string-based binary flags (`"Y"`/`"N"`) to idiomatic PowerShell `[switch]` parameters.
* **Path Parsing:** Replace manual string manipulation (like `.substring()` and `.length`) with built-in PowerShell path cmdlets (`Split-Path`, `.TrimEnd()`, `Resolve-Path`).
* **Invoke-Expression Risk Awareness:** `Invoke-Expression` has some security risks. `Invoke-Expression` could be replaced with the call operator (`&`) but that makes it more complex to show exactly which command will be executed in a prompt and then execute that command.
* **Special Characters In Folder Names:** Currently, if an `$InputFolder` contains a single quote (`'`) in its name, string concatenation will break and cause an exception during execution.
* **Reusable Confirmations:** The repeated `$host.UI.PromptForChoice` blocks across almost all scripts should be moved into a reusable helper function (e.g., `Confirm-Action`).
