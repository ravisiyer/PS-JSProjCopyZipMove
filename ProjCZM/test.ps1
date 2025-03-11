param ($InputFolder="", $BackupFolder="")
$Cmd = "C:\Users\ravi-user\Projects\PS-Scripts\CopyWoXF\CopyWoXF $InputFolder"
# Invoke-Expression $Cmd # This works IFIRC
$OutputFolder = Invoke-Expression $Cmd  # LHS variable results in robocopy log data to be returned in LHS variable!
Write-Host $OutputFolder
Write-Host Above CopyWoXF command finished execution.`n

# about_Return, https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_return?view=powershell-7.5 seems to explain above issue:
# In PowerShell, the results of each statement are returned as output, even without a statement that contains the Return keyword. Languages like C or C# return only the value or values that are specified by the return keyword.
# ...
# Beginning in PowerShell 5.0, PowerShell added language for defining classes, by using formal syntax. In the context of a PowerShell class, nothing is output from a method except what you specify using a return statement.
# -----------

