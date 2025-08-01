# ProjectTypeExcludes.ps1
$validTypes = @("ReactNative", "Android", "DotNet", "Others")

$ProjectTypeExcludes = @{
    "ReactNative" = "node_modules android ios .expo .gradle"
    "Android"     = "build release .gradle .idea"
    "DotNet"      = "bin obj node_modules"
    "Others"      = "node_modules .next .gradle .idea .cache .expo build target"
}
$DefaultProjectType = "Others"