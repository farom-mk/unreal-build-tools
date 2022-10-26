
echo "[HL] Generating project files"
zsh $UE_ROOT/GenerateProjectFiles.command $HL_UPROJECT

echo "[HL] Building HL modules and client..."
zsh $UE_ROOT/Engine/Build/BatchFiles/RunUAT.command BuildTarget -project="$HL_UPROJECT" -platform=Mac -target=Game -configuration=Development+Shipping -allmaps
