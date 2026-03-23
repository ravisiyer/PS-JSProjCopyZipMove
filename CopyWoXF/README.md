# CopyWoXF Suite Documentation

This documentation has been provided by Gemini and has been reviewed and edited by me.

**Date created:** 23 Mar 2026

## Summary

The `CopyWoXF` folder contains a comprehensive suite of PowerShell utilities designed for backing up software development projects. The primary goal of these scripts is to copy source code while intelligently excluding heavy, regeneratable directories (such as `node_modules`, `build`, `.next`, `bin`, and `obj`).

The suite is built using a highly layered architecture:
*   **The Engine:** A core script (`CopyWoXF.ps1`) that interacts safely with Windows `robocopy`.
*   **Smart Routers:** Scripts that automatically determine what to exclude based on the technology stack (e.g., React Native, .NET, Android).
*   **Time-Based Backups:** Scripts that leverage `robocopy`'s MaxAge parameter to only copy recently modified files.
*   **Bulk Processors:** Tools to automate the backup of entire workspaces containing multiple disparate projects.
*   **Automated Testing:** Cryptographic verification scripts to ensure backups are functionally flawless.

---

## Detailed Script Analysis

### 1. The Core Engine
**`CopyWoXF.ps1`**
This is the heavily armored "workhorse" of the project. It acts as a smart, interactive safety wrapper around `robocopy`.
*   **Two-Phase Execution:** It runs `robocopy` with the `/L` (list only) switch first to present a "dry run" preview. This allows the user to evaluate what will happen and confirm before any actual file manipulation occurs.
*   **Intelligent Exit Code Handling:** Robocopy uses non-standard exit codes. This script explicitly checks for success codes (`0` meaning no change, `1` meaning files copied) and intelligently asks if the user wants to skip the actual copy phase if no files need updating.
*   **Path Scrubbing:** It manually strips trailing backslashes (`\`) from input paths to prevent `robocopy` from misinterpreting them as escape characters—a classic gotcha.

### 2. Smart Routers & Wrappers
**`CopyXFProj.ps1`**
If `CopyWoXF` is the engine, this is the smart steering wheel. It separates *logic* from *configuration* by utilizing `ProjectTypeExcludes.ps1`. Instead of memorizing exact exclusion folders for different stacks, you declare your intent (e.g., `CopyXFProj "MyApp" "Android"`), and it constructs the correct arguments for `CopyWoXF`.

**`CopyXFRNProj.ps1`, `CopyXFDotNetProj.ps1`, `CopyXFAndroidProj.ps1`**
These are straightforward "alias" scripts that expose a single `$InputFolder` parameter. They hardcode the `-ProjectType` delegation to `CopyXFProj.ps1`, drastically reducing typing for daily, workflow-specific backups. Note that `Others` Project Type is the default for `CopyXFProj.ps1` and so for `Others` Project Type, `CopyXFProj.ps1` can be directly run providing only the `$InputFolder` parameter.

### 3. Time-Based Incremental Backups
**`CopyMaxAgeWoXF.ps1`**
This script introduces time-based filtering to capture *only* what has changed recently.
*   **Smart Output Naming:** It automatically generates a highly descriptive output folder name using the format: `[yyyyMMdd]-[InputFolder]-maxage-[MaxAge]`.
*   **Safety Checks:** It verifies if the dynamically generated folder already exists and intentionally aborts if it does to prevent mixing different backup runs from the same day.

**`CopyMaxAgeAll.ps1`**
A quick wrapper around `CopyMaxAgeWoXF` for when you want *everything* that recently changed. It passes the special `ExcludeNone` flag down the chain, which `CopyWoXF` knows how to interpret to bypass the `/XD` switch entirely.

### 4. Wholesale Cloning & Bulk Operations
**`CopyAll.ps1`**
The "dumb" full copy. While smart exclusions are great, sometimes an exact 1:1 clone is needed. Unlike incremental scripts, `CopyAll.ps1` strictly enforces that the `$OutputFolder` **must not** already exist to prevent accidental data mixing. Because it uses the `ExcludeNone` flag and routes through `CopyWoXF`, it still benefits from the dry-run safety net.

**`BackXFManyProj.ps1`**
The autopilot for a fleet of projects. This script orchestrates batch operations using PowerShell hashtables (e.g., `@{'ReactNativeApp'='ReactNative'; 'BackendAPI'='DotNet'}`). It safely constructs paths and loops through the hashtable, firing off `CopyXFProj` for an entire workspace in one go.

### 5. The Automated Test Harness
**`test_CopyXFProj.ps1`**
A robust test harness to ensure the backup logic remains intact over time.
*   **Pristine State Isolation:** It extracts `TestData.zip` into a fresh `TestRun` directory on the fly so every test starts clean.
*   **Cryptographic Verification:** Using a custom `Compare-Folders` function and `Get-FileHash`, it cryptographically guarantees that the generated backup is a 1:1 bit-perfect copy of the pre-validated expected state, preventing silent failures.