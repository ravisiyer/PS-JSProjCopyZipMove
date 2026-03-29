param ($InputFolder="")

function Usage {
  param ($cmdName)
  Write-Host "Checks if a folder is empty, and if so, deletes it."`n
  Write-Host Usage: $cmdName InputFolder`n
}

if ($InputFolder -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

$InputFolder = $InputFolder.trim()
if ( "" -eq $InputFolder  ) {
  Write-Error "Input folder not specified."
  Usage $myInvocation.InvocationName
  exit 1
}

If ( -not (Test-Path -path $InputFolder -PathType Container)) {
  If (Test-Path -path $InputFolder) {
    Write-Error "Input parameter specified: '$InputFolder' is a file, not a folder. Aborting!"
  } Else {
    Write-Error "Input parameter specified: '$InputFolder' does not exist. Aborting!"
  }
  exit 1
}

# Use -Force to ensure hidden files/folders are accounted for. 
# Select-Object -First 1 makes it highly efficient by stopping the search as soon as one item is found.
$HasContents = Get-ChildItem -Path $InputFolder -Force | Select-Object -First 1

if ($null -ne $HasContents) {
  Write-Error "Folder '$InputFolder' is not empty. Aborting deletion."
  exit 1
}

Write-Host "Folder '$InputFolder' is empty. Proceeding to delete it..."

Remove-Item -Path $InputFolder -Force
