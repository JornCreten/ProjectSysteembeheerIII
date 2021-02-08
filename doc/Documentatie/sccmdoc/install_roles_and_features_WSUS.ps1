# Installs WSUS role

  If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] “Administrator”))

    {
        Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
        Break
    }
$XMLpath = "C:\scriptjes\xml\DeploymentConfigTemplate_WSUS.xml"
$WSUSFolder = "C:\WSUS"
$SourceFiles = "D:\Sources\SXS"
$ServerName="echo"
# create WSUS folder
if (Test-Path $WSUSFolder){
 write-host "The WSUS folder already exists."
 } else {

New-Item -Path $WSUSFolder -ItemType Directory
}
if (Test-Path $SourceFiles){
 write-host "Windows Server 2019 source files found"
 } else {

write-host "Windows Server 2019 source files not found, aborting"
break
}

Write-Host "Installing roles and features, please wait... "  -nonewline
Install-WindowsFeature -ConfigurationFilePath $XMLpath -Source $SourceFiles
Start-Sleep -s 10
write-host "Configuring SUSDB in SQL and WSUS content location..."
& ‘C:\Program Files\Update Services\Tools\WsusUtil.exe’ postinstall SQL_INSTANCE_NAME=$ServerName CONTENT_DIR=$WSUSFolder |out-file Null
write-host "All done !"