# Testplan SCCM

Geschreven door: Manon Joly

## Opstelling

- Allereerst gaan we een nieuwe machine in Virtualbox aanmaken. 
    - Naam: Echo SCCM
    - Versie: Windows 2019 (64 bit)
    - Geheugen: 8192 MB
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
    - Nu ga je navigeren naar de map waar al je windows scripts staan `C:\School\Projecten III\p3ops-2021-a01\doc\sccmdoc` voor mij.
    - Klik nu ook `Automatisch koppelen` en `Permanent maken` aan. Nu zie je normaal de gedeelde map verschijnen bij `This PC`
    - Voor het gemak ga je bij `Apparaten` het gedeelde klembord en drag and drop bidirectioneel maken in het geval je wat moet kopieren van je fysieke systeem.

## Persoonlijke map

- Aangezien we geen powershell scripts kunnen runnen rechtstreeks aangezien dit niet 'Trusted' is gaan we zelf een persoonlijke map maken.
    - Navigeer naar de C schijf en maak hier een nieuwe map `Scripts` aan.
    - Kopieer alle bestanden uit de gedeelde map naar deze nieuwe map.

## Rename Computer

- Als eerste gaan we onze Computer / Server een juiste naam geven aan de hand van een mini scriptje. 
    - Run `rename_computer.ps1`
    - De Computer / Server herstart en zal nu de correcte naam hebben: `echo`

## Join Domain

- Verder gaan we nu het domain CORONA2020.local joinen. Hiervoor moet onze DC en DNS server draaien. Met dit script gaan we ook onze SCCM het juiste ip adres geven.
    - Run `join_domain.ps1`
    - De Computer / Server zal nu herstarten.
    - Controleer of de netwerkadapter (Ethernet 2) juist is: `192.168.55.6`
    - Controleer of het domein juist is: `CORONA2020.local`

## Install roles and features

- Als volgende role gaan we enkele roles en features installeren.
    - Run `install_roles_and_features.ps1`
    - Dit kan even duren, maar de server moet niet herstart worden hierna.
    - Kijk of alle roles en features geïnstalleerd zijn.

## Install Windows ADK & WDS

- Ook moeten Windows ADK en WDS geïnstalleerd worden op onze server.
    - Run `setup_adk_and_wds.ps1`
    - Controleer of het script runt zonder errors en dat ADK en WDS geïnstalleerd zijn

## Install SQL Server

- Ook een belangrijk deel van de SCCM server is het installeren van SQL Server.
    - Zorg ervoor dat de installatiemedia in de juiste drive van de VM zit, anders zal het script niet werken.
    - Hiervoor runnen we het script `install_sql_server_2017.ps1`
    - Als het script is uitgevoerd is het een goed idee om de server eens te herstarten.
    - Vervolgens kan je controleren of SQL Server wel degelijk geïnstalleerd is.

## Install and configure SCCM

- Natuurlijk moeten we op de SCCM server ook SCCM zelf installeren.
    - Run het script `install_SCCM.ps1`
    - Tijdens de uitvoer van dit script wordt er gevraagd om het schema uit te breiden. Hier zeg je yes en log je in met de Administrator gegevens. Het script gaat nu verder met de installatie.
    - Je kan ondertussen gerust iets anders gaan doen, het uitvoeren van dit script duurt namelijk enorm lang.
    - Als het script is uitgevoerd, is het een goed idee om de server eens te herstarten.
    - Vervolgens run je het script `configure_SCCM.ps1`

## Install MDT

- We moeten ook MDT installeren aangezien we dit moeten integreren in SCCM.
    - Run `Install_MDT.ps1`
    - Herstart de server en kijk of MDT geïnstalleerd is.

## MDT SCCM integration

- Nu begint het manuele werk. Om MDT te integreren in SCCM, run je het programma `Configure ConfigMgr Integration`
    - Vervolgens kies je voor `Install the MDT extensions...`
    - Vink beide dingen aan (install the MDT module en add the MDT task sequence)
    - Site server name = echo.CORONA2020.local
    - Site code: P01
    - Klik op Next en vervolgens op finish

## Task Sequence

### Voorbereiden van de Task Sequence

- Als eerste moeten we een gedeelde map aanmaken.
    - Op de C schijf maak je een map met als naam `CoronaShare`
    - Vervolgens rechtermuisklik je op `CoronaShare`, ga je naar properties, naar de tab sharing en klik je op share.
    - Controleer of het pad naar de map `\\ECHO\CoronaShare` is.
    - Klik op done.

- Vervolgens moeten we de nodige mappen aanmaken.
    - Maak de lege map `MDT Toolkit Package`
    - Maak de lege map `MDT Settings Package`
    - Maak de map `InstallImage` met `install.wim` en een map `Applicaties`met daarin de acrobat reader msi file.

- We moeten install.wim ook toevoegen in SCCM
    - In SCCM navigeer je naar `Software Library` en selecteer je `Operating Systems`
    - Rechtermuisklik op `Operating System Images` en klik vervolgens op `Add OS Image`
    - Navigeer naar `\\CoronaShare\InstallImage\install.wim` en selecteer `install.wim`. Klik op next.
    - Bij tab general klik je op next en bij tab summary klik je ook op next.

### Aanmaken Task Sequence

