$RootDir="D:\EdgeCI"
if (!(Test-Path "$RootDir\Downloads")) {

    $DepotToolsUrl="https://storage.googleapis.com/chrome-infra/depot_tools.zip"
    $VSSDKUrl="="https://download.microsoft.com/download/5/A/0/5A08CEF4-3EC9-494A-9578-AB687E716C12/windowssdk/winsdksetup.exe"

    # Download Files
    New-Item -ItemType Directory -Force -Path $RootDir\Downloads
    Import-Module BitsTransfer
    Start-BitsTransfer -Source $DepotToolsUrl -Destination "$RootDir\Downloads\depot_tools.zip"
    Start-BitsTransfer -Source $VSSDKUrl -Destination "$RootDir\Downloads\winsdksetup.exe"

    # Install Depot Tools
    Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$RootDir\Downloads\depot_tools.zip", "$RootDir\DepotTools\")

    # Install Windows SDK
    Start-Process -Wait "$RootDir\Downloads\winsdksetup.exe" "/features + /q" 
    
    # fetch code
    New-Item -ItemType Directory -Force -Path $RootDir\src
    cd $RootDir\src
    fetch chromium
}