# Install Web Server roles and features for ConfigMgr

function TestPath($Path) {
    if ( $(Try { Test-Path $Path.trim() } Catch { $false }) ) {
        write-host "Path OK"
    }
    else {
        write-host "$Path not found, please fix and try again."
        break
    }
}

$XMLpath = "C:\scriptjes\xml\DeploymentConfigTemplate.xml"
$SourceFiles = "D:\sources\sxs"
$LogFile = "C:\Windows\Temp\InstallRolesAndFeatures.log"

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

# check if the XML file is found

$Path = $XMLpath
TestPath $Path

#check if the installation media is found

$Path = $SourceFiles
TestPath $Path

Write-Host "Installing roles and features, please wait... " -NoNewline
Install-WindowsFeature -ConfigurationFilePath $XMLpath -Source $SourceFiles -LogPath $LogFile -Verbose
Write-Host "Exiting script"