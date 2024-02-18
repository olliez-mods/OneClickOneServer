# Original Script derived from danomation: https://github.com/danomation/onehouroneclick/tree/main
# Improved by ME, https://github.com/olliez-mods

# Run with max perms avaliable to the user, May cause ignorable error
Set-ExecutionPolicy -Scope CurrentUser Unrestricted

# ===== Load ContainerConfig.ini =====

$iniFilePath = "ContainerConfig.ini"

# Create an empty hashtable to store key-value pairs
$iniConfig = @{}

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


echo $port

# ====== Check All Needed Programs Are Installed, Enabled, And running =====

# Check if WSL (Windows subsystem for linux) is installed
echo "Installing pre-requisites for OHOL"
if(Test-Path 'c:\windows\system32\wsl.exe'){
    echo "WSL already installed.... continuing...."
}
else {
    echo "Enabling WSL...."
    # Tellng windows we want to enable WSL and all parent features
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    Read-Host -Prompt "** Manually close all powershell windows and re-run the script **"
    exit
}

# Check if docker is installed
$docker = Get-Service -Name com.docker.service  -ErrorAction SilentlyContinue
# Null means not insalled
if($docker -eq $null){
    echo "Downloading and installing Docker"
    echo "This may take a while...."
    $ProgressPreference = 'SilentlyContinue'
    # Use curl and Start-Proccess to download the installer and run it
    curl "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" -o "Docker Desktop Installer.exe"
    Start-Process 'Docker Desktop Installer.exe' -Wait -ArgumentList 'install', '--quiet --accept-license'
    Read-Host -Prompt "** Manually close all powershell windows and re-run the script **"
    exit
}
else{
    echo "Docker already installed.... continuing...."
}

# Does docker exist? If it does, attempt to start the proccess, otherwise prompt use to start manualy
if(Test-Path 'C:\Program Files\Docker\Docker\Docker Desktop.exe'){
    #Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Minimized
}
else{
    echo "Start the Docker Engine in the Docker Desktop app before pressing ENTER to continue."
    Read-Host -Prompt "<enter to continue>"
}

# =====

# First delete old ocol container if it exists
docker rm -f ocos

$ports = "$port" + ":8005"
$AbsVolumePaths = "$PWD" + "\" + "$VolumePath" + "\:/files/volume"

# If the flag is set to "always" then when the computer or Docker Desktop reboots, this container will restart automagically
$restartFlag = "no"
if ($PersistentServer -eq "1") {
    $restartFlag = "always"
}

echo "Starting container (in detach mode)..."
docker run --name=ocos -d -v $AbsVolumePaths -p $ports --restart $restartFlag -e "MODE=0" ocos_server
echo ""
echo "IMOPRTANT: You can see logs inside the Docker Desktop application..."
echo 'In the containers tab (on the left) select "ocos" and you can access logs form that page'

Read-Host -Prompt "Program ended, press Enter to continue"