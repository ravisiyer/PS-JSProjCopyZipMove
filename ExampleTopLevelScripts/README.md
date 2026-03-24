# ExampleTopLevelScripts Documentation

This documentation has been provided by Gemini and has been reviewed and edited by me.

**Date created:** 24 Mar 2026

## Summary

The `ExampleTopLevelScripts` folder contains user-friendly, right-click-and-run operational scripts. These scripts act as the capstones of the entire repository. They do not contain complex logic themselves; instead, they serve as highly configurable templates that string together the modular tools from `CopyWoXF`, `ZipMove`, and `CopyZipMove` into seamless, end-to-end tasks.

These scripts are designed to be run directly (e.g., Right-Click -> "Run with PowerShell"). They explicitly declare input/output variables at the top and end with a `pause` command so the user can review execution logs and Robocopy output before the console window closes.

---

## Architectural Background & Rationale

The design of these multi-folder batch scripts is based on top-level project folders being organized by tech-stack. The rationale for this project folder organization is covered in my blog post: [Handling varying exclude folders for source code backup of MERN, React Native, Android and DotNet tech stacks](https://raviswdev.blogspot.com/2025/08/handling-varying-exclude-folders-for.html). As detailed in the blog post, the Windows `robocopy /XD` (exclude directories) switch operates on *directory names globally*, not on relative paths or patterns. This limitation has heavily influenced my choice of tech-stack-wise organization of project folders.

This means an exclusion rule intended to skip a `build` folder (which has generated artifacts in an Android project) would accidentally exclude essential `build` folders in other tech stacks if all projects were mixed together in a single top-level directory.

**The Solution:** By physically organizing the workspace into top-level tech-stack sub-folders (e.g., `CurrProj\Android`, `CurrProj\DotNet`, `CurrProj\Others`), these scripts can leverage the robust, battle-tested `robocopy` engine with complete safety. The hashtable mappings in these scripts (`-ProjectDirsAndTypes`) directly reflect this physical organization, ensuring that the correct, stack-specific exclusion rules are only ever applied to the matching directory tree.

---

## Script Categories

### 1. Multi-Folder Batch Operations
These scripts demonstrate how to back up an entire workspace containing multiple disparate projects organized under top-level tech-stack sub-folders, in a single run. They utilize a hashtable (`-ProjectDirsAndTypes`) to map specific physical tech-stack top-level sub-folders to their appropriate tech-stack exclusion profiles (e.g., `@{'Common'='Others'; 'DotNet'='DotNet'}`).

**`Back-XF-ManyFolders.ps1`**
A clean, straightforward template for executing a batch multi-project backup. It simply maps the folders to their types and fires off the underlying `BackXFManyProj.ps1` script without time-based filtering (MaxAge).

**`Back-XF-PrMaxAge-ManyFolders.ps1`**
The ultimate end-to-end automation of the daily backup workflow. It executes a complete 3-phase pipeline:
1. **Reconnaissance:** It uses `FindByNameContains` to instantly query and display the 10 most recent backups. This gives the user the exact context needed to accurately answer the upcoming `MaxAge` prompt. E.g.: `FindByNameContains` may report that the last backup was 3 days ago. Note that MaxAge should be 1 more than last backup age as that age truncates part of a day. So in previous example case, 3 days age may mean 3 days 14 hours age (86 hours). So MaxAge should be specified as 4 to pick up all files modified not only in last 3 days (72 hours) but in last 4 days (96 hours). This has the disadvantage of picking up some files last updated between 86 and 96 hours, which are not needed. However, robocopy MaxAge parameter only allows days specification and not hours.
2. **Execution:** It runs the batch manager (`PrMaxAgeMFCpXF7ZipMv.ps1`) to stage, filter, zip, and archive all mapped projects.
3. **Cleanup/Sorting:** It validates the day's backup folder and automatically invokes `MoveByNameContains` to sweep up the newly generated `*-XF.zip` files and group them neatly in their final destination.

### 2. Single-Folder Custom Operations ("Escape Hatches")
These scripts demonstrate how to use the massive power of the multi-folder combo orchestrator for highly specific, single-folder tasks by utilizing built-in "escape hatches."

**`Back-XF-PrMaxAge-OneFolder-ExclNone.ps1`**
Demonstrates the `ExcludeNone` escape hatch. By passing `@{'FolderName'='ExcludeNone'}`, it entirely bypasses the standard software development exclusions (like `node_modules` or `.git`). It leverages the robust staging and zipping mechanisms of the suite to create a pristine, unfiltered 1:1 backup of a generic data folder.

**`Back-XF-PrMaxAge-OneFolder-ExclDirs.ps1`**
Demonstrates the `ExcludeDirs:` ad-hoc hatch. By passing `@{'FolderName'='ExcludeDirs: Logs'}`, it shows how to define a custom, one-off exclusion rule on the fly. This avoids the need to edit the global `ProjectTypeExcludes.ps1` configuration just to handle a unique folder structure for a specific run.

---

## Key Design Features

* **Template Design:** Variables like `$InputFolder` and `$BackupTopLevelFolder` are intentionally declared at the very top of each file, making it incredibly easy to clone the script and adapt it for different drives or workspaces by changing just a few lines.
* **Contextual UX (User Experience):** Integrating tools like `FindByNameContains` *before* prompting for user input (like `MaxAge`) transforms the script from a basic automation tool into an intelligent administrative assistant.
* **Visual Organization:** The scripts use line continuation backticks (`` ` ``) to format the complex hashtable parameters across multiple lines, making the mappings highly readable and easy to maintain.
