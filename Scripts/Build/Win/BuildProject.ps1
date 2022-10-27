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

.$env:UE_ROOT\GenerateProjectFiles.bat $env:UPROJECT

# Write-Output "[HL] Building editor..."
# .$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildCookRun -project="$env:HL_UPROJECT" -platform=Win64 -target=Editor -configuration=Development+Shipping

Write-Output "[Farom] Building project modules..."
.$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildTarget -project="$env:UPROJECT" -platform=Win64 -target=Game -configuration=Development -allmaps


# .$env:UE_ROOT\Engine\Build\BatchFiles\RunUAT.bat BuildCookRun -project="$env:HL_UPROJECT" -noP4 -platform=Win64 -clientconfig=Shipping -allmaps -build -editorrecompile
