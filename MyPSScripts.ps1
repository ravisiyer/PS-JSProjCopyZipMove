Write-Host "These are my active Powershell scripts in cmds folder which is part of PATH env. variable"
Write-Host "Copy related - using Robocopy"
Write-Host "============================="
Write-Host "CopyWoXF: Copy contents of a folder excluding specified/default folders (e.g. node_modules and .next folders)."
Write-Host "CopyMaxAgeWoXF: Copy contents of a folder based on maxage excluding specified/default folders"
Write-Host "CopyAll: Copy all files and folders. No folders are excluded." `n

Write-Host "List related"
Write-Host "============" 
Write-Host "ListItemWoXF: Output (list) files and folders items (objects) excluding specified/default folders."
Write-Host "ListWoXF: List files and folders excluding specified/default folders."
Write-Host "ListAll: List all files and folders. No folders are excluded." `n
Write-Host "ListMaxAgeWoXF: List last modified in x days, files and folders OR only unique parent folder names, excluding specified/default folders"
Write-Host "ListLastModWoXF: List few last modified files and folders excluding specified/default folders."
Write-Host "FindFldrsWoXF: Find and list folders with names matching passed Find-Folders-List excluding specified/default folders."

Write-Host "Zip and move to MayDeleteLater folder related"
Write-Host "=============================================" 
Write-Host "ZipFldrWDtTm: Zip folder or file with Date and Time prefix by default in output zip filename."
Write-Host "MoveToMDLWDtTm: Move folder or file to MayDeleteLater folder with Date and Time prefix by default." `n

# Write-Host "Misc"
# Write-Host "===="
Write-Host "MyPSScripts: This command."`n
