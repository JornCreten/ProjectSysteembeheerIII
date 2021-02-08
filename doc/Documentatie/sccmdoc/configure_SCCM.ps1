Set-Location  "C:\SCCM\AdminConsole\bin"
Import-Module .\ConfigurationManager.psd1

New-PSDrive -Name "P01" -PSProvider "AdminUI.PS.Provider\CMSite" -Root "echo.CORONA2020.local" -Description "Primary site"
Set-location P01:

New-CMBoundary -DisplayName "Active Directory Site" -Value "Default-First-Site-Name" -Type ADSite | Add-CMBoundaryToGroup -BoundaryGroupName 'ADSite'

Set-CMDiscoveryMethod -ActiveDirectoryForestDiscovery -SiteCode "P01" -EnableActiveDirectorySiteBoundaryCreation $True -Enabled $True  -EnableSubnetBoundaryCreation $True 
Set-CMDiscoveryMethod -NetworkDiscovery -SiteCode "P01" -Enabled $true -NetworkDiscoveryType ToplogyAndClient
Set-CMDiscoveryMethod -ActiveDirectorySystemDiscovery -SiteCode "P01" -Enabled $true -ActiveDirectoryContainer "LDAP://DC=CORONA2020,DC=LOCAL"
Set-CMDiscoveryMethod -ActiveDirectoryUserDiscovery -SiteCode "P01" -Enabled $true -ActiveDirectoryContainer "LDAP://DC=CORONA2020,DC=LOCAL" 
$discoveryScope =New-CMADGroupDiscoveryScope -LDAPlocation "LDAP://DC=CORONA2020,DC=LOCAL" -Name"ADdiscoveryScope" -RecursiveSearch $true
Set-CMDiscoveryMethod -ActiveDirectoryGroupDiscovery -SiteCode "P01" -Enabled $true -AddGroupDiscoveryScope $discoveryScope

# Dit is geen goede of conventionele manier om wachtwoorden door te geven maar om alles unattended te houden doen we het in deze cursus
$pass = ConvertTo-SecureString -String "Project3" -AsPlainText -Force

New-CMAccount -UserName "CMADmin" -Password $pass -SiteCode "P01" 

Set-CMDistributionPoint -SiteSystemServerName "echo.CORONA2020.local" -enablePXE $true -AllowPxeResponse $true -EnableUnknownComputerSupport $true -RespondToAllNetwork

Add-CMSoftwareUpdatePoint -SiteCode "P01" -SiteSystemServerName "echo.CORONA2020.local" -ClientConnectionType "Intranet"