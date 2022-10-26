# A ton of checks to make the pipeline fool-proof 
errors=""

#
# env setup

if [ ! -f "$HL_UPROJECT" ]; then
    errors="$errors[HL] > Env: file '$HL_UPROJECT' specified in HL_UPROJECT envvar does not exist\n"
fi
if [ ! -d "$HL_PROJECT_DIR" ]; then
    errors="$errors[HL] > Env: directory '$HL_PROJECT_DIR' specified in HL_PROJECT_DIR envvar does not exist\n"
fi
if [ ! -f "$UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh" ]; then
    errors="$errors[HL] > Env: directory specified as unreal root in UE_ROOT envvar is invalid ($UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh not found)\n"
fi
# if ! command -v 7z > /dev/null; then
#     errors="$errors[HL] > Env: 7z is not installed\n"
# fi

if [ -z "$errors" ]; then
    # Check env
    if zsh "$UE_ROOT/Engine/Build/BatchFiles/RunUAT.command" -ScriptsForProject="$HL_UPROJECT" Turnkey -command=VerifySdk -platform=Mac -UpdateIfNeeded  -project="$HL_UPROJECT"; then 
        echo "[HL] sdk ok"
    else
        errors="$errors \n [HL] > Turnkey VerifySDK failed."
    fi
fi

if [ "$errors" ]; then
    echo "[HL] Sorry, cannot start pipeline. Invalid environment setup:"
    echo "$errors"
    exit 1
fi

#
# build params
echo
echo "[HL] Env OK."
echo

if [ "$errors" ]; then
    echo "[HL] Sorry, cannot start build. Invalid build params:"
    echo "$errors"
    exit 1
fi

cd "$HL_PROJECT_DIR"

if [ -n "$COMMIT" ]; then
    COMMIT=".$COMMIT"
else
    echo "[HL] Warning: \$COMMIT variable is unset. Trying to set it using 'git rev-parse --short HEAD'"
    COMMIT="$(git rev-parse --short HEAD)"
    echo "[HL] result = '$COMMIT'"

    if [[ $COMMIT =~ ^[a-f0-9]*$ ]]
    then
        echo "[HL] result is a git hash. saving it."
        COMMIT=".$COMMIT"
    else
        echo "[HL] could not detect commit; result is not a git hash."
        COMMIT=""
    fi
fi

echo
echo "[HL] Build params OK. Starting build."
echo

start_date="$(date +%Y-%m-%d.%H-%M)"

dotlabel=".$BUILD_LABEL"
if [[ -z "$DEBUG_LABEL" ]]; then
    dotlabel=""
fi

out_name="Mac$dotlabel.client$COMMIT.$start_date"
out_dir="$HL_PROJECT_DIR/Out/$out_name"
mkdir -p "$out_dir"

if [[ -d "$HL_PROJECT_DIR/Packaged/Mac" ]]; then
    rm -rf "$HL_PROJECT_DIR/Packaged/Mac"
fi

cd "$HL_PROJECT_DIR"

exitcode=0

if  zsh "$HL_PROJECT_DIR/.hl/Build/Mac/BuildEngine.sh" && \
    # zsh "$HL_PROJECT_DIR/.hl/Build/Mac/BuildProject.sh" && \
    zsh "$HL_PROJECT_DIR/.hl/Build/Mac/PackageClient.sh"; then
    
    echo
    echo "[HL] Build kinda successful. Zipping it up."
    echo

    rm $HL_PROJECT_DIR/Packaged/Mac/HeavenLandUnreal.app/UE/HeavenLandUnreal.dSYM
    rm $HL_PROJECT_DIR/Packaged/Mac/*.dSYM

    /opt/homebrew/bin/7z a -mx1 "$out_dir/$out_name.7z" "$HL_PROJECT_DIR/Packaged/Mac/"
    
    echo "$out_dir/$out_name.7z" > latest_build.txt
    echo "$BUILD_LABEL" > latest_build_tag.txt
    
else
    echo
    echo "[HL] Build kinda failed"
    echo
    cp -r "$HOME/Library/Logs/Unreal Engine/LocalBuildLogs/" $out_dir

    echo "" > latest_build.txt
    echo "" > latest_build_tag.txt

    exitcode=1
fi

exit $exitcode

