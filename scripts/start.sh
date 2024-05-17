#!/bin/bash

echo "Container Started in MODE $MODE"
echo "HERE $USE_PORT_SERVER"



python test.py &

if [ "$MODE" -eq "1" ]; then
    echo "Setup mode..."
    echo "We received versions, SERVER_VERSION=$SERVER_VERSION, SERVER_DATA_VERSION=$SERVER_DATA_VERSION and GEMS_VERSION=$GEMS_VERSION"
    ./setup.sh
else
    echo "Starting OHOL server"
    cd volume/OneLife/server
    ./OneLifeServer
fi

