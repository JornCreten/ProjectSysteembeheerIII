# Testplan DC

Geschreven door: Sven De Vuyst

## Opstelling

- Allereerst gaan we een nieuwe machine in Virtualbox aanmaken. 
    - Naam: Alfa DC
    - Versie: Windows 2019 (64 bit)
    - Geheugen: 4096 MB
    - Nieuwe VDI (Dynamisch gealloceerd 100GB)

- Netwerkinstellingen  
    - 1 NAT Adapter
    - 1 Intern netwerk adapter (intnet)

## Opstartconfiguratie

- Windows Setup
    - Language to Install: English
    - Time and currency format: Dutch (Belgium)
    - Keyboard or input method: Belgian (Period)
    - Kies voor Windows Server 2019 Standard Evaluation (Desktop Experience)
    - Password: Project3

## VirtualBox Guest Additions

- We hebben Guest Additions nodig om aan onze folder met al onze scripts te geraken dus moeten we dit alseerste installeren.
    - Klik bovenaan op `Apparaten` en dan op `Invoegen Guest Additions CD-image...`
    - Navigeer naar `This PC` en klik op de D schijf. Run hier VBoxWindowsAdditions hierna wordt de server herstart.
    - We moeten nu onze gedeelde map instellingen nog goed zetten navigeer vanboven naar `Apparaten` en dan op `Gedeelde mappen`
    - Nu ga je navigeren naar de map waar al je windows scripts staan `C:\Users\Sven\Desktop\School\Projecten III\p3ops-2021-a01\doc\dcdoc` voor mij.
    - Klik nu ook `Automatisch koppelen` en `Permanent maken` aan. Nu zie je normaal de gedeelde map verschijnen bij `This PC`
    - Voor het gemak ga je bij `Apparaten` het gedeelde klembord en drag and drop bidirectioneel maken in het geval je wat moet kopieren van je fysieke systeem.

## Persoonlijke map

- Aangezien we geen powershell scripts kunnen runnen rechtstreeks aangezien dit niet 'Trusted' is gaan we zelf een persoonlijke map maken.
    - Navigeer naar de C schijf en maak hier een nieuwe map `Scripts` aan.
    - Kopieer alle bestanden uit de gedeelde map naar deze nieuwe map.

## RenameComputer

- Als eerste gaan we onze Computer / Server een juiste naam geven aan de hand van een mini scriptje. 
    - Run `RenameComputer.ps1`
    - De Computer / Server herstart en zal nu de correcte naam hebben: `alfa`

## AddADDSRole

- Verder gaan we nu onze Active Directory Domain Services Role gaan toevoegen aan de hand van een script alsook de LAN netwerkadapter juist zetten.
    - Run `AddADDSRole.ps1`
    - Enter het SafeMode Admin Password: Project3
    - De Computer / Server zal nu herstarten.
    - Controleer of de netwerkadapter (Ethernet 2) juist is: `192.168.55.2`
    - Controleer of het domein juist is: `CORONA2020.local`

## AddDHCPRole

- Als volgende role gaan we `DHCP` toevoegen aan onze DC.
    - Run `AddDHCPRole.ps1`
    - Ga naar `Tools` in Server Manager en klik `DHCP`
    - Controleer of de Scope correct is aangemaakt: `Project3Scope`
    - Controleer bij `Address Pool` of de volgende addressen worden gedistribueerd: `192.168.55.1` tot en met `192.168.55.254`
    - Controleer bij `Address Pool` of de volgende addressen worden geblokeerd van distributie: `192.168.55.1` tot en met `192.168.55.6`
    - Controleer bij `Scope Options` dat de volgende options aan staan: `003 Router`, `006 DNS Servers` en `015 DNS Domain Name`

## AddOUs

- De volgende stap is het toevoegen van de Organizational Units. Hierbij maken we als eerst een OU aan voor het geheel en daarna een aantal OU's voor de aparte departementen. Deze OU's zijn nodig om later de Group Policies op te zetten aangezien ik niet heb gevonden hoe je Group Policies op "Groepen" zelf zet.
    - Run `AddOUs.ps1`
    - Ga naar `Tools` in Server Manager en klik `Active Directory Users and Computers`
    - Controleer hier of alle OU's zijn aangemaakt: `Alfa DC`, `Administratie`, `Directie`, `IT Administratie`, `Ontwikkeling`, `Verkoop` en `Werkstations`

## AddGroups

- We gaan nu Active Directory Groepen toevoegen aan deze OU's aan de hand van een vrij eenvoudig script.
    - Run `AddGroups.ps1`
    - Ga naar `Tools` in Server Manager en klik `Active Directory Users and Computers`
    - Controleer hier in de OU's of volgende groepen zijn aangemaakt: `Administratie`, `Directie`, `IT Administratie`, `Ontwikkeling` en `Verkoop`

## AddNewUsers

