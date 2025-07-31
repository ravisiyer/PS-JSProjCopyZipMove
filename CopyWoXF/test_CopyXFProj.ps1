# To run test, presuming TestData.zip has test data:
# ./test_CopyXFProj.ps1 

param (
    [string]$TestDataZip = "TestData.zip"
)

function Compare-Folders($Path1, $Path2) {
    $files1 = Get-ChildItem -Recurse $Path1 | Where-Object { -not $_.PSIsContainer }
    $files2 = Get-ChildItem -Recurse $Path2 | Where-Object { -not $_.PSIsContainer }

    $rel1 = $files1 | ForEach-Object { $_.FullName.Substring($Path1.Length) }
    $rel2 = $files2 | ForEach-Object { $_.FullName.Substring($Path2.Length) }

    $diff = Compare-Object $rel1 $rel2
    if ($diff.Count -ne 0) { return $false }

    foreach ($file in $rel1) {
        $f1 = Join-Path $Path1 $file
        $f2 = Join-Path $Path2 $file
        if (Test-Path $f2) {
            if ((Get-FileHash $f1).Hash -ne (Get-FileHash $f2).Hash) {
                return $false
            }
        }
    }
    return $true
}

# Unzip test data to a persistent folder for manual inspection
$TempRoot = Join-Path $PSScriptRoot "TestRun"
if (-not (Test-Path $TempRoot)) {
    Expand-Archive $TestDataZip $TempRoot
}

# Detect top-level test data folder (like TestData)
$TestDataRoot = $TempRoot
$subfolders = Get-ChildItem $TempRoot | Where-Object { $_.PSIsContainer }
if ($subfolders.Count -eq 1) {
    $TestDataRoot = $subfolders[0].FullName
}

$ProjectTypes = @("ReactNative", "Android", "DotNet", "Others")
$ScriptPath = Join-Path $PSScriptRoot "CopyXFProj.ps1"

$TestResults = @{}

foreach ($type in $ProjectTypes) {
    $InputFolder = Join-Path $TestDataRoot "Input_$type"
    $ExpectedFolder = Join-Path $TestDataRoot "Expected_$type"
    # $OutputFolder = Join-Path $TestDataRoot "Output_$type"
    $OutputFolder = Join-Path $TestDataRoot "Input_$type-XF"

    if (-not (Test-Path $InputFolder)) {
        $TestResults[$type] = "Input folder $InputFolder not found. Skipping."
        Write-Host "$($type): Input folder $InputFolder not found. Skipping."
        continue
    }

    # Run the script (assumes script creates/copies to Output_$type)
    & powershell -ExecutionPolicy Bypass -File $ScriptPath -InputFolder $InputFolder -ProjectType $type

    # Compare output with expected
    if (Test-Path $OutputFolder) {
        $result = Compare-Folders $OutputFolder $ExpectedFolder
        if ($result) {
            $TestResults[$type] = "Success"
            Write-Host "$($type): Success"
        } else {
            $TestResults[$type] = "Failure (differences found)"
            Write-Host "$($type): Failure (differences found)"
        }
    } else {
        $TestResults[$type] = "Failure (output folder not found)"
        Write-Host "$($type): Failure (output folder not found)"
    }
}

Write-Host "`n===================="
Write-Host "Test Summary:"
Write-Host "===================="
foreach ($type in $ProjectTypes) {
    Write-Host "$($type):`t$($TestResults[$type])"
}
Write-Host "`nTest run complete. Input and output folders are kept in: $TestDataRoot"
Write-Host "You may manually inspect or delete them as needed."