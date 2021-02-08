# Testplan Mailserver
## Stappenplan
 - Start visual studio op en open een **bash** venster
 - Navigeer naar de project map
 - Start DNS en mailserver op door het volgende commando in te geven:
 ```
 vagrant up bravo delta
 ```
 - Nadat de 2 server zijn opgestart, open je een tweede bash venster en log je in op de mailserver.
 ```
 vagrant ssh delta
 ```
 - Dit tweede venster zullen we gebruiken om de uitvoer van de mailserver te bekijken.
 - Uitvoer bekijken doen we via het commando:
 ```
 sudo tail -f /var/log/maillog
 ```
 - Maak via virtualbox een virtuele machine aan die windows 10 draait.
 - Doorloop alle stappen.
 - Als de machine is opgestart, ga je naar de website: https://www.thunderbird.net/nl/
 - Installeer thunderbird.
 - Verander binnen de ip instellingen, de dns server naar: 192.168.55.3.
 - Start **thunderbird** op.
    - Ga naar **Account settings** (3 lijntjes in de rechterbovenhoek).
    - navigeer naar **Outgoing Server (SMTP)**.
    - Voeg een nieuwe server toe door te klikken op **Add**.
    - Als Server Name kies je voor: **delta.corona2020.local**
    - bij **Security and Authentication**:
        - Connection security: **STARTTLS**
        - Authentication method: **Normal password**
        - User Name: **smtpuser**

## aanmaken van mail accounts
- Klik binnen Account settings op **Account Actions** -> Add mail account.
- Hier krijg je een scherm waarop je kan inloggen met een account.
- In dit testplan zullen we testen gebruikmaken van de accounts van Manon en Jorn.
    - Your name: manonj
    - Email address: manonj@corona2020.local
    - Password: Project3
- klik daarna op **Configure manually**
    - Dan zie je een apart venster verschijnen met een Incoming en Outgoing server
    - verander **Server** naar delta.corona2020.local voor zowel  INCOMING als OUTGOING
    - klik op Re-test, een boodschap zou te zien moeten zijn: **The following settings were found by probing the given server**
    - Verander de waarden zodat de tabel er zo uit ziet:

| |INCOMING| OUTGOING  |   |   |
|---|---|---|---|---|
|Protocol   |IMAP  |SMTP   |   |   |
|Server  |delta.corona2020.local   |delta.corona2020.local   |   |   |
|Port   |143   |587   |   |   |
|SSL   |STARTTLS   |STARTTLS   |   |   |
|Authentication   |Normal password   |Normal password   |   |   |
|Username   |manonj   |manonj   |   |   |
    
- Klik op **Done** en je bent ingelogd op het account
- om de sturen van mail te testen, moet je nogmaals het **aanmaken van mail accounts** opnieuw doorlopen
- deze keer doe je het voor het account van jorn:
    - Your name: jornc
    - Email address: jornc@corona2020.local
    - Password: Project3

| |INCOMING| OUTGOING  |   |   |
|---|---|---|---|---|
|Protocol   |IMAP  |SMTP   |   |   |
|Server  |delta.corona2020.local   |delta.corona2020.local   |   |   |
|Port   |143   |587   |   |   |
|SSL   |STARTTLS   |STARTTLS   |   |   |
|Authentication   |Normal password   |Normal password   |   |   |
|Username   |jornc   |jornc   |   |   |

- beide accounts zijn nu ingelogd

- Als laatste ga je terug naar het hoofdscherm en zou je de twee accounts moeten zien
- Ga naar het account van Manon en klik op **write** (bovenaan)
- Dit opent een nieuw venster waarin je een mail kan sturen
- vul de velden in:
    - To: jornc@corona2020.local
    - Subject: test
    - In het tekstveld: test
    - klik op **send**
    - als je een wachtwoord moet ingeven voor de smtpuser is dit: Project3
- de mail zou verstuurt moeten zijn, je kan dit checken door naar de **Inbox** te gaan van jorn@corona2020.local. De test mail zou zichtbaar moeten zijn



