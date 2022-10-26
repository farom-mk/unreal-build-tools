if [ -z "$HL_GCP_TAG" ]; then
    echo "[HL][Containers] Error: \$HL_GCP_TAG is undefined. Aborting."
    exit
fi


mapnum=2
levels=("LobbyRoom", "Block_City_4")
umaps=("LobbyRoom", "HL_World/Block_City_4")
ports=(7000, 7010)

for i in {1..$mapnum}; do
    docker volume create logs_${levels[$i]}
    docker run -p ${ports[$i]}:7777/udp -p ${ports[$i]}:7777/tcp -v "logs_${levels[$i]}:/Logs" $HL_GCP_TAG /Game/Maps/${umaps[$i]} -abslog=/Logs
done
