Set-NetIPInterface -InterfaceAlias "Ethernet 2" -Dhcp Disabled
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 192.168.55.2  -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.55.3"

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

$Password = Read-Host -Prompt   'Enter SafeMode Admin Password' -AsSecureString
$Params = @{
    CreateDnsDelegation = $false
    DatabasePath = 'C:\Windows\NTDS'
    DomainMode = 'WinThreshold'
    DomainName = 'CORONA2020.local'
    DomainNetbiosName = 'CORONA2020'
    ForestMode = 'WinThreshold'
    InstallDns = $false
    LogPath = 'C:\Windows\NTDS'
    NoRebootOnCompletion = $true
    SafeModeAdministratorPassword = $Password
    SysvolPath = 'C:\Windows\SYSVOL'
    Force = $true
}
Install-ADDSForest @Params
#Install-ADDSDomainController -DomainName "CORONA2020.local" -InstallDns:$false -Credential ($Password) -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Project3" -Force) (Niet nodig blijkbaar)
Restart-Computer