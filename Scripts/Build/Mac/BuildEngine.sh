echo "[HL] Fixing up git..."
git config --global core.quotepath false

echo "[HL] Building Engine and Dev sample project..." && \
zsh $UE_ROOT/Engine/Build/BatchFiles/RunUAT.command BuildCookRun -project="Samples/StarterContent/StarterContent.uproject" \
    -platform=Mac -clientconfig=Development+Shipping -editorrecompile -build
