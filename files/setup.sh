#!/bin/sh

# Move into volume
cd volume

echo ""
echo "Cloning: minorGems, OneLife, OneLifeData7, this may take a while..."
echo ""

git clone https://github.com/jasonrohrer/minorGems.git	
git clone https://github.com/jasonrohrer/OneLife.git
git clone https://github.com/jasonrohrer/OneLifeData7.git

echo ""
echo ""
echo "Initital Cloning complete, fetching tags..."
echo ""

cd minorGems
git fetch --tags
latestTaggedVersion=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
git checkout -q OneLife_v$latestTaggedVersion


cd ../OneLife
git fetch --tags
latestTaggedVersionA=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
git checkout -q OneLife_v$latestTaggedVersionA


cd ../OneLifeData7
git fetch --tags
latestTaggedVersionB=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
git checkout -q OneLife_v$latestTaggedVersionB


cd ..

cd OneLife
git pull --tags
git checkout OneLife_liveServer
cd ..

echo ""
echo ""
echo "Done, building..."
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
echo "Done building server with version v$serverVersion"
echo