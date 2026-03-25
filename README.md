# JS Tech Stack Source Code Copy, Zip, Move, List & Misc PowerShell Scripts

## Overview
This project contains PowerShell scripts for listing, copying, zipping, and moving the source code of MERN stack software development projects, automatically excluding heavy dependency folders like `node_modules`. The copying capabilities were later expanded to support React Native, Android, DotNet, and Java projects. It also has some miscellaneous related scripts.

*Disclaimer: While these scripts were initially built rapidly to solve immediate workflow needs (and thus contain some repetitive code), in March 2026 they have undergone a comprehensive review and documentation process by myself with the assistance of Gemini AI. Known technical debt, minor bugs, and refactoring targets have been formally logged in the respective sub-folder documentation. They successfully satisfy my daily backup and file management needs, and I am sharing them as a public repo just in case they may be useful to others.*

The copy scripts use Robocopy and allow for exclusion of folders like node_modules. Robocopy's incremental copy as well as MaxAge parameter features are also provided. 

The copy scripts initially use the list only feature of Robocopy to list out the files & folders that will be copied if the Robocopy command that does the actual copy is run and provide an option to abort. I find this list only preview of the copy followed by abort option, to be quite useful and, quite often, the list preview has shown me that I had to modify some files/folders before running the live copy command. In such cases, I have aborted the run, made the changes and then run the copy script again. 

Some of the list scripts exclude folders like node_modules and even .git. Listing only files & folders of MaxAge and top few last modified options are also provided.  

The zip scripts provide for using compress-archive (which does not include hidden folders like .git) or 7zip (which includes hidden folders like .git) and automatically prefix current date and time to output zip filename. The move scripts provide facility to move a folder or file to a backup folder or a MayDeleteLater folder (simple substitute to Recycle bin).  

The combo scripts combine above copy, zip and move scripts.  

## Repository Structure & Documentation

This project is highly modular. Detailed documentation for each component can be found in the respective sub-folder `README.md` files:
* **[CopyWoXF/README.md](CopyWoXF/README.md):** The core `robocopy` engine, smart technology-stack routers, and time-based incremental backup scripts.
* **[CopyZipMove/README.md](CopyZipMove/README.md):** High-level orchestrator scripts that chain copy, zip, and move operations into complete, automated backup pipelines.
* **[List/README.md](List/README.md):** A custom recursion engine for incredibly fast, filtered directory traversal and file discovery (bypassing heavy dependency folders).
* **[Misc/README.md](Misc/README.md):** Standalone utility scripts for targeted searching, quick timestamped backups, and repository indexing.
* **[ExampleTopLevelScripts/README.md](ExampleTopLevelScripts/README.md):** User-friendly, configurable right-click-and-run templates for batch processing multiple project directories at once.
* **[AutoTestData/README.md](AutoTestData/README.md):** An automated, cryptographic test harness to verify the integrity of the core copy logic.

I use the scripts on Windows 11.
 
Run or view MyPSScripts.ps1 in Misc folder to get a quick overview of the main scripts. A copy of its output is given
later on in this file but it may be outdated. MyPSScripts.ps1 should have the updated content.

