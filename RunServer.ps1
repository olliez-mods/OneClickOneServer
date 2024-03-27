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

echo "Loaded port=$port"
echo "Loaded PersistentServer=$PersistentServer"
echo "Loaded VolumePath:$VolumePath"
echo "  (Full Path [$PWD\$VolumePath])"

$docker = Get-Process -Name "Docker Desktop"  -ErrorAction SilentlyContinue
# Is docker running? If it's not start it
if(-not $docker){
    echo ""
    echo "Docker Desktop not running, attempting to start it automatically"
    start-Process -FilePath "C:/Program Files/Docker/Docker/Docker Desktop.exe" -WindowStyle Minimized
    Read-Host "Press enter once Docker Desktop starts (If it doesn't start, do it maunaly)"
}

echo ""

# =====

# First delete old ocol container if it exists
docker rm -f ocos

$ports = "$port" + ":8005"
$AbsVolumePaths = "$PWD" + "/" + "$VolumePath" + "/:/files/volume"

# If the flag is set to "always" then when the computer or Docker Desktop reboots, this container will restart automagically
$restartFlag = "no"
if ($PersistentServer -eq "1") {
    $restartFlag = "always"
}

echo "Starting container (in detach mode)..."
docker run --name=ocos -d -v $AbsVolumePaths -p $ports --restart $restartFlag -e "MODE=0" ocos_server
echo ""
echo "IMOPRTANT: You can see logs inside the Docker Desktop application..."
echo 'In the containers tab (on the left) select "ocos" and you can access logs from that page'
echo 'It might take a couple minutes for the logs to appear'

Read-Host -Prompt "Program ended, press Enter to continue"