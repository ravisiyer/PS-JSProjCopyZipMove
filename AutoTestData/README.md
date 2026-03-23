# Running CopyWoXF/test_CopyXFProj.ps1 Automated Test Script

---

23 Mar. 2026

Successfully ran the `test_CopyXFProj.ps1` automated test today. 

**How the test works:**
1. The `test_CopyXFProj.ps1` automated test script extracts `TestData.zip` (by default looking in the current working directory) into a temporary `TestRun` folder located inside the `CopyWoXF` directory.
2. It loops through four supported project types: `ReactNative`, `Android`, `DotNet`, and `Others`.
3. For each project type, it runs `CopyXFProj.ps1` against the `Input_<ProjectType>` folder.
   - Note that CopyXFProj.ps1 invokes CopyWoXF.ps1 which shows the command it will run and prompts the user for confirmation. Further CopyWoXF.ps1 first does a dummy run giving the user an idea of what will be copied if he chooses to do the live run. This is followed by a live run where once again the user is prompted for confirmation. This is a useful feature where a user can choose to cancel the live run after noticing something unexpected in the dummy run output.
4. `test_CopyXFProj.ps1` then recursively compares the generated output folder (`Input_<ProjectType>-XF`) against the pre-validated `Expected_<ProjectType>` folder to ensure file structures and cryptographic hashes match perfectly.
5. Test results are summarized in the console. The `TestRun` folder is left intact after execution so any failures can be manually inspected.
   - [TestOutputSample.txt](.\TestOutputSample.txt) has a sample of the initial and final part of the test script console output. 

**How to run it:**
Open a terminal in the `AutoTestData` folder (where `TestData.zip` is located) and execute the test script from the neighboring directory:
```powershell
..\CopyWoXF\test_CopyXFProj.ps1
```

---

16:08 31 July 2025 

The TestData folder and zip file here having input data test folders for various project types supported by CopyWoXF\CopyXFProj.ps1 . It also has the expected output folders for these input data test folders. CopyWoXF\test_CopyXFProj.ps1 automated test script works with TestData.zip provided as input.

This data is kept outside of CopyWoXF folder as it may perhaps be required later for scripts in other folders in this project (e.g. scripts in CopyZipMove folder).

To prevent confusion between two sets of test data folders, the previous 'Test Data' folder used for manual testing of such Copy scripts has been zipped as 20250731-1606-OldTest Data.zip and the 'Test Data' folder has been deleted.