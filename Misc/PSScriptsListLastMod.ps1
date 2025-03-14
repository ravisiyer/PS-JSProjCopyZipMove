param ($Path = $pwd, $TopFewCount = 30, $Depth = "")
Write-Host Usage: $CmdName [Path TopFewCount Depth]
Write-Host "Listing top $TopFewCount last modified .ps1 files contained in folder $Path (including subfolders)."
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