# x does not exist
$Cmd = "Compress-Archive -Path x -DestinationPath x.zip"
Write-Host "Command to be executed: $Cmd"

try {
    Invoke-Expression $Cmd
}
catch {
    Write-Error "Above command threw exception: $($PSItem.ToString())"
}
Write-Host "Above command finished execution with exit code: $LastExitCode and `$?: $? ." `n
