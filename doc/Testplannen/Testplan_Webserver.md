# Testplan Webserver
## Opstelling reproduceren
- `vagrant up charlie`
## Testen van opstelling
- surf naar 192.168.55.4
- surf ook naar https://192.168.55.4
- Indien de drupal pagina getoond wordt, zou alles moeten werken.
- u kan het self-signed certificate goedkeuren. dit is omdat dit een testopstelling is.
- Doorloop de wizard indien een pagina nog niet opgezet is
- Kies eender welk profile. Demo is een goede manier om te testen of alles werkt.
- Bij database kies postgresql en geef de gegevens in die gekozen werden in de defaults file van postgresql (drupaldb, admin, pass)
- Doorloop de rest van de wizard
- Indien een webpagina correct getoond wordt met afbeeldingen is de installatie correct verlopen.
- Indien dit nog niet het geval is, wacht even en refresh de pagina
- Log in op de server met `vagrant ssh charlie`
- Controleer of alle services die nodig zijn draaien:
    - `Systemctl status nginx`
    - `Systemctl status postgresql`  
    - `Systemctl status php-fpm`
- Controleer of de juiste firewallpoorten open staan: `sudo firewall-cmd --list-all`, 80 & 443 of http & https zijn nodig
- Controleer of drupal in de html directory staat: `cd /var/www/html `
- Controleer of nginx owner is van deze files: `ls -l`