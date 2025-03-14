Powershell scripts mainly for copying and listing software development project source code folders and files
===========

I use the scripts on Windows 11.
 
Run or view MyPSScripts.ps1 in Misc folder to get a quick overview of the main scripts. A copy of its output is given
later on in this file but it may be outdated. MyPSScripts.ps1 should have the updated content.

While the scripts were written primarily to help me do copying and listing of software development project (MERN stack,
React Native and Android) source code folders and files, it does help for other folders and files too.

Copy of MyPSScripts.ps1 console output
--------------------------------------

These are my active Powershell scripts in cmds folder which is part of PATH env. variable

**Copy related - using Robocopy**

CopyWoXF: Copy contents of a folder excluding specified/default folders (e.g. node_modules and .next folders).  
CopyMaxAgeWoXF: Copy contents of a folder based on maxage excluding specified/default folders.  
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
MoveToBack: Move InputFolderOrFile to BackupFolder.  
MoveToMDLWDtTm: Move folder or file to MayDeleteLater folder with Date and Time prefix by default.  
CpXFZipMv: CopyWoXF + ZipFldrWDtTm + Move OutputZipFile to BackupFolder + MoveToMDLWDtTm (for CopyWoXF OutputFolder).  
CpZipMv: This script is a wrapper around CpXFZipMv script tailored for copy with ExcludeNone.  

**Misc**

MakeFolderTodayName: Make (create) folder with today's date (yyyyMMdd) as name.  
PSScriptsListLastMod: Listing few last modified .ps1 files contained in folder (including subfolders).  
MyPSScripts: This command.  

Note: PS aliases are set in PS profile location. Alias myals lists PS profile file showing my alias defintions.
