# Copies SourceFolder in c:\ParentFolderName with prompt for MaxAge
# Uses ExcludeNone to copy all files
# Replace SourceFolder and path for ParentFolderName as needed 
cd c:\ParentFolderName
PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder ParentFolderName -ProjectDirsAndTypes @{ 'SourceFolder'='ExcludeNone'}
pause
