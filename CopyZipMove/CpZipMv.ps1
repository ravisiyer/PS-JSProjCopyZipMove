param ($InputFolder="", $MaxAge="-", $Use7zip = "", $UseTodaySubFolder="N", $BackupFolder="")
function Usage {
    param ($cmdName)
    Write-Host This script is a wrapper around CpXFZipMv script tailored for copy with ExcludeNone
    Write-Host Usage: $cmdName InputFolder [MaxAge Use7zip UseTodaySubFolder BackupFolder]`n
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

if ( "" -eq $Use7zip  )  {
    $Use7zip = "-"
}

if ( "" -eq $UseTodaySubFolder  )  {
    $UseTodaySubFolder = "-"
}

$Cmd = "CpXFZipMv '$InputFolder' $MaxAge $Use7zip $UseTodaySubFolder ExcludeNone - '$BackupFolder'"
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd
