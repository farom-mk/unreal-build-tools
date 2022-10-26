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

Write-Output "[HL] Building engine and sample project..."
.$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildCookRun -project="Samples\StarterContent\StarterContent.uproject" -platform=Win64 -clientconfig=Development+Shipping -editorrecompile -build
