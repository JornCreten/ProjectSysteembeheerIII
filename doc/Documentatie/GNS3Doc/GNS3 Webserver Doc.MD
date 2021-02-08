# Documentatie GNS3

## Stappenplan hoe connecten met aws gns3 server

* Download cmder en open dit programma. 
* Vervolgens type je het commando ssh -l ubuntu 54.242.112.167 -i (link naar je key) vb: c:\users\username\downloads\jekey.pem
* Normaal gezien zou je nu een link moeten zien die eindigt op .ovpn Deze moet je kopiëren en in je browser plakken. (Dit download een bestand)
* Vervolgens download je openvpn via deze link https://openvpn.net/community-downloads/
* Je klikt met de rechtermuisknop op het icoontje van openvpn en klikt op bestand importeren.
* Je kiest vor het .ovpn bestand dat je daarnet gedownload hebt en klikt daarna op connect.
* Vervolgens start je GNS3 en ga je naar preferences > server
* Uncheck "enable local server" 
* Bij host vul je 172.16.253.1 in, bij port zet je 3080 TCP en zorg ervoor dat auth unchecked is.
* Je zou nu connected moeten zijn met de gns3 server

## Bronnen

Hier zijn een aantal bronnen die ik tot nu toe gebruikt heb om een aantal taken te realizeren:

- (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-eips-allocating)
- (https://www.youtube.com/watch?v=8uxEtWDleDQ&t=712s&ab_channel=RobOrndoff)
- (https://aws.amazon.com/premiumsupport/knowledge-center/new-user-accounts-linux-instance/)
