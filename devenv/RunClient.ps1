Param(
    [Parameter(Mandatory=$False)][string]$MapName = "/Game/Maps/LobbyRoom",
    [Parameter(Mandatory=$False)][string]$Params = '-game -SessionName="Play in Standalone Game" -NoHotReload -NoLiveCoding'
)

If (-not $env:UE_ROOT) {
    echo "Sorry, UE_ROOT envvar not defined."
    exit 1
}
If (-not $env:HL_UPROJECT) {
    echo "Sorry, HL_UPROJECT envvar not defined."
    exit 1
}
If (-not $env:HL_PROJECT_DIR) {
    echo "Sorry, HL_PROJECT_DIR envvar not defined."
    exit 1
}
$shortmapname = Split-Path $MapName -Leaf

$logdir = "$env:HL_PROJECT_DIR\.hl\Development"
$devlog = "$logdir\dev.log"
$uelog = "$logdir\Logs\Client.log"

$date = Get-Date -UFormat "%Y.%m.%d-%H.%M.%S"

$parameters = "$Params ABSLOG=$uelog LOGTIMES"

echo "devlog - $devlog"

"[$date][start] Client $MapName      (Params: $parameters)" >> $devlog

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
    "[$date][stop] Client $MapName" >> $devlog
}
