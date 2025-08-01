# From Gemini; Not yet tested
# # Find the full path to the script using Get-Command
# # This searches all locations in your PATH environment variable.
# try {
#     $scriptToSource = Get-Command -Name "ProjectTypeExcludes.ps1" -ErrorAction Stop

#     # Use the dot-sourcing operator with the full path.
#     # The .Source property of the Get-Command object contains the full path.
#     . $scriptToSource.Source
#     Write-Host "Successfully dot-sourced $($scriptToSource.Source)"
# } catch {
#     Write-Error "Error: Could not find ProjectTypeExcludes.ps1 in your PATH."
#     Write-Error $_.Exception.Message
# }
