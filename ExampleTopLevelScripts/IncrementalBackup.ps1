# Replace FolderName and LogFile variables as needed
$InputFolder = "C:\Users\{username}\CurrProj"
$OutputFolder = "E:\Back-XF-CurrProj"
$LogFile = "Logs\CurrProj-log.txt"

# ` (backtick) is used to continue the command on the next line
# As per Gemini when the hashtable parameter is split across multiple lines, backtick is not needed
# But I have used it and it works fine
BackXFManyProj.ps1 -InputFolder $InputFolder -OutputFolder $OutputFolder -LogFile $LogFile `
-ProjectDirsAndTypes @{ `
    'Others'='Others'; `
    'ReactNative'='ReactNative'; `
    'DotNet'='DotNet'; `
    'Android'='Android'; `
    'Common'='Others' `
}

pause
