
build_config="$BUILD_CONFIG"
if [[ "$BUILD_CONFIG" != "shipping" && "$BUILD_CONFIG" != "Shipping" ]]; then
    build_config="Development"
fi

echo "[HL] Packaging mac client"
echo "[HL] Config: $build_config"

zsh $UE_ROOT/Engine/Build/BatchFiles/RunUAT.command BuildCookRun \
    -project="$HL_UPROJECT" -noP4 -platform=Mac -clientconfig="$build_config" \
    -cook -allmaps -build -stage -pak -archive -partialgc -prereqs \
    -archivedirectory="$HL_PROJECT_DIR/Packaged"
