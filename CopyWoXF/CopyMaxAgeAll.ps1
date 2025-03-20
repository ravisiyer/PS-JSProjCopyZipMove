# Copies all contents of a folder/directory based on maxage 
# It is a wrapper around Copy
param ($InputFolder="", $MaxAge="1")
function Usage {
    param ($cmdName)
    Write-Host "Copies all contents of a folder/directory based on maxage. No folders are excluded."`n
    Write-Host Usage: $cmdName InputFolder [MaxAge]`n
    Write-Host This command is a wrapper around CopyMaxAgeWoXF.`n
}

if ( "" -eq $InputFolder  ) {
    write-error "Input folder not specified."
    Usage $myInvocation.InvocationName
    exit 1
}

if ($InputFolder -eq "/?") { 
    Usage $myInvocation.InvocationName
    exit 0
}

$Cmd = "CopyMaxAgeWoXF '$InputFolder' $MaxAge ExcludeNone"
Write-Host "Invoking $Cmd"
Invoke-Expression $Cmd