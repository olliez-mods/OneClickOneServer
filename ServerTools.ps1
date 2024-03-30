# TODO Let user choose option
# TODO Allow user to copy world files / import world files (overwrite)
# TODO Let user see all settings (grouped by catagory) and edit each one
# let user see specifics about each setting and see all related commands (eg. EVE X, EVE Y, FORCE EVE)
# let user see logs and server specific details.

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

$VolumePath = $iniConfig['VolumePath']
Write-Output "Loaded VolumePath:$VolumePath"
Write-Output "  (Full Path [$PWD\$VolumePath])"

# =======================

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
    Write-Output "Volume folder was not found, make sure you have built the server before using ServerTools"
    Read-Host "."
    exit
}
if((-not $minorGemsExist) -or (-not $OneLifeExists) -or (-not $OneLifeData7Exists)){
    Write-Output "One or all of the main folders (OneLife/MinorGems/OneLifeData7) was not found, make sure that the server built successfully before using ServerTools"
    Read-Host "."
    exit
}
if(-not $OneLifeServerExists){
    Write-Output "The server folder (./$VolumePath/OneLife/server) cannot be found, make sure that the server built successfully before using ServerTools"
    Read-Host "."
    exit
}
if(-not $OneLifeServerAppExists){
    Write-Output "Could not find OneLifeServer application (./$VolumePath/OneLife/server/OneLifeServer), make sure that the server built successfully before using ServerTools"
    Read-Host "."
    exit
}

# Menu
function Write-Menu {
    Write-Output ""
    Write-Output ""
    Write-Output ""
    Write-Output "Welcome to ServerTools by Oliver, please choose an option:"
    Write-Output "1: Copy World Files"
    Write-Output "2: Import World Files"
    Write-Output "3: View server settings"
}

Clear-Host
Write-Menu
$option = Read-Host ":"

if("$option" -eq "1"){
    . "./scripts/getWorldFiles.ps1"
    $worldFiles = Get-WorldFiles
    if(Test-Path "$PWD/WORLDCOPY" -PathType Container){
    Remove-Item "$PWD/WORLDCOPY" -Force -Recurse
    }
    New-Item -ItemType Directory -Name "WORLDCOPY" > $null
    Write-Host ""
    Write-Host "Copying world files from `"$PWD\$volumePath\OneLife\server\`""
    foreach ($fileName in $worldFiles) {
        try {
            Copy-Item -Path "$PWD\$volumePath\OneLife\server\$fileName" -Destination "$PWD\WORLDCOPY\$fileName" -Recurse -ErrorAction Stop
            Write-Host "`"$fileName`" copied successfully." -ForegroundColor Green
        } catch {
            Write-Host "`"$fileName`" could not be copied" -ForegroundColor Red
        }
    }
    Write-Host ""
    Write-Host "Copying settings..."
    try {
        Copy-Item -Path "$PWD/$volumePath/OneLife/server/settings" -Destination "$PWD/WORLDCOPY/" -Recurse -ErrorAction Stop
        Write-Host "Settings copied successfully" -ForegroundColor Green
    } catch {
        Write-Host "Settings folder could not be copied" -ForegroundColor Red
    }
}

Write-Host ""
Read-Host -Prompt "Program ended, press Enter to continue"