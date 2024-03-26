# TODO Let user choose option
# TODO make function to verify existence of needed folders and 
# files (see if we have a volume, if servers been built, etc.)
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

$volumeFolderExists = Test-Path "$PWD/$VolumePath"
$minorGemsExist = Test-Path "$PWD/$VolumePath/minorGems"
$OneLifeExists = Test-Path "$PWD/$VolumePath/OneLife"
$OneLifeData7Exists = Test-Path "$PWD/$VolumePath/OneLifeData7"
$OneLifeServerExists = Test-Path "$PWD/$VolumePath/OneLife/server/"
$OneLifeServerAppExists = Test-Path "$PWD/$VolumePath/OneLife/server/OneLifeServer"

echo $volumeFolderExists
echo $minorGemsExist
echo $OneLifeExists
echo $OneLifeData7Exists
echo $OneLifeServerExists
echo $OneLifeServerAppExists


$hi = Read-Host "hi"
