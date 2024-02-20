# Original Script derived from danomation: https://github.com/danomation/onehouroneclick/tree/main
# Improved by ME, https://github.com/olliez-mods

# Run with max perms available to the user, May cause ignorable error
echo "Setting perms, ignore any error"
Set-ExecutionPolicy -Scope CurrentUser Unrestricted -ErrorAction SilentlyContinue
echo ""
echo ""
echo ""


# ===== Import config variable =====

$iniFilePath = "ContainerConfig.ini"

# Create an empty hashtable to store key-value pairs
$iniConfig = @{}
echo "Loading Config file [$iniFilePath]..."

# Read the .ini file line by line
Get-Content -Path $iniFilePath | ForEach-Object {
    # Remove leading and trailing whitespace
    $line = $_.Trim()
    
    # Skip empty lines and comments
    if (-not [string]::IsNullOrEmpty($line) -and $line -notmatch '^\s*#') {
        # Extract key and value
        $key, $value = $line -split '\s*=\s*', 2

        # Add key-value pair to the hashtable
        $iniConfig[$key] = $value
    }
}

# Load data into variable
$port = $iniConfig['Port']
$PersistentServer = $iniConfig['PersistentServer']
$VolumePath = $iniConfig['VolumePath']

echo "Loaded port=$port"
echo "Loaded PersistentServer=$PersistentServer"
echo "Loaded VolumePath:$VolumePath"
echo "  (Full Path [$PWD\$VolumePath])"

$docker = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
# Is docker running? If it's not start it
if(-not $docker){
    echo ""
    echo "Docker Desktop not running, attempting to start it automatically"
    start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Minimized
    Read-Host "Press enter once Docker Desktop starts (If it doesn't start, do it maunaly)"
}

echo ""

# =====
    # By default, delete the volume
    $inp = ""

    # Get the items within the volume folder
    $items = Get-ChildItem -Path $folderPath

    # If volume folder exists
    if (Test-Path "$PWD/$VolumePath" -PathType Container) {
        # If the folder has items in it, ask the user if we want to clear items, or build with existing files
        if ($items.Count -ne 0) {
            echo ""
            echo "The provided volume folder [$PWD\$VolumePath] has existing files in it."
            echo "- You can clear all files in this folder and make a fresh build (Reccomended)"
            echo "Warning: This will delete any world files, so make a backup if nessasary"
            echo ""
            echo "- You can build the server using existing files in the volume, withought cloning or making"
            echo "1. Clear"
            echo "2. Use Existing"
            echo "3. Quit"
            $inp = Read-Host "(1/2/q)"

            if ($inp -eq "1") {
            }elseif ($inp -eq "2") {

            }else {
                echo ""
                Read-Host "Exiting Build script, Press Eneter to coninue"
                exit
            }
        }
    # The folder doesn't exist, so we want to build from scratch and enter setup mode
    }else{
        $inp = "1"

    }


# First delete old ocos_server image and container if it exists
echo ""
echo "Removing Imag (name=ocos_server) and Container (name=ocos) if they exist"
docker rmi -f ocos_server
docker rm -f ocos
echo ""

echo ""
echo "Building Docker Image..."

# Rebuild image
docker build -t ocos_server .
echo ""

# If the user has said they want to clear volume and rebuild from scratch, call container in setup mode
if ($inp -eq "1" ){
    echo ""
    echo "Deleting Folder [$PWD\$VolumePath]"
    Remove-Item -Path "$PWD\$VolumePath" -Recurse -Force -ErrorAction SilentlyContinue
    echo "Creating Folder [$PWD\$VolumePath]"
    New-Item -ItemType Directory -Name "$VolumePath" > $nul

    echo ""
    echo ""
    echo "Starting container in setup mode..."

    $AbsVolumePaths = "$PWD" + "\" + "$VolumePath" + "\:/files/volume"

    # then start container in setup mode (MODE env is set to 1)
    docker run --name=ocos -it -v $AbsVolumePaths -e "MODE=1" ocos_server

    echo ""
    echo ""
}

echo ""
Read-Host -Prompt "Program ended, press Enter to continue"