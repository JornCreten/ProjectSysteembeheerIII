# Testplan DNS
## Stappenplan
  - Open 2 **git bash** vensters (Een voor de servers op te starten en een voor het inloggen op de servers)
  - In het eerste venster start je de dns server en de andere servers op door het commando
  ```
  vagrant up [servername]
  ```
  - Nadat de servers zijn opgestart log je in op de DNS server in het tweede venster
  ```
  vagrant ssh bravo
  ```
  - We zullen als eerste kijken of de DNS server de andere servers kan bereiken door te pingen naar deze servers
  ```
  ping [ip andere server]
  ```
  - We zouden hier replies moeten krijgen. Als dit zo is dan is dit al een eerste goede teken
  - nu gaan we kijken of een **nslookup** werkt op de dns server zelf vooraleer we dit op andere servers testen
  ```
  nslookup icanhazip.com 192.168.55.3
  ```
  - Dit zou moeten werken zonder een fout te geven
  - Log nu uit op de DNS server en log in op een van de andere servers (bv. delta)
  ```
  exit
  vagrant ssh delta
  ```
  - Als eerste stap zullen we kijken of de server de DNS kan berijken door naar de DNS te pingen
  ```
  ping 192.168.55.3
  ```
  - Als dit werk en dus replies geeft, zullen we kijken of we ook nslookup zonder fouten kunnen runnen
  ```
  ping icanhazip.com
  ```
  - Dit zou ook moeten werken en tonen dat dit via de server **192.168.55.3** gerunned heeft
  - Als dit een andere server toont, kijk dan na of het DNS server adres in het **resolv.conf** bestand staat
  ```
  cat /etc/resolv.conf
  ```
  - Als het adres hier niet bij staat, voeg je dit toe door
    - `sudo vi /etc/resolv.conf`
    - klik op **i**
    - `nameserver 192.168.55.3`
    - klik op **esc**
    - geef **:wq** in
  - Als alle tests slagen dan zou de dns server moeten werken
