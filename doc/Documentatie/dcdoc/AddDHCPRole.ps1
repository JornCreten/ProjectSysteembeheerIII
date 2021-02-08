Add-WindowsFeature -Name 'DHCP' –IncludeManagementTools
Add-DhcpServerSecurityGroup -ComputerName "alfa.CORONA2020.local"
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2;
Add-DhcpServerInDC -DnsName CORONA2020.local -IPAddress 192.168.55.2
Restart-service dhcpserver
Add-DhcpServerV4Scope -Name "Project3Scope" -StartRange 192.168.55.1 -EndRange 192.168.55.254 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerV4OptionValue -ScopeId 192.168.55.0 -DnsServer 192.168.55.3 -Router 192.168.55.1 -DnsDomain "CORONA2020.local" -Force
Set-DhcpServerv4Scope -ScopeId 192.168.55.0 -LeaseDuration 1.00:00:00
Add-Dhcpserverv4ExclusionRange -ScopeId 192.168.55.0 -StartRange 192.168.55.1 -EndRange 192.168.55.6