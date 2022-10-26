Param(
    [Parameter(Mandatory=$False)][string]$MapName = "/Game/Maps/HL_World/DownTown_4",
    [Parameter(Mandatory=$False)][string]$Port = "7701",
    [Parameter(Mandatory=$False)][string]$Params = '-game -server -NoHotReload -NoLiveCoding'
)

If (-not $env:UE_ROOT) {
    Write-Output "Sorry, UE_ROOT envvar not defined."
    exit 1
}
If (-not $env:HL_UPROJECT) {
    Write-Output "Sorry, HL_UPROJECT envvar not defined."
    exit 1
}
If (-not $env:HL_PROJECT_DIR) {
    Write-Output "Sorry, HL_PROJECT_DIR envvar not defined."
    exit 1
}

$shortmapname = Split-Path $MapName -Leaf

$logdir = "$env:HL_PROJECT_DIR\.hl\Development"
$devlog = "$logdir\dev.log"
$uelog = "$logdir\Logs\$shortmapname.log"

$date = Get-Date -UFormat "%Y.%m.%d-%H.%M.%S"

$parameters = "$Params PORT=$Port LOGTIMES abslog=$uelog" # 

echo "devlog - $devlog"

"[$date][start] Server $MapName -> $Port      (Params: $parameters)" >> $devlog

$proc = $null

try {
    If (Test-Path -Path $uelog ) {
        $dir = Split-Path -Path $uelog -Parent
        $leaf = Split-Path -Path $uelog -Leaf
        $noext = $leaf.Substring(0, $leaf.Length - (".log").Length)
        Move-Item -Path $uelog -Destination "$dir\$noext-backup-$date.log"
    }
    
    $proc = Start-Process -WorkingDirectory $env:UE_ROOT\Engine\Binaries\Win64 `
        -FilePath $env:UE_ROOT\Engine\Binaries\Win64\UnrealEditor.exe -NoNewWindow `
        -PassThru -ArgumentList "$env:HL_UPROJECT $MapName $parameters"
    
    Wait-Process -InputObject $proc
}
catch {
    echo $Error
}
finally {
    Stop-Process -InputObject $proc
    "[$date][stop] Server $MapName -> $Port" >> $devlog
}
