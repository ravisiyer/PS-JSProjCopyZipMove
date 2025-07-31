Powershell scripts for listing, copying, zipping and moving MERN stack (Others), React Native, Android and DotNet software development projects source code excluding folders like node_modules
===========

*Disclaimer: These scripts are not perfect and surely have some bugs. But they currently are satisfying most of my key needs and work for my use cases. So I thought they may be useful to some others and hence I have shared them as a public repo. The scripts have a lot of repetitive code across them as Powershell is relatively new to me and I focused on quickly getting the task done, limiting my learning Powershell time to a minimum. At some later point, I hope to refactor the code to be modular and DRY (less repetition).*

The copy scripts use Robocopy and allow for exclusion of folders like node_modules. They initially use the list only feature of Robocopy to list out the files & folders that will be copied if the Robocopy command that does the actual copy is run and provide an option to abort. I find this list only preview of the copy to be quite useful and have aborted the actual copy command when I felt it is not required. Robocopy's incremental copy as well as MaxAge parameter features are also provided. Some of the list scripts exclude folders like node_modules and even .git. Listing only files & folders of MaxAge and top few last modified options are also provided.  

The zip scripts provide for using compress-archive (which does not include hidden folders like .git) or 7zip (which includes hidden folders like .git) and automatically prefix current date and time to output zip filename. The move scripts provide facility to move a folder or file to a backup folder or a MayDeleteLater folder (simple substitute to Recycle bin).  

The combo scripts combine above copy, zip and move scripts.  

The folder ExampleTopLevelScripts in the repo has simple examples of invoking some of the above scripts for particular folders and with hardcoded parameters. This enables them to be used easily on regular basis by simply running them without any parameters (File Explorer -> Right-Click on PS script -> Run with PowerShell) for needs like incremental backup (using robocopy) and MaxAge backup of specific folders (MaxAge is taken as input via prompt).

I use the scripts on Windows 11.
 
Run or view MyPSScripts.ps1 in Misc folder to get a quick overview of the main scripts. A copy of its output is given
later on in this file but it may be outdated. MyPSScripts.ps1 should have the updated content.

While the scripts were written primarily to help me do listing, copying, zipping and moving of mainly JavaScript software development projects 
(MERN stack including Next.js, and React Native but also few Java and Android Kotlin projects and few DotNet projects) source code folders and files, it does help for other non-software-development-project folders and files too.

Copy of MyPSScripts.ps1 console output (as of 31 Jul. 2025)
----------------------------------------------------------

These are my active Powershell scripts in cmds folder which is part of PATH env. variable

**Copy related - using Robocopy**

CopyWoXF: Copy contents of a folder excluding specified/default folders (e.g. node_modules and .next folders).  
CopyXFProj: Copy all source files and folders of a project of various types (ReactNative, Android, DotNet, Others).  
CopyXFRNProj: Copy all source files and folders of a React Native (web and mobile) project.  
CopyXFAndroidProj: Copy all source files and folders of an Android project.  
CopyXFDotNetProj: Copy all source files and folders of a DotNet project.  
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
PrMaxAgeCpXF7ZipMv: Wrapper around CpXFZipMv script tailored for backup copy with user prompt for MaxAge and using 7zip.  

**Misc**

MakeFolderTodayName: Make (create) folder with today's date (yyyyMMdd) as name.  
PSScriptsListLastMod: Lists top few last modified .ps1 files contained in a folder (including subfolders).  
MyPSScripts: This command.  
Note: PS aliases are set in PS profile location. Alias mya lists PS profile file showing my alias defintions.
