
If (Test-Path latest_build.txt) {
    $latest_build_path = Get-Content latest_build.txt
    If (Test-Path $latest_build_path) {
        Write-Output "[HL][Upload] Hooray, uploading latest_build to the gs"
        gsutil cp $latest_build_path gs://hl_builds
    } else {
        Write-Output "[HL][Upload] Sorry, latest_build.txt contains shit."
    }
} else {
    Write-Output "[HL][Upload] No latest_build.txt. No upload."
}
