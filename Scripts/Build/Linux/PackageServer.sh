# intentionally only Development configuration

echo "[HL] Cooking and packaging server..."
bash $UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun -project=$HL_UPROJECT -noP4 -platform=Linux \
    -clientconfig=Shipping -serverconfig=Development \
    -server -noclient \
    -cook -allmaps  -build -stage -pak -archive -partialgc \
    -archivedirectory=$HL_PROJECT_DIR/Packaged
