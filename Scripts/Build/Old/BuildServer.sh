UE_BATCHFILES_DIR="/home/buildmachine/UnrealEngine/Engine/Build/BatchFiles"
HL_UPROJECT="/home/buildmachine/heavenlandproject/HeavenLandUnreal.uproject"
HL_OUTPUT_DIR="/home/buildmachine/heavenlandproject/Packaged"

echo "Starting BuildLinuxServer.sh"
cd $UE_BATCHFILES_DIR

./RunUAT.sh -ScriptsForProject=$HL_UPROJECT \
	Turnkey -command=VerifySdk -platform=Linux -UpdateIfNeeded \
	-project=$HL_UPROJECT \
	BuildCookRun -nop4 -utf8output -nocompileeditor -skipbuildeditor -cook \
	-project=$HL_UPROJECT \
	-target=HeavenLandUnrealServer -platform=Linux -ddc=DerivedDataBackendGraph \
	-archivedirectory=$HL_OUTPUT_DIR -serverconfig=Development \
	-stage -archive -package -build -pak -prereqs -server -noclient -nocompile -unattended

