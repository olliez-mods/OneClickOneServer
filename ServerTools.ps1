# TODO Let user choose option
# TODO Allow user to copy world files / import world files (overwrite)
# TODO Let user see all settings (grouped by catagory) and edit each one
# let user see specifics about each setting and see all related commands (eg. EVE X, EVE Y, FORCE EVE)
# let user see logs and server specific details.

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

$VolumePath = $iniConfig['VolumePath']
echo "Loaded VolumePath:$VolumePath"
echo "  (Full Path [$PWD\$VolumePath])"

# =======================

# Test path existence for the folders and files below
$volumeFolderExists = Test-Path "$PWD/$VolumePath"
$minorGemsExist = Test-Path "$PWD/$VolumePath/minorGems"
$OneLifeExists = Test-Path "$PWD/$VolumePath/OneLife"
$OneLifeData7Exists = Test-Path "$PWD/$VolumePath/OneLifeData7"
$OneLifeServerExists = Test-Path "$PWD/$VolumePath/OneLife/server/"
$OneLifeServerAppExists = Test-Path "$PWD/$VolumePath/OneLife/server/OneLifeServer" # file

echo ""
echo ""

# If any of them dont exist, throw an error message and exit
if(-not $volumeFolderExists){
    echo "Volume folder was not found, make sure you have built the server before using ServerTools"
    Read-Host "."
    exit
}
if((-not $minorGemsExist) -or (-not $OneLifeExists) -or (-not $OneLifeData7Exists)){
    echo "One or all of the main folders (OneLife/MinorGems/OneLifeData7) was not found, make sure that the server built successfully before using ServerTools"
    Read-Host "."
    exit
}
if(-not $OneLifeServerExists){
    echo "The server folder (./$VolumePath/OneLife/server) cannot be found, make sure that the server built successfully before using ServerTools"
    Read-Host "."
    exit
}
if(-not $OneLifeServerAppExists){
    echo "Could not find OneLifeServer application (./$VolumePath/OneLife/server/OneLifeServer), make sure that the server built successfully before using ServerTools"
    Read-Host "."
    exit
}

# Menu
function Print-Menu {
    echo ""
    echo ""
    echo ""
    echo "Welcome to ServerTools by Oliver, please choose an option:"
    echo "1: Copy World Files"
    echo "2: Import World Files"
    echo "3: View server settings"
}

Clear-Host
Print-Menu
$option = Read-Host ":"


echo $option
$hi = Read-Host "hi"