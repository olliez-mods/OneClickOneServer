#!/bin/bash

# Move into volume
cd volume

echo ""
echo "Cloning: minorGems, OneLife, OneLifeData7, this may take a while..."
echo ""

git clone https://github.com/jasonrohrer/minorGems.git
echo ""
git clone https://github.com/jasonrohrer/OneLife.git
echo ""
git clone https://github.com/jasonrohrer/OneLifeData7.git

echo ""
echo ""
echo "Initial Cloning complete, fetching tags..."
echo ""

# MINOR GEMS
cd minorGems
git fetch --tags

latestTaggedVersion=$GEMS_VERSION
# Check if the version is "latest"
if [ "$GEMS_VERSION" == "latest" ]; then
    latestTaggedVersion=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
fi
echo "checking out MinorGems with version v$latestTaggedVersion"
git checkout -q OneLife_v$latestTaggedVersion


# ONE LIFE
cd ../OneLife
git fetch --tags

# Check if the version is "latest"
latestTaggedVersionA=$SERVER_VERSION
if [ "$SERVER_VERSION" == "latest" ]; then
    latestTaggedVersionA=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
fi
echo "checking out OneLife with version v$latestTaggedVersionA"
git checkout -q OneLife_v$latestTaggedVersionA


# ONE LIFE DATA
cd ../OneLifeData7
git fetch --tags

# Check if the version is "latest"
latestTaggedVersionB=$SERVER_DATA_VERSION
if [ "$SERVER_DATA_VERSION" == "latest" ]; then
    latestTaggedVersionB=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
fi
echo "checking out OneLifeData7 with version v$latestTaggedVersionB"
git checkout -q OneLife_v$latestTaggedVersionB

echo ""
echo ""

cd ..

cd OneLife
git pull --tags
git checkout OneLife_liveServer
cd ..

echo ""
echo ""
echo "Done, cloning..."
echo ""

cd OneLife/server
./configure 1
make
ln -s ../../OneLifeData7/objects .
ln -s ../../OneLifeData7/transitions .
ln -s ../../OneLifeData7/categories .
ln -s ../../OneLifeData7/tutorialMaps .
ln -s ../../OneLifeData7/dataVersionNumber.txt .
ln -s ../../OneLifeData7/contentSettings . # FIX FOR BIOM BUG

git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=2 refs/tags | grep "OneLife_v" | sed -e 's/OneLife_v//' > serverCodeVersionNumber.txt


serverVersion=`cat serverCodeVersionNumber.txt`

echo
echo
echo "Done building server"