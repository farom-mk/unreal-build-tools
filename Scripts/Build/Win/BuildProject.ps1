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

.$env:UE_ROOT\GenerateProjectFiles.bat $env:HL_UPROJECT

# Write-Output "[HL] Building editor..."
# .$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildCookRun -project="$env:HL_UPROJECT" -platform=Win64 -target=Editor -configuration=Development+Shipping

Write-Output "[HL] Building HL modules and client..."
.$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildTarget -project="$env:HL_UPROJECT" -platform=Win64 -target=Game -configuration=Development -allmaps


# .$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildCookRun -project="$env:HL_UPROJECT" -noP4 -platform=Win64 -clientconfig=Shipping -allmaps -build -editorrecompile
