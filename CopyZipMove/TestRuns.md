# Test Runs

## 28 Mar 2026

Note {user-name} has to be substituted with actual user-name.

TestData> C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove\PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder 'C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData' -ProjectDirsAndTypes @{'Input_Others'='Others'}

- Pressed Enter for MaxAge without specifying any value. Got an error message and was prompted again.
- Gave - for MaxAge.
- Copy was done with correct exclusions.
- 7zip was done correctly.
- Chose N for MoveToBack. The zip file was retained in TestData folder as expected.
- Chose N for MoveToMDLWDtTm prompt as I wanted to examine the output folder.
  - The MoveToMDLWDtTm script was aborted and printed aborted message. 
  - CpXFZipMv.ps1 said: Above MoveToMDLWDtTm script failed with exit code: 1.
  - As I knew it was the last step in CpXFZipMv.ps1 I ignored the abort mesage.
  - However, I think like CpXFZipMv.ps1 makes the MoveToBack invocation optional, MoveToMDLWDtTm invocation also should be made optional (in CpXFZipMv.ps1). This will allow for polite skipping of MoveToMDLWDtTm without seeing worrying abort message followed by failure message. The downside will be that the user will have to press Y at one more prompt but I think that is acceptable.

Next I checked the output files & folders.
- 20260328-1611-Input_Others-XF was compared with Input_Others in WinMerge. The former (output) was expected with only specified exclude folders being absent.
- I also looked at the output zip file. It was as expected.

---

Modified CpXFZipMv.ps1 to make MoveToMDLWDtTm invocation optional.

To ensure dev version of CpXFZipMv.ps1 is picked up, I am using the below trick during testing.
$env:PATH = "C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove;$env:PATH"

Repeated earlier test run. This time I could skip MoveToMDLWDtTm 'politely'. No abort or warning message was shown - just "Skipped!"

---

Repeated earlier run with following changes:
- Chose Y for MoveToBack.
- Chose Y for MoveToMDLWDtTm.

- A new folder got created on backup drive:E:\FewDaysBkup\20260328
  - It contained 20260328-1734-Input_Others-XF.zip
- C:\MayDeleteLater folder contained 20260328-1734-Input_Others-XF folder.
- The TestData folder from which the command was run did not have any additional files or folders.

These results are as expected.

---

Repeated earlier run with following changes:
- Gave 1 as MaxAge

As no files/folders had been updated in past 1 day in source folder, robocopy reported 0 files to be copied in dry run and script provided skip option which I accepted. Script ouptut: 

Output folder/directory: 'C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData\20260328-1806-Input_Others-XF-maxage-1' does not exist though CopyWoXF script returned with success.
Perhaps there are no files to be copied. Exiting script: CpXFZipMv with 0 return code.
`---`

That is as expected.

---

Created Input_Others-Mod folder as copy of Input_Others.
  - Modified one file in it.

Ran this command:
```
 C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove\PrMaxAgeMFCpXF7ZipMv.ps1 -InputFolder 'C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData' -ProjectDirsAndTypes @{'Input_Others-Mod'='Others'}
```
- Gave 1 as MaxAge
- Chose Y for MoveToBack.
- Chose Y for MoveToMDLWDtTm.

- In existing folder on backup drive:E:\FewDaysBkup\20260328
  - File: 20260328-1817-Input_Others-Mod-XF-maxage-1.zip got added. The zip file contents are as expected - has the single modified file.
- C:\MayDeleteLater folder contained 20260328-1817-Input_Others-Mod-XF-maxage-1 folder. The folder contents are as expected - has the single modified file.
- The TestData folder from which the command was run did not have any additional files or folders.

These results are as expected.

---

From TestData folder, ran C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove\CpXFProj7ZipMv.ps1 Input_Others

It printed: Delegating to PrMaxAgeMFCpXF7ZipMv.ps1 for single folder 'Input_Others' of type 'Others' with MaxAge '-'...

Rest of the program execution was as expected and results were as expected.

---

Ran: 

C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove\CpXFProj7ZipMv.ps1 Input_Others -MaxAge 1

It printed: Delegating to PrMaxAgeMFCpXF7ZipMv.ps1 for single folder 'Input_Others' of type 'Others' with MaxAge '1'...

As expected, there were no files to be copied. So results were as expected.

---
Now the input folder with single modified file (today) is provided.

Ran: 

C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove\CpXFProj7ZipMv.ps1 Input_Others-Mod -MaxAge 1

It printed: Delegating to PrMaxAgeMFCpXF7ZipMv.ps1 for single folder 'Input_Others-Mod' of type 'Others' with MaxAge '1'...

As expected, one file was copied. So results were as expected.

---

Ran: 

C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove\CpXFRNProj7ZipMv.ps1 Input_ReactNative

It printed: 
```
Delegating to PrMaxAgeMFCpXF7ZipMv.ps1 for single folder 'Input_ReactNative' of type 'ReactNative' with MaxAge '-'...
In dir: C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData
CpXFZipMv 'C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData\Input_ReactNative' - Y Y 'node_modules android ios .gradle .expo .idea .vscode .agents .gemini .antigravity .cache .pnpm-store .turbo NIBS-RAVISIYER'
```

Rest of the script execution was as expected and results were as expected.

---

Ran: 

C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove\CpXFAndroidProj7ZipMv.ps1 Input_Android
It printed: 
```
Delegating to PrMaxAgeMFCpXF7ZipMv.ps1 for single folder 'Input_Android' of type 'Android' with MaxAge '-'...
In dir: C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData
CpXFZipMv 'C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData\Input_Android' - Y Y 'build release .gradle .expo .idea .vscode .agents .gemini .antigravity .cache .pnpm-store .turbo NIBS-RAVISIYER'
```

Rest of the script execution was as expected and results were as expected.

---

Ran: 

C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\CopyZipMove\CpXFDotNetProj7ZipMv.ps1 Input_DotNet

It printed: 
```
Delegating to PrMaxAgeMFCpXF7ZipMv.ps1 for single folder 'Input_DotNet' of type 'DotNet' with MaxAge '-'...
In dir: C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData
CpXFZipMv 'C:\Users\{user-name}\CurrProj\Others\PS-JSProjCopyZipMove\AutoTestData\TestData\Input_DotNet' - Y Y 'bin obj node_modules .gradle .expo .idea .vscode .agents .gemini .antigravity .cache .pnpm-store .turbo NIBS-RAVISIYER'
```

Rest of the script execution was as expected and results were as expected.
