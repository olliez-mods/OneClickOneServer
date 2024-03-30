# Original Script was derived from danomation: https://github.com/danomation/onehouroneclick/tree/main
# Improved by ME, https://github.com/olliez-mods


# ===== Load ContainerConfig.ini =====

$iniFilePath = "ContainerConfig.ini"

# Create an empty hashtable to store key-value pairs
$iniConfig = @{}

# Read the .ini file line by line
Get-Content -Path $iniFilePath | ForEach-Object {
    # Remove leading and trailing whitespace
    $line = $_.Trim()
    
    # Skip empty lines and comments
    if (-not [string]::IsNullOrEmpty($line) -and $line -notmatch '^/s*#') {
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

Write-Output "Loaded port=$port"
Write-Output "Loaded PersistentServer=$PersistentServer"
Write-Output "Loaded VolumePath:$VolumePath"
Write-Output "  (Full Path [$PWD\$VolumePath])"

$docker = Get-Process -Name "Docker Desktop"  -ErrorAction SilentlyContinue
# Is docker running? If it's not start it
if(-not $docker){
    Write-Output ""
    Write-Output "Docker Desktop not running, attempting to start it automatically"
    start-Process -FilePath "C:/Program Files/Docker/Docker/Docker Desktop.exe" -WindowStyle Minimized
    Read-Host "Press enter once Docker Desktop starts (If it doesn't start, do it maunaly)"
}

Write-Output ""

# ==========

# Test path existence for the folders and files below
$volumeFolderExists = Test-Path "$PWD/$VolumePath"
$minorGemsExist = Test-Path "$PWD/$VolumePath/minorGems"
$OneLifeExists = Test-Path "$PWD/$VolumePath/OneLife"
$OneLifeData7Exists = Test-Path "$PWD/$VolumePath/OneLifeData7"
$OneLifeServerExists = Test-Path "$PWD/$VolumePath/OneLife/server/"
$OneLifeServerAppExists = Test-Path "$PWD/$VolumePath/OneLife/server/OneLifeServer" # file

Write-Output ""
Write-Output ""

# If any of them dont exist, throw an error message and exit
if(-not $volumeFolderExists){
    Write-Output "Volume folder was not found, make sure you make sure that the server built successfully before running"
    Read-Host "."
    exit
}
if((-not $minorGemsExist) -or (-not $OneLifeExists) -or (-not $OneLifeData7Exists)){
    Write-Output "One or all of the main folders (OneLife/MinorGems/OneLifeData7) was not found, make sure that the server built successfully before running"
    Read-Host "."
    exit
}
if(-not $OneLifeServerExists){
    Write-Output "The server folder (./$VolumePath/OneLife/server) cannot be found, make sure that the server built successfully before running"
    Read-Host "."
    exit
}
if(-not $OneLifeServerAppExists){
    Write-Output "Could not find OneLifeServer application (./$VolumePath/OneLife/server/OneLifeServer), make sure that the server built successfully before running"
    Read-Host "."
    exit
}

# First delete old ocol container if it exists
docker rm -f ocos

$ports = "$port" + ":8005"
$AbsVolumePaths = "$PWD" + "/" + "$VolumePath" + "/:/files/volume"

# If the flag is set to "always" then when the computer or Docker Desktop reboots, this container will restart automagically
$restartFlag = "no"
if ($PersistentServer -eq "1") {
    $restartFlag = "always"
}

Write-Output "Starting container (in detach mode)..."
docker run --name=ocos -d -v $AbsVolumePaths -p $ports --restart $restartFlag -e "MODE=0" ocos_server
Write-Output ""
Write-Output "IMOPRTANT: You can see logs inside the Docker Desktop application..."
Write-Output 'In the containers tab (on the left) select "ocos" and you can access logs from that page'
Write-Output 'It might take a couple minutes for the logs to appear'

Read-Host -Prompt "Program ended, press Enter to continue"