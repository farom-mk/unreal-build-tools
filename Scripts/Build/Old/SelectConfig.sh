if [ -f "$1" ];
then
    echo "Error: config file does not exist";
    exit 1;
fi;

HL_CONFIGFILE="/home/buildmachine/heavenlandproject/Config/DefaultEngine.ini"

cp $1 $HL_CONFIGFILE
