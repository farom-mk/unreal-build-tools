If (-not (Test-Path $env:UE_ROOT\Engine)) {
    Write-Error "Invalid path in UE_ROOT envvar."
    exit 1
}
If (-not (Test-Path $env:HL_UPROJECT)) {
    Write-Error "Invalid path in HL_UPROJECT envvar."
    exit 1
}
If (-not (Test-Path $env:HL_PROJECT_DIR\Source)) {
    Write-Error "Invalid path in HL_PROJECT_DIR envvar."
    exit 1
}

If (-not ($env:BUILD_CONFIG) -or -not ($env:BUILD_CONFIG.ToLower() -eq "shipping")) {
    $env:BUILD_CONFIG = "Development"
}

.$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildCookRun -project="$env:HL_UPROJECT" -noP4 -platform=Win64 -clientconfig="$env:BUILD_CONFIG" -cook -allmaps -build -stage -pak -archive -partialgc -prereqs -archivedirectory="$env:HL_PROJECT_DIR\Packaged"
