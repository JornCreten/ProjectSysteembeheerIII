# Testrapport DC

  Uitgevoerd: 22/11/2020
  Tester: Dario Van Heck
 
 ## Opstelling 
 
 Er werden geen problemen ondervonden bij het aanmaken van de opstelling van de Virtual Machine.
 
 ## Opstart Configuratie
 
 De configuratie is zeer straight-forward en makkelijk te volgen. Er waren hier dus geen problemen.
 
 ## VirtualBox / Persoonlijke map
 
 Deze stappen waren ook makkelijk te volgen en gaven geen problemen
 
 ## RenameComputer
 
 Het script werkt door er op te rechtermuiklikken en **run with powershell**. Hierna moesten we de Execution Policy nog aanpassen door **a** in te geven.
 (Dit stond niet in de documentatie, dus zou voor sommige personen wel problemen kunnen geven).
 
 Verder slaagde het script perfect. De naam van de computer is nu ```alfa``` 
 
 ## AddADDSRole
 
 Na het runnen van het script, zijn alle instellingen juist aangepast. Ethernet 2 adapter kreeg het ip ```192.168.55.2```. Het Domein is veranderd naar ```CORONA2020.local```
 
 ## AddDHCPRole
 
 Het script is succesvol uitgevoerd. Volgende instellingen werden juist aangemaakt:
  - Gedistribueerde addressen zijn: ```192.168.55.1``` tot en met ```192.168.55.254```
  - De geblokkeerde addressen zijn: ```192.168.55.1``` tot en met ```192.168.55.6```
  - De scope options ```Router, DNS Servers, Domain Name``` zijn aangemaakt
 
 ## AddOUs
 
 Het script is geslaagd en de nodige OU's zijn aangemaakt. De aangemaakte OU's zijn:
  - Administratie
  - Directie
  - IT Administratie
  - Ontwikkeling
  - Verkoop
 
 ## AddGroups
 
 De nodige groepen zijn aangemaakt, namelijk
  - Administratie
  - Directie
  - IT Administratie
  - Ontwikkeling
  - Verkooop
 
 ## AddNewUsers
 
 De eerste keer gaf het script een error. Dit kwam omdat de csv files niet in de map van de scripts stonden (aangezien dit niet in het testplan vermeld werd). Nadat dit werd aangepast slaagde het script en werden de volgende gebruikers werden aangemaakt
  - Sven De Vuyst
  - Manon Joly
  - Yves Vandendooren
  - Dario Van Heck
  - Jorn Creten
 
 ## AddUsersToGroups
 
 De aangemaakte users uit vorige stap werden aan volgende groepen toegevoegd
  - Sven De Vuyst --> Administratie
  - Manon Joly --> Directie
  - Yves Vandendooren --> IT Administratie
  - Dario Van Heck --> Ontwikkeling
  - Jorn Creten --> Verkoop
 
 ## AddComputers
 
 De computers werden aangemaakt. In de ```Werkstations```OU werden volgende computers toegevoegd
  - AdminPC
  - DirectiePC
  - ITAdminPC
  - OntwikkelingPC
  - VerkoopPC
 
 ## AddComputersToGroups
 
 De computers werden aan de juiste groepen toegekend. Volgende computers werden toegekend aan volgende groepen
  - AdminPC --> Administratie
  - DirectiePC --> Directie
  - ITAdminPC --> IT Administratie
  - OntwikkelingPC --> Ontwikkeling
  - VerkoopPC --> Verkoop
 
 ## DNS
 
 ## AddDFSRole + Configuratie DFS
 
 Het script is succesvol uitgevoerd en de test file is aangemaakt. Na het aanmaken van de namespace met gegevens werd ook de text file aangemaakt.
  - Server: alfa
  - Name: CoronaSpace
  - Stand-Alone namespace
 
 ## Group Policies
 
 Het script is zonder problemen uittgevoerd. De OU's ``` Alfa DC, Administratie, Directie, IT Administratie, Ontwikkeling, Verkoop en Werkstations``` zijn aanwezig. Volgende groep policies werden ook aangemaakt:
  - FileSystemDFSVoorUsers
  - VerbiedToegangTotControlPanel
  - VerbiedToegangTotNetwerkAdapters
  - VerwijderGameUitStart
 
 ## Controleren Alle GPO's
 
 Alle GPO's zijn aangemaakt met de juiste instellingen
  - FileSystemDFSVoorUsers --> Logged-on users security en Item-level targetting staan aan
  - VerbiedToegangTotControlPanel --> Prohibit Access to Control Panel en PC Settings staat aan
  - VerbiedToegangTotNetwerkAdapters --> Prohibit access to components of LAN connection staat aan
  - VerwijderGameUitStart --> Microsoft.MicrosoftSolitaireCollection wordt geblokkeerd
 
 
 
