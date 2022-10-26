echo "[HL] Fixing up git..."
git config --global core.quotepath false

echo "[HL] Building Engine and Dev sample project..." && \
bash $UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun -project=Samples/StarterContent/StarterContent.uproject -platform=Linux -clientconfig=Development -build && \
echo "[HL] Building Engine and Shipping sample project..." && \
bash $UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun -project=Samples/StarterContent/StarterContent.uproject -platform=Linux -clientconfig=Shipping -build
