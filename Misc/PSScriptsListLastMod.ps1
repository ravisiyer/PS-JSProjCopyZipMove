param ($Path = $pwd, $TopFewCount = 30, $Depth = "")
function Usage {
  param ($cmdName)
  Write-Host "Lists top few last modified .ps1 files contained in a folder (including subfolders)."`n
  Write-Host Usage: $CmdName [Path TopFewCount Depth]`n

  Write-Host Default value of Path is the current directory
  Write-Host Default value of TopFewCount is: 30
  Write-Host /? passed as first parameter shows this help message.`n
  }

if ($Path -eq "/?") { 
  Usage $myInvocation.InvocationName
  exit 0
}

if ("" -eq $Depth) {
  Write-Host "Depth is not used."`n
  Get-ChildItem -recurse -filter *.ps1 $Path | Sort-Object -Descending -Property LastWriteTime | `
  Select-Object -first $TopFewCount | ForEach-Object {Write-Host $_.LastWriteTime $_.FullName}
} else {
  Write-Host "Depth of $Depth is used."`n
  Get-ChildItem -depth $Depth -filter *.ps1 $Path | Sort-Object -Descending -Property LastWriteTime | `
  Select-Object -first $TopFewCount | ForEach-Object {Write-Host $_.LastWriteTime $_.FullName}
}
# -depth and -include do not seem to work together
# Get-ChildItem -recurse -include *.ps1 $Path | Sort-Object -Descending -Property LastWriteTime | `
#   Select-Object -first $TopFewCount | ForEach-Object {Write-Host $_.LastWriteTime $_.FullName}
Write-Host