# ProjectTypeExcludes.ps1

# Common excludes: IDE state, transient caches, and manual overrides.
# .git is NOT included to ensure version history is backed up.
$CommonExcludes = ".gradle .expo .idea .vscode .agents .gemini .antigravity .cache .pnpm-store .turbo NIBS-RAVISIYER"

$validTypes = @("ReactNative", "Android", "DotNet", "Others")

$ProjectTypeExcludes = @{
    "ReactNative" = "node_modules android ios $CommonExcludes"
    "Android"     = "build release $CommonExcludes"
    "DotNet"      = "bin obj node_modules $CommonExcludes"
    "Others"      = "node_modules .next .astro .vercel .netlify build target out dist $CommonExcludes"
}
$DefaultProjectType = "Others"