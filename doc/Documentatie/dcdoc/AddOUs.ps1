New-ADOrganizationalUnit -Name "Alfa DC"

New-ADOrganizationalUnit -Name "Administratie" -Path "OU=Alfa DC,DC=CORONA2020,DC=local";
New-ADOrganizationalUnit -Name "IT Administratie" -Path "OU=Alfa DC,DC=CORONA2020,DC=local";
New-ADOrganizationalUnit -Name "Verkoop" -Path "OU=Alfa DC,DC=CORONA2020,DC=local";
New-ADOrganizationalUnit -Name "Ontwikkeling" -Path "OU=Alfa DC,DC=CORONA2020,DC=local";
New-ADOrganizationalUnit -Name "Directie" -Path "OU=Alfa DC,DC=CORONA2020,DC=local";
New-ADOrganizationalUnit -Name "Werkstations" -Path "OU=Alfa DC,DC=CORONA2020,DC=local";