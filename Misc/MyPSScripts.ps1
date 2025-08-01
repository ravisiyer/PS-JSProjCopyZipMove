Write-Output "These are my active Powershell scripts in cmds folder which is part of PATH env. variable"
Write-Output ""
Write-Output "Copy related - using Robocopy"
Write-Output "============================="
Write-Output "CopyWoXF: Copy contents of a folder excluding specified/default folders (e.g. node_modules and .next folders)."
Write-Output "CopyXFProj: Copy all source files and folders of a project of various types (ReactNative, Android, DotNet, Others)."
Write-Output "CopyXFRNProj: Copy all source files and folders of a React Native (web and mobile) project."
Write-Output "CopyXFAndroidProj: Copy all source files and folders of an Android project."
Write-Output "CopyXFDotNetProj: Copy all source files and folders of a DotNet project."
Write-Output "BackXFManyProj: Copy all source files and folders of many projects of various project types, using CopyXFProj."
Write-Output "CopyMaxAgeWoXF: Copy contents of a folder based on maxage excluding specified/default folders."
Write-Output "CopyMaxAgeAll: Copies all contents of a folder/directory based on maxage. No folders are excluded."
Write-Output "CopyAll: Copy all files and folders. No folders are excluded."
Write-Output ""

Write-Output "List related"
Write-Output "============" 
Write-Output "ListItemWoXF: Output (list) files and folders items (objects) excluding specified/default folders."
Write-Output "ListWoXF: List files and folders excluding specified/default folders."
Write-Output "ListAll: List all files and folders. No folders are excluded."
Write-Output "ListMaxAgeWoXF: List last modified in x days, files and folders OR only unique parent folder names, excluding specified/default folders."
Write-Output "ListLastModWoXF: List few last modified files and folders excluding specified/default folders."
Write-Output "FindFldrsWoXF: Find and list folders with names matching passed Find-Folders-List excluding specified/default folders."
Write-Output ""

Write-Output "Copy, zip and move related"
Write-Output "==========================" 
Write-Output "ZipFldrWDtTm: Zip folder or file with Date and Time prefix by default in output zip filename."
Write-Output "ZipMv: Zip folder or file with Date and Time prefix by default in output zip filename + Move OutputZipFile to BackupFolder."
Write-Output "7zipMv: This script is a wrapper around ZipMv script tailored for zip with Use7zip Y and UseTodaySubFolder Y."
Write-Output "MoveToBack: Move InputFolderOrFile to BackupFolder."
Write-Output "MoveToMDLWDtTm: Move folder or file to MayDeleteLater folder with Date and Time prefix by default."
Write-Output "CpXFZipMv: CopyWoXF + ZipFldrWDtTm + Move OutputZipFile to BackupFolder + MoveToMDLWDtTm (for CopyWoXF OutputFolder)."
Write-Output "CpZipMv: This script is a wrapper around CpXFZipMv script tailored for copy with ExcludeNone."
Write-Output "PrMaxAgeMFCpXF7ZipMv: Wrapper around CpXFZipMv script tailored for backup copy of multiple folders with user prompt for MaxAge and using 7zip."
Write-Output ""

Write-Output "Misc"
Write-Output "===="
Write-Output "MakeFolderTodayName: Make (create) folder with today's date (yyyyMMdd) as name."
Write-Output "PSScriptsListLastMod: Lists top few last modified .ps1 files contained in a folder (including subfolders)."
Write-Output "CopyFileWDtTm: Copies a file to a new name with a timestamp suffix."
Write-Output "MyPSScripts: This command."

Write-Output "Note: PS aliases are set in PS profile location. Alias mya lists PS profile file showing my alias defintions."
