Write-Host "These are my active Powershell scripts in cmds folder which is part of PATH env. variable" `n
Write-Host "Copy related - using Robocopy"
Write-Host "============================="
Write-Host "CopyWoXF: Copy contents of a folder excluding specified/default folders (e.g. node_modules and .next folders)."
Write-Host "CopyMaxAgeWoXF: Copy contents of a folder based on maxage excluding specified/default folders"
Write-Host "CopyAll: Copy all files and folders. No folders are excluded." `n

Write-Host "List related"
Write-Host "============" 
Write-Host "ListItemWoXF: Output (list) files and folders items (objects) excluding specified/default folders."
Write-Host "ListWoXF: List files and folders excluding specified/default folders."
Write-Host "ListAll: List all files and folders. No folders are excluded."
Write-Host "ListMaxAgeWoXF: List last modified in x days, files and folders OR only unique parent folder names, excluding specified/default folders"
Write-Host "ListLastModWoXF: List few last modified files and folders excluding specified/default folders."
Write-Host "FindFldrsWoXF: Find and list folders with names matching passed Find-Folders-List excluding specified/default folders." `n

Write-Host "Copy, zip and move related"
Write-Host "==========================" 
Write-Host "ZipFldrWDtTm: Zip folder or file with Date and Time prefix by default in output zip filename."
Write-Host "ZipMv: Zip folder or file with Date and Time prefix by default in output zip filename + Move OutputZipFile to BackupFolder."
Write-Host "MoveToBack: Move InputFolderOrFile to BackupFolder."
Write-Host "MoveToMDLWDtTm: Move folder or file to MayDeleteLater folder with Date and Time prefix by default."
Write-Host "CpXFZipMv: CopyWoXF + ZipFldrWDtTm + Move OutputZipFile to BackupFolder + MoveToMDLWDtTm (for CopyWoXF OutputFolder)"
Write-Host "CpZipMv: This script is a wrapper around CpXFZipMv script tailored for copy with ExcludeNone"`n

Write-Host "Misc"
Write-Host "===="
Write-Host "MakeFolderTodayName: Make (create) folder with today's date (yyyyMMdd) as name."
Write-Host "PSScriptsListLastMod: Listing few last modified .ps1 files contained in folder (including subfolders)."
Write-Host "MyPSScripts: This command."`n

Write-Host "Note: PS aliases are set in PS profile location. Alias mya lists PS profile file showing my alias defintions."`n
