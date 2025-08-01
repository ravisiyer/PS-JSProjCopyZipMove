# Copies SourceFolder1, SourceFolder2 and SourceFolder3 located in c:\ParentFolderName with prompt for MaxAge.
# Exclude folders are as per project type specified for each SourceFolder.
# Replace SourceFolder1, SourceFolder2 and SourceFolder3, and path for ParentFolderName as needed 
cd c:\ParentFolderName

# ` (backtick) is used to continue the command on the next line
# As per Gemini when the hashtable parameter is split across multiple lines, backtick is not needed
# But I have used it and it works fine
PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder ParentFolderName `
-ProjectDirsAndTypes @{ `
    'SourceFolder1'='Others'; `
    'SourceFolder2'='ReactNative'; `
    'SourceFolder3'='Android'; `
}
pause
