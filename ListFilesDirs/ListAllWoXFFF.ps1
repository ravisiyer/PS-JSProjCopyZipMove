# List virtually all (modified in last around 10 years), files and folders (excl. special folders)
param ($Path = $pwd)
ListMaxAgeFF.ps1 $Path 3700
