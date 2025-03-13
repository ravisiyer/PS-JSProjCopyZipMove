param ($inputparm1="")

function usage {
  param ($cmdname)
  Write-Host Usage: $cmdname Parameter-1
  Write-Host "Script to show last character of passed parameter."
  Write-Host "Script also shows that parameters enclosed in single or double quotes",
   "are passed as strings without enclosing quotes."
}

if ( "" -eq $inputparm1  ) {
    write-host "Parameter (1) not specified."
    usage $myInvocation.InvocationName
    exit
  }

  write-host "Input parameter(1): " $inputparm1 

$len = $inputparm1.length
Write-Host "Last character of input parameter is: "  $inputparm1.substring($len-1,1)
Write-Host "Note that parameters enclosed in single or double quotes are passed as strings without enclosing quotes."
