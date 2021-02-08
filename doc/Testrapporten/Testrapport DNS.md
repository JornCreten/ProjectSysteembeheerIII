# Testrapport DNS

Uitgevoerd: 26/11/2020
Tester: Sven De Vuyst

## Stappenplan

- 2 git bash vensters staan open, alle servers (`bravo`, `charlie`, `delta`, `gamma`) zijn correct opgestart.

- ssh'en / inloggen op server `bravo` lukt.

- Het pingen naar alle servers (`bravo`, `charlie`, `delta`, `gamma`) lukt.

- Het gebruiken van `nslookup icanhazip.com 192.168.55.3` werkt en geeft informatie weer.

- ssh'en / inloggen op server `delta` lukt.

- Het pingen van de DNS Server lukt via commando `ping 192.168.55.3`

- Het pingen naar `icanhazip.com` lukt via het commando `ping icanhazip.com`

- nslookup werkt hier ook via het commando `nslookup icanhazip.com` en geeft informatie weer dat het gerund is via de DNS Server.

- De nameserver staat correct in het bestand `/etc/resolv.conf`

- Alle stappen zijn geslaagd en de DNS Server lijkt te werken.