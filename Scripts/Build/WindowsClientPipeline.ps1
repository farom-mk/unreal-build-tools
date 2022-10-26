If (-not (Test-Path $env:UE_ROOT\Engine)) {
    Write-Error "Invalid path in UE_ROOT envvar."
    exit 1
}
If (-not (Test-Path $env:HL_UPROJECT)) {
    Write-Error "Invalid path in HL_UPROJECT envvar."
    exit 1
}
If (-not (Test-Path $env:HL_PROJECT_DIR\Source)) {
    Write-Error "Invalid path in HL_PROJECT_DIR envvar."
    exit 1
}
# If ($null -eq $env:VARIANT) {
#     Write-Error "VARIANT is undefined"
#     exit 1
# } Else {
#     If (-not (Test-Path "$env:HL_PROJECT_DIR\.hl\Data\DefaultEngine_$env:VARIANT.ini")) {
#         Write-Error "Variant '$env:VARIANT' is unsupported, '$env:HL_PROJECT_DIR\.hl\Data\DefaultEngine_$env:VARIANT.ini' not found."
#         exit 1
#     }
# }

$dotlabel = ""
if ($env:BUILD_LABEL) {
    $dotlabel = ".$env:BUILD_LABEL"
}

Set-Location $env:HL_PROJECT_DIR
$commit= git rev-parse --short HEAD
$env:HL_COMMIT = $commit
$start_date= Get-Date -Format "yyyy-MM-dd.HH-mm-ss"

$out_name= "Windows$dotlabel.client.$commit.$start_date"
$out_dir= "$env:HL_PROJECT_DIR\Out\$out_name"
New-Item -ItemType Directory -Force -Path $out_dir

If (Test-Path "$env:HL_PROJECT_DIR\Packaged\Windows") {
    Remove-Item $env:HL_PROJECT_DIR\Packaged\Windows -Recurse
}

.$env:HL_PROJECT_DIR\.hl\Build\Win\BuildProject.ps1
.$env:HL_PROJECT_DIR\.hl\Build\Win\PackageClient.ps1

If (Test-Path "$env:HL_PROJECT_DIR\Packaged\Windows\HeavenLandUnreal.exe") {
    Write-Output "[HL] Windows build finished kinda successful. Zipping it up."
    

    If (Test-Path $env:HL_PROJECT_DIR\Packaged\Windows\HeavenLandUnreal\Binaries\Win64\HeavenLandUnreal.pdb) {
        Remove-Item $env:HL_PROJECT_DIR\Packaged\Windows\HeavenLandUnreal\Binaries\Win64\HeavenLandUnreal.pdb
    }

    # New-Item -Path "$env:HL_PROJECT_DIR\Packaged\Windows\HeavenLandUnreal\Saved\Config\Windows" -ItemType Directory -Force
    # Copy-Item -Path "$env:HL_PROJECT_DIR\.hl\Data\Game_PackagedClient.ini" -Destination "$env:HL_PROJECT_DIR\Packaged\Windows\HeavenLandUnreal\Saved\Config\Windows\Game.ini"

    7z a -mx1 "$out_dir\$out_name.7z" $env:HL_PROJECT_DIR\Packaged\Windows
    Write-Output "$out_dir\$out_name.7z" > latest_build.txt
    Write-Output "$env:BUILD_LABEL" > latest_build_tag.txt

    exit 0
} Else {
    Write-Output "[HL] Windows build kinda failed. Copying logs."
    Copy-Item -Path "C:\UnrealEngine\Engine\Programs\AutomationTool\Saved\Logs\*" -Destination $out_dir
    If (Test-Path latest_build.txt) { Remove-Item latest_build.txt }
    If (Test-Path latest_build_label.txt) { Remove-Item latest_build_label.txt }
    exit 1
}