- We gaan nu onze Users gaan toevoegen aan de OU's. Dit gebeurd aan de hand van een script en een voorbereid CSV file `test.csv`
    - Run `AddNewUsers.ps1` en druk daarna op Enter
    - Ga naar `Tools` in Server Manager en klik `Active Directory Users and Computers`
    - Controleer of de volgende Users zijn aangemaakt in de OU's: `Sven De Vuyst`, `Manon Joly`, `Yves Vandendooren`, `Dario Van Heck`, en `Jorn Creten`

## AddUsersToGroups

- Nu gaan we onze Users gaan toevoegen aan de groepen die we eerder hebben aangemaakt. Bijvoorbeeld: Sven De Vuyst -> Administratie
    - Run `AddUsersToGroups.ps1`
    - Ga naar `Tools` in Server Manager en klik `Active Directory Users and Computers`
    - Controleer bij elke user of ze in de juiste groep zitten: Rechterklik op de user en klik `Properties` kijk dan bij de tab `Member of` of hij in de juiste groep zit.
    - `Sven De Vuyst` zit in `Administratie`
    - `Manon Joly` zit in `Directie` 
    - `Yves Vandendooren` zit in `IT Administratie`
    - `Dario Van Heck` zit in `Ontwikkeling`
    - `Jorn Creten` zit in `Verkoop`

## AddComputers

- We gaan nu een aantal werkstations toevoegen dat de Users kunnen gebruiken aan de hand van een script en opnieuw een voorbereide CSV File.
    - Run `AddComputers.ps1`
    - Ga naar `Tools` in Server Manager en klik `Active Directory Users and Computers`
    - Controleer bij de OU `Werkstations` of de werkstations zijn toegevoegd: `AdminPC`, `DirectiePC`, `ITAdminPC`, `OntwikkelingPC` en `VerkoopPC`

## AddComputersToGroups

- Zoals bij de users gaan we nu deze Computers ook toewijzen aan hun respectivelijke groepen. Bijvoorbeeld: AdminPC -> Administratie
    - Run `AddComputersToGroups.ps1`
    - Ga naar `Tools` in Server Manager en klik `Active Directory Users and Computers`
    - Controleer bij elke computer of ze in de juiste groep zitten: Rechterklik op de computer en klik `Properties` kijk dan bij de tab `Member of` of hij in de juiste groep zit.
    - `AdminPC` zit in `Administratie`
    - `DirectiePC` zit in `Directie` 
    - `ITAdminPC` zit in `IT Administratie`
    - `OntwikkelingPC` zit in `Ontwikkeling`
    - `VerkoopPC` zit in `Verkoop`
    
## DNS

- Normaal gezien gaan we dit niet configureren op onze DC maar aangezien we een testomgeving lokaal willen opzetten om te testen of alle Group Policies werken gaan we dit hier toch gaan doen.
- Ga naar Server Manager en voeg een nieuwe Role `DNS Server` toe.
- Ga naar `Tools` in Server Manager en klik `DNS`
- Maak bij `Forward Lookup Zones` een nieuwe zone aan.
    - Zone name: CoronaZone
- Maak bij `Reverse Lookup Zones` een nieuwe zone aan.
    - IPv4 Reverse Lookup Zone
    - Network ID: 192.168.55.

## AddDFSRole + Configuratie DFS

- We gaan nu de Role `DFS` automatisch gaan installeren via een powershell script, de configuratie wordt wel manueel gedaan.
    - Run `AddDFSRole.ps1`
    - Als je een prompt krijgt doe dan `Yes`
    - Ga naar `Tools` in Server Manager en klik `DFS Management`
    - Rechterklik op `Namespaces` en maak een nieuwe namespace aan.
        - Server: alfa
        - Name: CoronaSpace
        - Stand-alone namespace
    - Ga naar de map `C:\DFSRoots\CoronaSpace`
    - We maken hier een text file aan `test.txt` met tekst: Testing
    - Als we straks op de client gaan in loggen moeten we deze tekst file terug zien te vinden.

## Group Policies

- We gaan nu aan de hand van een script al onze Group Policies automatisch laten instellen via Backup files deze zie je in de folder `GPO Backup`
    - Run `GroupPolicies.ps1`
    - Ga naar `Tools` in Server Manager en klik `Group Policy Management`
    - Controleer hier bij het Domein `CORONA2020.local` of alle OU's aanwezig zijn: `Alfa DC`, `Administratie`, `Directie`, `IT Administratie`, `Ontwikkeling`, `Verkoop` en `Werkstations`
    - Controleer bij `Group Policy Objects` of al onze Group Policies aanwezig zijn: `FileSystemDFSVoorUsers`, `VerbiedToegangTotControlPanel`, `VerbiedToegangTotNetwerkAdapters` en `VerwijderGamesUitStart`

## Controleren FileSystemDFSVoorUsers GPO

