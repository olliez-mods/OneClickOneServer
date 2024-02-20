#!/bin/bash
echo ""
echo "Container Started in MODE $MODE"

if [ "$MODE" -eq "0" ]; then
    echo "Starting OHOL server"
    cd volume/OneLife/server
    ./OneLifeServer
fi

if [ "$MODE" -eq "1" ]; then
    echo "Setup mode..."
    ./setup.sh
fi