Initially the scripts were written primarily to help me do listing, copying, zipping and moving of mainly JavaScript software development projects (MERN stack including Next.js) source code folders and files. Later I expanded the copying scripts to handle ReactNative, Android (Android Studio as IDE, Prog. Lang. as Kotlin/Java), DotNet (VS2022 as IDE, Prog. Lang. as C#/VB.NET) and Java projects (IDEA as IDE). The zipping and moving scripts are independent of the project type. I did not explore upgrading the listing scripts to have specific code for ReactNative, Android, DotNet and Java projects barring a minor modification to one script. If I feel the need for the listing scripts to specifically handle ReactNative, Android, DotNet and Java projects, I will consider doing it.

The scripts help for other non-software-development-project folders and files too.

The exclude folders for various project types part of the scripts was, IIRC, first enhanced in Aug. 2025. In Mar. 2026 I improved it. The documentation of this part is provided in my blog post: [Handling varying exclude folders for source code backup of MERN, React Native, Android and DotNet tech stacks](https://raviswdev.blogspot.com/2025/08/handling-varying-exclude-folders-for.html).

Copy of MyPSScripts.ps1 console output (as of 2 Aug. 2025)
----------------------------------------------------------
*Note: This copy has been manually modified and checked. So there could be some differences with the actual output of MyPSScripts.ps1 script.*

---

These are my active Powershell scripts in cmds folder which is part of PATH env. variable

**Copy related - using Robocopy**

CopyWoXF: Copy contents of a folder excluding specified/default folders (e.g. node_modules and .next folders).  
CopyXFProj: Copy all source files and folders of a project of various types (ReactNative, Android, DotNet, Others).  
CopyXFRNProj: Copy all source files and folders of a React Native (web and mobile) project.  
CopyXFAndroidProj: Copy all source files and folders of an Android project.  
CopyXFDotNetProj: Copy all source files and folders of a DotNet project.  
BackXFManyProj: Copy all source files and folders of many projects of various project types, using CopyXFProj.  
CopyMaxAgeWoXF: Copy contents of a folder based on maxage excluding specified/default folders.  
CopyMaxAgeAll: Copies all contents of a folder/directory based on maxage. No folders are excluded.  
CopyAll: Copy all files and folders. No folders are excluded.  

**List related**

ListItemWoXF: Output (list) files and folders items (objects) excluding specified/default folders.  
ListWoXF: List files and folders excluding specified/default folders.  
ListAll: List all files and folders. No folders are excluded.  
ListMaxAgeWoXF: List last modified in x days, files and folders OR only unique parent folder names, excluding specified/default folders.  
ListLastModWoXF: List few last modified files and folders excluding specified/default folders.  
FindFldrsWoXF: Find and list folders with names matching passed Find-Folders-List excluding specified/default folders.  

**Copy, zip and move related**

ZipFldrWDtTm: Zip folder or file with Date and Time prefix by default in output zip filename.  
ZipMv: Zip folder or file with Date and Time prefix by default in output zip filename + Move OutputZipFile to BackupFolder.  
7zipMv: This script is a wrapper around ZipMv script tailored for zip with Use7zip Y and UseTodaySubFolder Y.  
MoveToBack: Move InputFolderOrFile to BackupFolder.  
MoveToMDLWDtTm: Move folder or file to MayDeleteLater folder with Date and Time prefix by default.  
CpXFZipMv: CopyWoXF + ZipFldrWDtTm + Move OutputZipFile to BackupFolder + MoveToMDLWDtTm (for CopyWoXF OutputFolder).  
CpZipMv: This script is a wrapper around CpXFZipMv script tailored for copy with ExcludeNone.  
PrMaxAgeMFCpXF7ZipMv: Wrapper around CpXFZipMv script tailored for backup copy of multiple folders with user prompt for MaxAge and using 7zip.  

**Misc**

MakeFolderTodayName: Make (create) folder with today's date (yyyyMMdd) as name.  
PSScriptsListLastMod: Lists top few last modified .ps1 files contained in a folder (including subfolders).  
CopyFileWDtTm: Copies a file to a new name with a timestamp suffix.  
MyPSScripts: This command.  
Note: PS aliases are set in PS profile location. Alias mya lists PS profile file showing my alias defintions.

---

**P.S. regarding AI Context Windows:**  
You may notice a file named `Context-Window-Size-Impact.md` in this repository. This document was generated during my work on this project using Gemini Code Assist. It discusses how LLM context window sizes impact an AI's "memory" during software development sessions. While not directly related to the core PowerShell scripts here, I have retained it as a temporary document. I plan to eventually publish it as a post on my Blogger blog, at which point I will update the document with the live link.
