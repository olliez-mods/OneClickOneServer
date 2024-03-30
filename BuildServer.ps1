# Original Script derived from danomation: https://github.com/danomation/onehouroneclick/tree/main
# Improved by ME, https://github.com/olliez-mods



# ===== Import config variable =====

$iniFilePath = "ContainerConfig.ini"

# Create an empty hashtable to store key-value pairs
$iniConfig = @{}
Write-Output "Loading Config file [$iniFilePath]..."

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
$ServerVersion = $iniConfig['ServerVersion']
$ServerDataVersion = $iniConfig['ServerDataVersion']
$MinorGemsVersion = $iniConfig['MinorGemsVersion']

Write-Output "Loaded port=$port"
Write-Output "Loaded PersistentServer=$PersistentServer"
Write-Output "Loaded VolumePath=$VolumePath"
Write-Output "  (Full Path [$PWD\$VolumePath])"
Write-Output "ServerVersion=$ServerVersion"
Write-Output "ServerDataVersion=$ServerDataVersion"
Write-Output "MinorGemsVersion=$MinorGemsVersion"

$docker = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
# Is docker running? If it's not start it
if(-not $docker){
    Write-Output ""
    Write-Output "Docker Desktop not running, attempting to start it automatically"
    start-Process -FilePath "C:/Program Files/Docker/Docker/Docker Desktop.exe" -WindowStyle Minimized
    Read-Host "Press enter once Docker Desktop starts (If it doesn't start, do it maunaly)"
}

Write-Output ""

# Verify that the given versions are valid (either a number or "latest")
$regexForVersion = "^latest$|^\d+$"
if(-not ($ServerVersion -match $regexForVersion)){
    Write-Output "ServerVersion:`"$ServerVersion`" is not an accepted format, is should be a number or `"latest`""
    Read-Host "Press enter"
    exit
}
if(-not ($MinorGemsVersion -match $regexForVersion)){
    Write-Output "MinorGemsVersion:`"$MinorGemsVersion`" is not an accepted format, is should be a number or `"latest`""
    Read-Host "Press enter"
    exit
}


# By default, don't delete the volume
$buildFromScratch = $false


# If volume folder exists
if (Test-Path "$PWD/$VolumePath" -PathType Container) {

    # Get the items within the volume folder
    $items = Get-ChildItem -Path "$PWD/$VolumePath"

    # If the folder has items in it, ask the user if we want to clear items, or build with existing files
    if ($items.Count -ne 0) {
        Write-Output ""
        Write-Output "The provided volume folder [$PWD\$VolumePath] has existing files in it."
        Write-Output "Would you like to clear all files in this folder and make a fresh build?"
        Write-Output "Warning: This will delete any world files, so make a backup if nessasary"
        $inp = Read-Host "Clear folder?(Y/N):"

        if ($inp -eq "Y" -Or $inp -eq "y") {
            $buildFromScratch = $true
        }else {
            Write-Output ""
            Read-Host "Exiting Build script, Press Eneter to coninue"
            exit
        }
    }
# The folder doesn't exist, so we want to build from scratch and enter setup mode
}else{
    $buildFromScratch = $true
}


# First delete old ocos_server image and container if it exists
Write-Output ""
Write-Output "Removing Image (name=ocos_server) and Container (name=ocos) if they exist"
docker rmi -f ocos_server
docker rm -f ocos
Write-Output ""

Write-Output ""
Write-Output "Building Docker Image..."

# Rebuild image
docker build -t ocos_server .
Write-Output ""

# If the user has said they want to clear volume and rebuild from scratch, call container in setup mode
if ($buildFromScratch){
    Write-Output ""
    Write-Output "Deleting Folder [$PWD\$VolumePath]"
    Remove-Item -Path "$PWD/$VolumePath" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Creating Folder [$PWD\$VolumePath]"
    New-Item -ItemType Directory -Name "$VolumePath" > $nul

    Write-Output ""
    Write-Output ""
    Write-Output "Starting container in setup mode..."

    $AbsVolumePaths = "$PWD" + "/" + "$VolumePath" + "/:/files/volume"

    # then start container in setup mode (MODE env is set to 1)
    docker run --name=ocos -it -v $AbsVolumePaths -e "MODE=1" -e "SERVER_VERSION=$ServerVersion" -e "GEMS_VERSION=$MinorGemsVersion" -e "SERVER_DATA_VERSION=$ServerDataVersion" ocos_server

    Write-Output ""
    Write-Output ""
}

Write-Output ""
Read-Host -Prompt "Program ended, press Enter to continue"