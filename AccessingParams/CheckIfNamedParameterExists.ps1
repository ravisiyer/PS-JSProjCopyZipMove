#param ($param1="Param1DefaultValue")
param ($param1="Param1DefaultValue") 

# Ref: https://java2blog.com/check-if-arguments-exists-powershell/
if ($PSBoundParameters.ContainsKey('param1')) {
    Write-Host "param1 is: $($PSBoundParameters['param1'])."
} else {
    Write-Host "param1 was not passed."
	#Default value does not interfere and so above statement
	#is executed if param1 was not passed on command line.
}
