
#!/bin/bash

# Ensure required packages are installed
REQUIRED_PKGS=(git make gcc)
MISSING_PKGS=()
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v $pkg >/dev/null 2>&1; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -ne 0 ]; then
    echo "The following required packages are missing: ${MISSING_PKGS[*]}"
    echo "Please install the missing packages and re-run this script."
    exit 1
fi

# Clean up any previous clones
rm -rf minorGems
rm -rf OneLife
rm -rf OneLifeData7

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


# Get latest tag for each repo and prompt with actual version
cd minorGems
git fetch --tags
latestMinorGems=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
cd ../OneLife
latestOneLife=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
cd ../OneLifeData7
latestOneLifeData7=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
cd ..

read -p "Enter MinorGems version (latest is v$latestMinorGems): " GEMS_VERSION
GEMS_VERSION=${GEMS_VERSION:-$latestMinorGems}
read -p "Enter OneLife version (latest is v$latestOneLife): " SERVER_VERSION
SERVER_VERSION=${SERVER_VERSION:-$latestOneLife}
read -p "Enter OneLifeData7 version (latest is v$latestOneLifeData7): " SERVER_DATA_VERSION
SERVER_DATA_VERSION=${SERVER_DATA_VERSION:-$latestOneLifeData7}

# Patch file flow ==============================================
PATCH_FILE_FOUND=""
for f in *.patch; do
    if [ -f "$f" ]; then
        PATCH_FILE_FOUND="$f"
        break
    fi
done

APPLY_PATCH=false
PATCH_FILE=""
PATCH_TEMP=false

if [ -n "$PATCH_FILE_FOUND" ]; then
    read -p "Found patch file '$PATCH_FILE_FOUND'. Do you want to use this patch file? (y/n): " USE_FOUND_PATCH
    if [ "$USE_FOUND_PATCH" == "y" ] || [ "$USE_FOUND_PATCH" == "Y" ]; then
        PATCH_FILE="$PATCH_FILE_FOUND"
        APPLY_PATCH=true
    fi
fi

if [ "$APPLY_PATCH" = false ]; then
    read -p "Do you want to use a patch file? (y/n): " WANT_PATCH
    if [ "$WANT_PATCH" == "y" ] || [ "$WANT_PATCH" == "Y" ]; then
        read -p "Enter the path of the patch file: " PATCH_PATH
        if [ -f "$PATCH_PATH" ]; then
            PATCH_FILE="onelife_patch_temp.diff"
            cp "$PATCH_PATH" $PATCH_FILE
            if [ $? -ne 0 ]; then
                echo "Failed to copy patch file. Exiting."
                exit 1
            fi
            PATCH_TEMP=true
            APPLY_PATCH=true
            echo "Patch file copied successfully."
        else
            echo "Patch file not found. Exiting."
            exit 1
        fi
    fi
fi
# ==============================================================

# MINOR GEMS
cd minorGems
echo "checking out MinorGems with version v$GEMS_VERSION"
git checkout -q OneLife_v$GEMS_VERSION


# ONE LIFE
cd ../OneLife
echo "checking out OneLife with version v$SERVER_VERSION"
git checkout -q OneLife_v$SERVER_VERSION

if [ "$APPLY_PATCH" = true ]; then
    echo "Applying patch to OneLife..."
    git apply ../$PATCH_FILE
    if [ $? -ne 0 ]; then
        echo "Failed to apply patch. Exiting."
        # Clean up temp patch file if used
        if [ "$PATCH_TEMP" = true ]; then
            rm -f ../$PATCH_FILE
        fi
        exit 1
    fi
    echo "Patch applied successfully."
    # Clean up temp patch file if used
    if [ "$PATCH_TEMP" = true ]; then
        rm -f ../$PATCH_FILE
    fi
fi

# ONE LIFE DATA
cd ../OneLifeData7
echo "checking out OneLifeData7 with version v$SERVER_DATA_VERSION"
git checkout -q OneLife_v$SERVER_DATA_VERSION

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
cd ../..

# Create run script
rm -f run
echo "#!/bin/bash" > run
echo cd OneLife/server >> run
echo ./OneLifeServer >> run
chmod +x run

echo
echo
echo "Done building server"