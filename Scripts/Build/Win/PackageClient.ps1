If (-not (Test-Path $env:UE_ROOT\Engine)) {
    Write-Error "Invalid path in UE_ROOT envvar."
    exit 1
}
If (-not (Test-Path $env:UPROJECT)) {
    Write-Error "Invalid path in UPROJECT envvar."
    exit 1
}
If (-not (Test-Path $env:PROJECT_DIR\Source)) {
    Write-Error "Invalid path in PROJECT_DIR envvar."
    exit 1
}

If (-not ($env:BUILD_CONFIG) -or -not ($env:BUILD_CONFIG.ToLower() -eq "shipping")) {
    $env:BUILD_CONFIG = "Development"
}

.$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildCookRun -project="$env:UPROJECT" -noP4 -platform=Win64 -clientconfig="$env:BUILD_CONFIG" -cook -allmaps -build -stage -pak -archive -partialgc -prereqs -archivedirectory="$env:PROJECT_DIR\Packaged"
