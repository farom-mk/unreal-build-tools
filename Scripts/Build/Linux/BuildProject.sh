echo "[HL] Building client modules and recompiling editor..." && \
bash $UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun -project=$HL_UPROJECT -noP4 -platform=Linux -servertargetplatform=Linux -clientconfig=Shipping -serverconfig=Development -build -editorrecompile && \
echo "[HL] Building server modules and recompiling editor..." && \
bash $UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun -project=$HL_UPROJECT -noP4 -platform=Linux -servertargetplatform=Linux -server -noclient -clientconfig=Shipping -serverconfig=Development -build -editorrecompile

