# Copies SourceFolder1 located in c:\ParentFolderName with prompt for MaxAge.
# Exclude folders are as per project type which is ReactNative in this case.
# Replace SourceFolder1 and path for ParentFolderName as needed 
cd c:\ParentFolderName
PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder ParentFolderName -ProjectDirsAndTypes @{ 'SourceFolder1'='ReactNative'; }
pause
