Import-Module ActiveDirectory

$CSV='C:\Scripts\AddComputers.csv'

$OU=‘OU=Werkstations,OU=Alfa DC,DC=CORONA2020,DC=local’

Import-Csv -Path $CSV | ForEach-Object { New-ADComputer -Name $_.Computer -Path $OU -Enabled $True}