- Edit de GPO `FileSystemDFSVoorUsers`
- Navigeer hier naar `User Configuration -> Preferences -> Windows Settings -> Drive Map`
- Controleer of hier een Drive aanwezig is met de naam `K:` en het pad `\\alfa\CoronaSpace`
- Rechterklik op de drive en klik op `Properties` klik hierna op de `Common tab`
- Controleer of `Run in logged-on user's security context (user policy option)` en `Item-level targetting` aan staat
- Klik op `Targeting...` en controleer hier of de OU `Alfa DC` wordt getarget.

## Controleren VerbiedToegangTotControlPanel GPO

- Edit de GPO `VerbiedToegangTotControlPanel`
- Navigeer hier naar `User Configuration -> Policies -> Administrative Templates -> Control Panel`
- Controleer of `Prohibit access to Control Panel and PC Settings` hier `Enabled` staat.

## Controleren VerbiedToegangTotNetwerkAdapters GPO

- Edit de GPO `VerbiedToegangTotNetwerkAdapters`
- Navigeer hier naar `User Configuration -> Policies -> Administrative Templates -> Network -> Network Connections`
- Controleer of `Prohibit access to properties of components of a LAN connection` hier `Enabled` staat.
- Controleer of `Prohibit access to properties of a LAN connection` hier `Enabled` staat.

## Controleren VerwijderGamesUitStart GPO

- Edit de GPO `VerwijderGamesUitStart`
- Navigeer hier naar `User Configuration -> Policies -> Administrative Templates -> Start Menu and Taskbar`
- Controleer of `Remove Games link from Start Menu` hier `Enabled` staat.
- Navigeer daarna naar `User Configuration -> Policies -> Administrative Templates -> System`
- Edit hier de policy `Don't run specified Windows Applications` klik hier dan op `Show...` en controleer of `sol.exe` en `Solitaire.exe` geblokeerd worden.
- Navigeer hierna naar `Computer Configuration -> Windows Settings -> Security Settings -> Application Control Policies -> AppLocker -> Packaged app Rules`
- Controleer hier of `Microsoft.MicrosoftSolitaireCollection` geblokeerd wordt.

## Opstelling Client

- Allereerst gaan we een nieuwe machine in Virtualbox aanmaken. 
    - Naam: AdminPC
    - Versie: Windows 10 (64 bit)
    - Geheugen: 2048 MB
    - Nieuwe VDI (Dynamisch gealloceerd 50GB)

- Netwerkinstellingen  
    - 1 Intern netwerk adapter (intnet)

## Configuratie Client

- Windows Setup
    - Language to Install: Nederlands (Nederland)
    - Time and currency format: Nederlands (Belgie)
    - Keyboard or input method: Belgisch (punt)
    - Kies voor `Ik heb geen productcode`
    - Ga akkoord met de licentievoorwaarden
    - Klik op `Expresinstellingen gebruiken` wanneer dit geprompt wordt.
- Account op PC
    - Gebruikersnaam: Project
    - Wachtwoord: Project3
    - Geheugensteun: Project
- Netwerkadapter
    - IP: 192.168.55.10
    - Subnetmask: 255.255.255.0
    - Standaardgateway: 192.168.55.2
    - Voorkeurs-DNS-server: 192.168.55.2
- Ga naar Deze PC en klik op `Eigenschappen`
    - Klik nu op `Instellingen wijzigen`
    - Klik nu op `Wijzigen`
    - Computernaam: AdminPC
    - Domein: CORONA2020.local
    - Vul gebruikersnaam `Administrator` in met wachtwoord `Project3` wanneer dit geprompt wordt.
    - De PC wordt nu herstart.
- Na de herstart log je nu in met `Andere gebruiker`
    - Gebruikersnaam: SvenDV
    - Wachtwoord: Project3
- Je wordt nu geprompt om het wachtwoord te veranderen.
    - Nieuw wachtwoord: Testing3
- Rechterklik na het inloggen op het internet icoon en klik op `Netwerkcentrum openen`
    - Controleer of de bewerking nu geblokeerd wordt.
- Ga naar het startmenu en zoek naar `Configuratiescherm` klik dan op `Configuratiescherm`
    - Controleer of de bewerking nu geblokeerd wordt.
- Ga naar het startmenu en zoek naar `Microsoft Solitaire Collection` klik dan op `Microsoft Solitaire Collection`
    - Controleer of de bewerking nu geblokeerd wordt. **Dit gebeurd helaas niet omdat ik niet heb gevonden hoe ik deze applicatie volledig kan blokkeren / verwijderen.**
- Ga naar Deze pc en zoek naar `CoronaSpace(\\ALFA) (K:)`
    - Controleer of de tekstfile `test.txt` verschijnt.
    - Controller of de tekst `testing` in deze tekstfile te vinden is.
- Als u fouten tegenkomt bij de Client zoals het joinen bij het domein dat niet lukt probeer op de DC bij `Ethernet 2` de DNS Servers in te stellen als `8.8.8.8` en `8.8.4.4`

- Normaal gezien heb je nu alles doorlopen en moet alles werken als er toch nog problemen zijn message `Sven De Vuyst`

## Einde