Import-Module ActiveDirectory

Add-ADGroupMember "Administratie" -Members "AdminPC$"
Add-ADGroupMember "IT Administratie" -Members "ITAdminPC$"
Add-ADGroupMember "Directie" -Members "DirectiePC$"
Add-ADGroupMember "Verkoop" -Members "VerkoopPC$"
Add-ADGroupMember "Ontwikkeling" -Members "OntwikkelingPC$"