# List virtually all (modified in last around 10 years), files and folders (excl. special folders)
ListLastModinDaysFF.ps1 3700

#ExcludeDirsRecurseListFilesDirs.ps1 | where { ((get-date)-$_.LastWriteTime).days -lt 3700 } | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
