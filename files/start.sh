#!/bin/ash
echo ""
echo "Container Started in MODE $MODE"
echo "ls"
ls
pwd
echo ""

if [ "$MODE" -eq "1" ]; then
    echo "Setup mode..."
    #cat setup.sh
    ./setup.sh
else
    echo "Starting OHOL server"
    cd volume/OneLife/server
    ./OneLifeServer
fi

