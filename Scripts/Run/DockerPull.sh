if [ -z "$HL_LOG_DIR" ]; then
    echo "[HL] Error: \$HL_LOG_DIR is undefined. Aborting."
    exit
fi
if [ -z "$HL_GCP_TAG" ]; then
    echo "[HL][Containers] Error: \$HL_GCP_TAG is undefined. Aborting."
    exit
fi

docker pull $HL_GCP_TAG
