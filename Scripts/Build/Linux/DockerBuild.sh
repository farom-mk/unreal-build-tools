
if [ -z "$HL_IMAGE_NAME" ]; then
    echo "[HL][Containers] Error: \$HL_IMAGE_NAME is undefined. Aborting."
    exit 1
fi
if [ -z "$HL_GCP_TAG" ]; then
    echo "[HL][Containers] Error: \$HL_GCP_TAG is undefined. Aborting."
    exit 1
fi

tag=""
if [ -n "$BUILD_LABEL" ]; then
    tag=":$BUILD_LABEL"
fi

echo "[HL] Building server container with label/tag '$tag'"

cd "$HL_PROJECT_DIR/Packaged/LinuxServer"
cp "$HL_PROJECT_DIR/.hl/Build/Docker/.dockerignore" .

if [ -z "$COMMIT" ]; then
    echo "[HL] Warning: \$COMMIT variable is unset. Trying to set it using 'git rev-parse --short HEAD'"
    COMMIT="$(git rev-parse --short HEAD)"
    echo "[HL] result = '$COMMIT'"

    if [[ $COMMIT =~ ^[a-f0-9]*$ ]]
    then
        echo "[HL] result is a git hash. saving it."
    else
        echo "[HL] could not detect commit; result is not a git hash."
        COMMIT=""
    fi
fi

if [ -z "$COMMIT" ]; then 
    echo "[HL] Pushing $HL_IMAGE_NAME$tag to $HL_GCP_TAG" 
    docker build -t $HL_IMAGE_NAME$tag -f "$HL_PROJECT_DIR/.hl/Build/Docker/Dockerfile" . && \
    docker tag $HL_IMAGE_NAME$tag $HL_GCP_TAG$tag && \
    docker push $HL_GCP_TAG$tag
else
    echo "[HL] Pushing $HL_IMAGE_NAME$tag:$COMMIT to $HL_GCP_TAG" 
    docker build -t $HL_IMAGE_NAME$tag -t $HL_IMAGE_NAME:$COMMIT -f "$HL_PROJECT_DIR/.hl/Build/Docker/Dockerfile" . && \
    docker tag $HL_IMAGE_NAME$tag $HL_GCP_TAG$tag && \
    docker tag $HL_IMAGE_NAME$tag $HL_GCP_TAG:$COMMIT && \
    docker push $HL_GCP_TAG$tag && \
    docker push $HL_GCP_TAG:$COMMIT
fi
