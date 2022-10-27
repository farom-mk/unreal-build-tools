If (-not (Test-Path $env:UE_ROOT\Engine)) {
    Write-Error "Invalid path in UE_ROOT envvar."
    exit 1
}
If (-not (Test-Path $env:UPROJECT)) {
    Write-Error "Invalid path in UPROJECT envvar."
    exit 1
}
If (-not (Test-Path $env:PROJECT_DIR\Source)) {
    Write-Error "Invalid path in PROJECT_DIR envvar."
    exit 1
}
If (-not (Test-Path $env:SCRIPTS_ROOT)) {
    Write-Error "Invalid path in SCRIPTS_ROOT envvar."
    exit 1
}

$dotlabel = ""
if ($env:BUILD_LABEL) {
    $dotlabel = ".$env:BUILD_LABEL"
}

Set-Location $env:PROJECT_DIR
$commit= git rev-parse --short HEAD
$env:COMMIT = $commit
$start_date= Get-Date -Format "yyyy-MM-dd.HH-mm-ss"

$out_name= "Windows$dotlabel.client.$commit.$start_date"
$out_dir= "$env:PROJECT_DIR\Out\$out_name"
New-Item -ItemType Directory -Force -Path $out_dir

If (Test-Path "$env:PROJECT_DIR\Packaged\Windows") {
    Remove-Item $env:PROJECT_DIR\Packaged\Windows -Recurse
}

.$env:SCRIPTS_ROOT\Scripts\Build\Win\BuildProject.ps1
.$env:SCRIPTS_ROOT\Scripts\Build\Win\PackageClient.ps1

If (Test-Path "$env:PROJECT_DIR\Packaged\Windows\*.exe") {
    Write-Output "[Farom] Windows build finished kinda successful. Zipping it up."
    

    # If (Test-Path $env:PROJECT_DIR\Packaged\Windows\HeavenLandUnreal\Binaries\Win64\HeavenLandUnreal.pdb) {
    #     Remove-Item $env:PROJECT_DIR\Packaged\Windows\HeavenLandUnreal\Binaries\Win64\HeavenLandUnreal.pdb
    # }

    # New-Item -Path "$env:HL_PROJECT_DIR\Packaged\Windows\HeavenLandUnreal\Saved\Config\Windows" -ItemType Directory -Force
    # Copy-Item -Path "$env:HL_PROJECT_DIR\.hl\Data\Game_PackagedClient.ini" -Destination "$env:HL_PROJECT_DIR\Packaged\Windows\HeavenLandUnreal\Saved\Config\Windows\Game.ini"

    7z a -mx1 "$out_dir\$out_name.7z" $env:PROJECT_DIR\Packaged\Windows
    Write-Output "$out_dir\$out_name.7z" > latest_build.txt
    Write-Output "$env:BUILD_LABEL" > latest_build_tag.txt

    exit 0
} Else {
    Write-Output "[Farom] Windows build kinda failed. Copying logs."
    Copy-Item -Path "C:\UnrealEngine\Engine\Programs\AutomationTool\Saved\Logs\*" -Destination $out_dir
    If (Test-Path latest_build.txt) { Remove-Item latest_build.txt }
    If (Test-Path latest_build_label.txt) { Remove-Item latest_build_label.txt }
    exit 1
}
