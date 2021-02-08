Write-Host "Starting MDT Installation"
Start-Process "Z:\WIN_SCCM_Files\MicrosoftDeploymentToolkit_x64.msi" /qn -Wait 
Write-Host "Installation Complete" -ForegroundColor Green
Write-Host

$features = "/features OptionId.DeploymentTools OptionId.UserStateMigrationTool /norestart /quiet"
Write-Host "Starting ADK Setup"
Start-Process -FilePath "Z:\WIN_SCCM_Files\adksetup.exe"  -ArgumentList $features -Wait -NoNewWindow
Write-Host "Installation Complete" -ForegroundColor Green
Write-Host 

$feature = "/features OptionId.WindowsPreinstallationEnvironment /norestart /quiet"
Write-Host "Starting PE Setup"
Start-Process -FilePath "Z:\WIN_SCCM_Files\adkwinpesetup.exe" -ArgumentList $feature -Wait -NoNewWindow
Write-Host "Installation Complete" -ForegroundColor Green
