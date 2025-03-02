# Creates a zip file 'modified-files.zip' having all modified files since last commit
# Run in top-level folder
# Ref: Git: how to get all the files changed and new files in a folder or zip?, 
# https://stackoverflow.com/questions/4126300/git-how-to-get-all-the-files-changed-and-new-files-in-a-folder-or-zip
# zip is not supported on my PC. After some trials, got the Powershell command for my PC
#
& "C:\Program Files\7-Zip\7z.exe" a modified-files.zip $(git ls-files --modified)