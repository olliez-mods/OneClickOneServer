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
Write-Output "Loaded VolumePath:$VolumePath    (Full Path [$PWD\$VolumePath])"

# =======================

# Test path existence for the folders and files below
$volumeFolderExists = Test-Path "$PWD/$VolumePath"
$OneLifeExists = Test-Path "$PWD/$VolumePath/OneLife"
$OneLifeServerExists = Test-Path "$PWD/$VolumePath/OneLife/server/"

Write-Output ""
Write-Output ""

# If any of them dont exist, throw an error message and exit
if(-not $volumeFolderExists){
    Write-Output "Volume folder was not found, make sure you have built the server before using copyWorld.ps1"
    Read-Host "."
    exit
}
if((-not $minorGemsExist) -or (-not $OneLifeExists) -or (-not $OneLifeData7Exists)){
    Write-Output " (./$VolumePath/OneLife) was not found, make sure that the server built successfully before using copyWorld.ps1"
    Read-Host "."
    exit
}
if(-not $OneLifeServerExists){
    Write-Output "The server folder (./$VolumePath/OneLife/server) cannot be found, make sure that the server built successfully before using copyWorld.ps1"
    Read-Host "."
    exit
}

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

Write-Host ""
Read-Host -Prompt "Program ended, press Enter to continue"