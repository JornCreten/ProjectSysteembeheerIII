# Testrapport DNS

Uitgevoerd: 08/12/2020
Tester: Manon Joly

## Stappenplan

- We openen een bash venster en starten de DNS en mailserver op met het commando `vagrant up bravo delta`. Dit lukt zonder fouten.

- We openen een tweede bash venster en loggen in op delta aan de hand van ssh. Dit lukt.

- Het tweede bash venster gebruiken we om de logs van de mailserver te bekijken. We voeren het commando uit.

- We maken een virtuele machine aan in virtualbox die windows 10 draait.

- We installeren thunderbird.

- We veranderen bij ip de dns server naar het ip adres van onze dns server.

- We starten thunderbird en gaan naar accountsettings > Outgoing Server (SMTP) en voegen een nieuwe server toe. We voegen hier delta.corona2020.local toe en volgen de settings van in het testplan.

- Vervolgens gaan we een account aanmaken. Account settings > Account actions > Add mail account.

- We volgen de instellingen van in het testplan om de accounts van Manon en Jorn aan te maken. Dit lukt en we zijn nu ingelogd op beide accounts.

- We gaan terug naar het hoofdscherm en zien daar beide accounts.

- We gaan naar het account van Manon en klikken op write, we gaan een mail sturen naar Jorn om te testen of de mailserver effectief werkt.

- We zien nu bij Jorn zijn inbox dat de test mail is aangekomen. De mailserver lijkt dus te werken.