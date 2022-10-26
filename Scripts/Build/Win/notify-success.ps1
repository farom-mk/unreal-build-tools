If (-not (Test-Path $env:HL_PROJECT_DIR\slack_hook.txt) ) {
    Write-Output "[HL] slack_hook not defined. not sending notification."
    exit 0
}

Set-Location $env:HL_PROJECT_DIR

$commit= git rev-parse --short HEAD
$latest_build_path= Get-Content latest_build.txt
$filename = Split-Path $latest_build_path -leaf
$link = "https://storage.googleapis.com/hl_builds/$filename"

$hook = Get-Content $env:HL_PROJECT_DIR\slack_hook.txt

$label= Get-Content latest_build_tag.txt
if ($label.Length -gt 0) {
    $label = $label.ToUpper()
    $label=" [$label]"
}

$body = '{2}"channel": "#hl-game-dev", "username": "Windows Buildmachine", "text": "New Windows client build{4}: <{0}|{0}> [ commit {1} ]", "icon_emoji": ":hammer_and_wrench:"{3}' -f $link,$commit,"{","}",$label

Invoke-WebRequest -Method Post -Body $body -ContentType 'application/json' -Uri $hook -UseBasicParsing
