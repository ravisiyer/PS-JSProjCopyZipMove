# Simple script to delete NMNX folders in current directory after user confirmation for each folder
# delete.
# Note that these folders are deleted 'permanently' (not sent to Recycle bin) as that seems to
# be the behaviour of Remove-Item cmdlet.
If ( Test-Path "node_modules" ) { Remove-Item "node_modules" }
If ( Test-Path ".next" ) { Remove-Item ".next" }