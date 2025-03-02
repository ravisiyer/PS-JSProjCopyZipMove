@echo off
rem start at the top of the tree to visit and loop though each directory
for /r %%a in (.) do (
  rem enter the directory
  if %%a==".git" (
		echo Skipping .git directory
	)	else (
		pushd %%a
		echo In directory:
		rem cd
		echo %%a
		rem echo dir 
		rem dir 
		rem echo dir /AD 
		rem dir /AD
		rem leave the directory
		popd
  )
)