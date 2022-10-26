
$generatorPath = "$env:HL_PROJECT_DIR\.hl\Tools\LaunchpadManifestGenerator\Launchpad.Utilities.exe"

If (-not (Test-Path $generatorPath)) {
    Write-Output "[HL][Manifest] Cannot find \.hl\Tools\LaunchpadManifestGenerator\Launchpad.Utilities.exe. Will not generate manifest."
    exit 1
}

If (Test-Path latest_build.txt) {
    $latest_build_path = Get-Content latest_build.txt
    If (Test-Path $latest_build_path) {
        Write-Output "[HL][Manifest] Generating manifest for the latest build"
        
        $manifestOutDir = Split-Path -Path $latest_build_path -Parent
        $manifestOutDir = "$manifestOutDir\Manifest"

        $buildFilesDir = "$env:HL_PROJECT_DIR\Packaged\Windows"

        New-Item -Path $manifestOutDir -Force -ItemType Directory

        mono $generatorPath -b -d $buildFilesDir -m Game
    } else {
        Write-Output "[HL][Manifest] Sorry, latest_build.txt contains shit."
    }
} else {
    Write-Output "[HL][Manifest] No latest_build.txt. No manifest."
}
