#!/bin/bash

echo ""
echo "Container Started in MODE $MODE"

if [ "$MODE" -eq "1" ]; then
    echo "Setup mode..."
    #cat setup.sh
    ./setup.sh
else
    echo "Starting OHOL server"
    cd volume/OneLife/server
    ./OneLifeServer
fi

