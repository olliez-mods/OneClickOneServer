#!/bin/bash

echo ""
echo "Container Started in MODE $MODE"
echo "We received versions, SERVER_VERSION=$SERVER_VERSION and GEMS_VERSION=$GEMS_VERSION"


if [ "$MODE" -eq "1" ]; then
    echo "Setup mode..."
    #cat setup.sh
    ./setup.sh
else
    echo "Starting OHOL server"
    cd volume/OneLife/server
    ./OneLifeServer
fi

