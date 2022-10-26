@echo off
setlocal

cd /d D:/UnrealEngine-5.0.3-release/Engine/Build/BatchFiles

D:/UnrealEngine-5.0.3-release/Engine/Build/BatchFiles/RunUAT.bat -ScriptsForProject=D:/Heavenland/src/HeavenLandUnreal.uproject Turnkey -command=VerifySdk -platform=Win64 -UpdateIfNeeded -EditorIO -EditorIOPort=52496 -project=D:/Heavenland/src/HeavenLandUnreal.uproject BuildCookRun -nop4 -utf8output -nocompileeditor -skipbuildeditor -cook -project=D:/Heavenland/src/HeavenLandUnreal.uproject -target=HeavenLandUnrealServer -unrealexe=D:\UnrealEngine-5.0.3-release\Engine\Binaries\Win64\UnrealEditor-Cmd.exe -platform=Win64 -ddc=DerivedDataBackendGraph -stage -archive -package -build -pak -prereqs -archivedirectory=D:/Heavenland/out -server -noclient -serverconfig=Development -nocompile -unattended

endlocal
