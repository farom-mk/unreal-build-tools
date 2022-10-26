if [[ ! -f $HL_PROJECT_DIR/slack_hook.txt ]]; then
    echo "[HL] slack_hook not defined. not sending notification."
    exit 0
fi

cd $HL_PROJECT_DIR

commit=$(git rev-parse --short HEAD)

latest_build_path=$(cat latest_build.txt)

if [[ -z "$latest_build_path" ]]; then
    echo "[HL] Latest build path is undefined. Not sending notification."
    exit 0
fi

filename=$(basename $latest_build_path)
link="https://storage.googleapis.com/hl_builds/$filename"

label=$(cat latest_build_tag.txt)
if [[ -n "$label" ]]; then
    label=" [${label:u}]" # zsh uppercase modifier
fi

body="{\"channel\": \"#hl-game-dev\", \"username\": \"Mac Buildmachine\", \"text\": \"New Mac client build$label: <$link|$link> [ commit $commit ]\", \"icon_emoji\": \":hammer_and_wrench:\"}"

hook=$(cat $HL_PROJECT_DIR/slack_hook.txt)

/usr/bin/curl --header "Content-Type: application/json" --request POST --data "$body" $hook
