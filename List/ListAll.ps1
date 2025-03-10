# List all files and folders. No folders are excluded. 
param ($Path = $pwd)
function Usage {
    param ($CmdName)
    Write-Host "List all files and folders. No folders are excluded."`n
    Write-Host Usage: $CmdName [Path]`n
    Write-Host Path specifies the input folder which if not specified has default value of . [current directory]
    Write-Host /? passed as first parameter shows this help message.
}

if ($Path -eq "/?") { 
    Usage $myInvocation.InvocationName
    exit 0
}

$Cmd = "ListItemWoXF.ps1 $Path ExcludeNone | ForEach-Object {`"`$(`$_.LastWriteTime) `$(`$_.FullName)`"}"
Write-Host "Executing command: $Cmd"
ListItemWoXF.ps1 $Path ExcludeNone | ForEach-Object {"$($_.LastWriteTime) $($_.FullName)"}
