Powershell scripts mainly for copying and listing JavaScript software development project source code without folders like node_modules
===========

The main copy scripts use Robocopy and allow for exclusion of folders like node_modules. They initially use the list only feature of Robocopy to list out the files & folders that will be copied if the main Robocopy command is run and provide an option to abort. Robocopy's incremental copy as well as MaxAge parameter feature are also provided. The main list scripts exclude folders like node_modules and even .git. Listing only files & folders of MaxAge and top few last modified options are also provided.  

The zip scripts provide for using compress-archive or 7zip and automatically prefix current date and time to output zip filename. The move scripts provide faciliy to move folder or file to backup folder or a MayDeleteLater folder (simple substitute to Recycle bin).  

The combo scripts combine above copy, zip and move scripts.  

The folder ExampleTopLevelScripts in the repo has simple examples of invoking some of the above scripts for particular folders and with hardcoded parameters. This enables them to be used easily on regular basis for needs like incremental backup (using robocopy) and MaxAge backup of specific folders.

I use the scripts on Windows 11.
 
Run or view MyPSScripts.ps1 in Misc folder to get a quick overview of the main scripts. A copy of its output is given
later on in this file but it may be outdated. MyPSScripts.ps1 should have the updated content.

While the scripts were written primarily to help me do copying and listing of JavaScript software development project 
(MERN stack and React Native but also Android Kotlin) source code folders and files, it does help for other folders and files too.

Copy of MyPSScripts.ps1 console output (as of 23 Mar. 2025)
----------------------------------------------------------

These are my active Powershell scripts in cmds folder which is part of PATH env. variable

**Copy related - using Robocopy**

CopyWoXF: Copy contents of a folder excluding specified/default folders (e.g. node_modules and .next folders).  
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