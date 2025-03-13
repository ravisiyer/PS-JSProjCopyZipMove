param ($Path = $pwd, $TopFewCount = 30)
Write-Host Usage: $CmdName [Path TopFewCount]`n
Write-Host "Listing top $TopFewCount last modified .ps1 files contained in folder $Path (including subfolders)."`n
Get-ChildItem -recurse -include *.ps1 $Path | Sort-Object -Descending -Property LastWriteTime | `
  Select-Object -first $TopFewCount | ForEach-Object {Write-Host $_.LastWriteTime $_.FullName}
Write-Host