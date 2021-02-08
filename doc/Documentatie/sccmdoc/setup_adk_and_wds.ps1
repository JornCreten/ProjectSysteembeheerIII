# Install windows ADK 2004, Windows PE Addon and WDS 

function TestPath($Path) {
    if ( $(Try { Test-Path $Path.trim() } Catch { $false }) ) {
        write-host "Path OK"
    } else {
        write-host "$Path not found, please fix and try again."
        break
    }
}

$SourcePath = "C:\Source"

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole( [Security.Principal.WindowsBuiltInRole] "Administrator")) {
        write-warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
        break
    }

    # Create source folder if needed
    if (Test-Path $SourcePath) {
        write-host "The source folder already exists."
    } else {
        new-item -Path $SourcePath -ItemType Directory
    }

$ADKPath = '{0}\Windows Kits\10\ADK' -f $SourcePath;
$ADKPath2 = '{0}\Windows Kits\10\Installers\Windows PE x86 x64-x86_en-us.msi' -f $SourcePath;
$ArgumentList1 = '/layout "{0}" /quiet' -f $ADKPath;

# Check if these files exist, if not, download
$file1 = $SourcePath+"\adksetup.exe"
$file2 = $SourcePath+"\adkwinpesetup.exe"

    if (Test-Path $file1) {
        write-host "The file $file1 exists, skipping download"
    } else {
    # Download Windows Assessment and Deployment Kit
        write-host "Downloading adksetup.exe " -NoNewline
        $clnt = New-Object System.Net.WebClient
        $url = "https://go.microsoft.com/fwlink/?linkid=2120254"
        $clnt.DownloadFile($url,$file1)
        write-host "Done!" -ForegroundColor Green
    }

    if (Test-Path $ADKPath) {
        write-host "The folder $ADKPath exists, skipping download"
    } else {
        write-host "Downloading Windows ADK 10, please wait..." -NoNewline
        Start-Process -FilePath $file1 -Wait -ArgumentList $ArgumentList1
        write-host "Done!" -ForegroundColor Green
    }

Start-Sleep -s 3

# Download the ADK 10 version 2004 Windows PE Addon
write-host "Downloading adkwinpesetup.exe " -NoNewline
$clnt = New-Object System.Net.WebClient
$url = "https://go.microsoft.com/fwlink/?linkid=2120253"
$clnt.DownloadFile($url,$file2)
write-host "Done!" -ForegroundColor Green

    if (Test-Path $ADKPath2) {
        write-host "The file $ADKPath2 exists, skipping download"
    } else {
        write-host "Downloading the windows PE addon for Windows ADK 10, please wait..." -NoNewline
        Start-Process -FilePath $file2 -Wait -ArgumentList $ArgumentList1
        write-host "Done!" -ForegroundColor Green
    }

Start-Sleep -s 10

# Install Windows Deployment Service
write-host "Installing Windows Deployment Services..." -NoNewline
Import-Module ServerManager
Install-WindowsFeature -Name WDS -IncludeManagementTools
Start-Sleep -s 10

# Install ADK Deployment Tools
write-host "Installing Windows ADK version 2004..."
Start-Process -FilePath "$ADKPath\adksetup.exe" -Wait -ArgumentList " /Features OptionId.DeploymentTools OptionId.ImagingAndConfigurationDesigner OptionId.UserStateMigrationTool /norestart /quiet /ceip off"
Start-Sleep -s 20
write-host "Done!"

# Install Windows Preinstallation Environment
write-host "Installing Windows Preinstallation Environment..."
Start-Process -FilePath "$ADKPath\adkwinpesetup.exe" -Wait -ArgumentList " /Features OptionId.WindowsPreinstallationEnvironment /norestart /quiet /ceip off"
Start-Sleep -s 20
write-host "Done!"