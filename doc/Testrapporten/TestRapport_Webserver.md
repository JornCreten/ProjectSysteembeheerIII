# Testrapport Webserver

  Uitgevoerd: 22/11/2020
  Tester: Dario Van Heck
  
## Testing van de opstelling

  - Na het opstarten van de server was het mogelijk om te surfen naar 192.168.55.4
  - Er kon ook naar https://192.168.55.4 gegaan worden
  - We doorliepen de wizard, deze werd succesvol afgelopen
  - De webpagine werd getoont met de nodige afbeeldingen
  - Na het inloggen op de server zien we dat
    - nginx is aan het draaien
    - postgresql is aan het draaien
    - php-fpm is aan het draaien
  - Zowel poort 80 als poort 443 staan open
  - Drupal staat in de directory **/var/www/html** en nginx is de owner van deze files
  
## Conclusie
Het testplan is perfect verlopen en hier was geen enkel probleem. 
