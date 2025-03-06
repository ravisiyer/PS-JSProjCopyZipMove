# List virtually all (modified in last around 10 years), files and folders. No folders are excluded. 
param ($Path = $pwd)
ListMaxAgeFF.ps1 $Path 3700 ExcludeNone