- Vervolgens ga je de task sequence aanmaken. 
    - In `Software Library` ga je naar `Operating Systems` en rechtermuisklik je op `Task Sequences`. Je selecteert `Create MDT Task Sequence`
    - Vervolgens selecteer je `Client Task Sequence` en klik je op next.
    - Je geeft de Task Sequence een naam en klikt op next.
    - Vervolgens selecteer je `Join a domain` en vul je bij domain `CORONA2020.local` in.
    - Bij `Set Account` geef je als username `CORONA2020\Administrator` en als password `Project3`. Vervolgens klik je op ok.
    - Bij `Windows Settings` geef je als username `CORONA IT` en als organisation name `Corona`
    - Het Administrator Account moet je enablen en als password kies je opnieuw voor `Project3`. Vervolgens klik je op confirm en daarna op next.
    - Capture Settings, Default = Never. Klik op next.
    - Specify Existing Boot Image, je browsed naar ...x64, klikt op ok en vervolgens op next.
    - MDT Package, Selecteer `Create new MDT Toolkit Package`. Vervolgens geef je het pad naar de juiste map `\\ECHO\CoronaShare\MDT Toolkit Package` en klik je op next.
    - MDT Details geef je als naam `MDT Toolkit Package` en je klikt op next.
    - OS Image, bij `Specify an Existing OS image` kies je voor de juiste Windows Versie. In ons geval `Windows 10 Entreprise Evaluation` en je klikt op next.
    - Als Deployment Method selecteer je `Perform a user driven installation` en klik op next.
    - Als client package selecteer je `Micr. Corp. Config. Man. Client Pack` en klik je op next.
    - Als USMT package selecteer je `Micr. Corp. User State Migr. Tool for Windows 10.0...` en klik je op next.
    - Als settings package selecteer je `Create new settings package`, je vult het pas in `\\ECHO\CoronaShare\MDT Settings Package` en klikt op next.
    - Bij settings details vul je als naam `MDT Settings Package` in en klik je op next.
    - Bij Sysprep package kies je voor `No sysprep package is required` en je klikt op next.
    - Vervolgens krijg je de summary. Je klikt op next en als laatste op finish.

### Applicatie toevoegen aan Task Sequence

- Ter illustratie willen we ook een applicatie toevoegen aan onze Task Sequence.
    - Je navigeert naar `Software Library` en selecteert `Application Management`.
    - Vervolgens rechtermuisklik je op `Applications` en selecteer je `Create application`.
    - Je gaat naar het pad `\\ECHO\SharedFolder\installImage\Applications\AcroRead.msi`. Vervolgens klik je op next. Daarna nog eens op next.
    - Bij `Installation Program` maak je van /q /qn en voeg je /norestart toe op het einde.
    - Bij `Install Behavior` selecteer je `Install for system` en klik je 2 maal op next en vervolgens op close.

### Aanpassen Task Sequence

- We gaan de auto apply drivers uitschakelen aangezien de client pc niet gebruikt zal worden in dit geval. 
    - Rechtermuisklik op de gemaakte Task sequence en slecteer edit.
    - Vervolgens navigeer je naar `Post Install` en selecteer je `Auto Apply Drivers`. Je navigeert naar het tab OPTIONS EN SELECTEERT `Disable this step`
    - Je klikt op apply.

- We moeten ook onze applicatie toevoegen aan de task sequence.
    - Navigeer naar `State Restore` en ga naar `Install Applications`. Hier selecteer je `Install Application`.
    - Vervolgens selecteer je `Install the following applications` en klik op het sterretje. Vink Acrobat Reader aan en klik op ok.
    - Klik op Apply en vervolgens op OK.

## WDS
- We hebben ook WDS nodig.
    - Je start Windows Deployment Services en rechtermuisklikt op de server echo.corona2020.local.
    - Vervolgens kies je voor `Configure Server` en klikt op next.
    - Je selecteert `Integrated with Active Directory` en klikt op next.
    - Vervolgens klik je nogmaals op next. Bij `PXE Server Initial Settings` kies je voor `Respond to all client computers (known and unknown)` en klikt op next.
    - Als laatste klik je op finish.

## DHCP

- Ook op de domaincontroller moeten we nog een kleinigheid toevoegen in verband met DHCP.
    - Op de DC open je DHCP en je navigeert naar `Scope options`. Je rechtermuisklikt hierop en kiest voor `Configure options`.
    - Je selecteert `066 Boot Server Host Name` en vult hier `echo` in.
    - Je selecteert ook `067 Bootfile name` en vult hier `boot\x64\wdsnbp.com` in. en klikt op apply.

## Client

- Als laatste stap moeten we natuurlijk de client aanmaken in Virtualbox.
    - Naam: Windows Client
    - Versie: Windows 10 (64 bit)
    - Geheugen: 4096 MB
    - Nieuwe VDI (Dynamisch gealloceerd 50GB)

    - Netwerkinstellingen  
        - 1 NAT Adapter
        - 1 Intern netwerk adapter (intnet)

    - Moederbord
        - Boot order
            - Netwerk
            - Harde Schijf

Als je deze Vm opstart zou deze met PXE boot moeten opstarten. Maar aangezien dat niet lukt met Virtualbox, is dit het verste dat we kunnen gaan.

## Einde
