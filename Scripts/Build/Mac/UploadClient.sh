
if [[ -f latest_build.txt ]]; then 
    latest_build_path=$(cat latest_build.txt)
    if [[ -f $latest_build_path ]]; then 
        echo "[HL][Upload] Hooray, uploading latest_build to the gs"
        /Users/administrator/Downloads/google-cloud-sdk/bin/gsutil cp $latest_build_path gs://hl_builds
    fi
else
    echo "[HL][Upload] No latest_build.txt. No upload."
fi
