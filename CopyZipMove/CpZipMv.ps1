param ($InputFolder="", $BackupFolder="")
function Usage {
    param ($cmdName)
    Write-Host This script is a wrapper around CpXFZipMv script tailored for copy with ExcludeNone
    Write-Host Usage: $cmdName Input-Folder-Name [Backup-Folder]`n
    Write-Host /? passed as first parameter shows this help message.`n
}
  
if ($InputFolder -eq "/?") { 
    Usage $myInvocation.InvocationName
    exit 0
}

if ( "" -eq $InputFolder  ) {
    write-error "Input folder not specified."
    Usage $myInvocation.InvocationName
    exit 1
}

# CpXFZipMv Usage: $cmdName Input-Folder-Name [Exclude-Folders-List Output-Suffix Backup-Folder]`n
$Cmd = "CpXFZipMv $InputFolder ExcludeNone - $BackupFolder"
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd
