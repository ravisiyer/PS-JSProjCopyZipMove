# List last modified in x days, files and folders (excl. special folders)
# It uses ExcludeDirsRecurseListFilesDirs.ps1 to do the main work
# Usage: script-name [MaxAge]
#
param ($MaxAge="1")
ExcludeDirsRecurseListFilesDirs.ps1 | where { ((get-date)-$_.LastWriteTime).days -lt $MaxAge } | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}

# function Usage {
#  param ($cmdName)
#  Write-Host Usage: $cmdName [MaxAge]
#  Write-Host Usage: If MaxAge is not specified, default value of 1 [day] is used
# }

