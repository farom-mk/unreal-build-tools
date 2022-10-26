# This script searches pwd for a file called `notification_body.txt`
# and send it contents to all ids listed in the RECP array


if [ -z "$TGBOT_TOKEN" ]; then
    echo "Cannot send message: TGBOT_TOKEN env var is empty"
    exit 1
fi
if [ ! -f "notification_body.txt" ]; then
    echo "Cannot find notification_body.txt"
    exit 1
fi

RECP=( "211399446" )

host="https://api.telegram.org/bot"

url="$host$TGBOT_TOKEN/sendMessage"
message=$(<notification_body.txt)

for i in "${RECP[@]}"
do
    curl --data="{\"chat_id\": \"$i\", \"text\": \"Message from $HOSTNAME.\
    \
    $message\"}" 
done
