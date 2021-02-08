New-GPO -Name VerbiedToegangTotControlPanel | New-GPLink -Target "OU=Administratie,OU=Alfa DC,DC=CORONA2020,DC=local"
New-GPLink -Name VerbiedToegangTotControlPanel -Target "OU=Verkoop,OU=Alfa DC,DC=CORONA2020,DC=local"
New-GPLink -Name VerbiedToegangTotControlPanel -Target "OU=Directie,OU=Alfa DC,DC=CORONA2020,DC=local"
New-GPLink -Name VerbiedToegangTotControlPanel -Target "OU=Ontwikkeling,OU=Alfa DC,DC=CORONA2020,DC=local"

New-GPO -Name VerwijderGamesUitStart | New-GPLink -Target "OU=Administratie,OU=Alfa DC,DC=CORONA2020,DC=local"
New-GPLink -Name VerwijderGamesUitStart -Target "OU=IT Administratie,OU=Alfa DC,DC=CORONA2020,DC=local"
New-GPLink -Name VerwijderGamesUitStart -Target "OU=Verkoop,OU=Alfa DC,DC=CORONA2020,DC=local"
New-GPLink -Name VerwijderGamesUitStart -Target "OU=Directie,OU=Alfa DC,DC=CORONA2020,DC=local"
New-GPLink -Name VerwijderGamesUitStart -Target "OU=Ontwikkeling,OU=Alfa DC,DC=CORONA2020,DC=local"

New-GPO -Name VerbiedToegangTotNetwerkAdapters | New-GPLink -Target "OU=Administratie,OU=Alfa DC,DC=CORONA2020,DC=local"
New-GPLink -Name VerbiedToegangTotNetwerkAdapters -Target "OU=Verkoop,OU=Alfa DC,DC=CORONA2020,DC=local"
 
New-GPO -Name FileSystemDFSVoorUsers | New-GPLink -Target "OU=Alfa DC,DC=CORONA2020,DC=local"

Import-GPO -BackupID "AEFFFF56-6452-48EC-8ED9-09B44D7623F0" -Path "Z:\GPO Backup" -TargetName "VerbiedToegangTotControlPanel"
Import-GPO -BackupID "03F6978F-8397-4F8A-B990-0BBF21608395" -Path "Z:\GPO Backup" -TargetName "VerwijderGamesUitStart"
Import-GPO -BackupID "F98001FE-A1A7-42C3-A016-A69554DEBC82" -Path "Z:\GPO Backup" -TargetName "VerbiedToegangTotNetwerkAdapters"
Import-GPO -BackupID "68BD2335-EFDE-40F4-AF6F-31AE767857E3" -Path "Z:\GPO Backup" -TargetName "FileSystemDFSVoorUsers"