# Testplan Netwerklabo

Geschreven door: Sven De Vuyst

## Opstelling (DEEL 1)

Als eerste gaan we de volledige opstelling opzetten in Packet Tracer.
- Gebruik 3x Router 4321
- Gebruik 3x Switch 2960 (IOS 15) te vinden in "Miscellaneous"
- Gebruik 3x PC

![Opstelling Netwerklabo](labo/Opstelling.png)

Hier vind je ook nog eens de adressentabel met alle IP's

![Adrestabel](labo/Adrestabel.png)

## Configuratie (DEEL 2)

### STAP 1

Nu gaan we eerst elke PC een IPv6 adres gaan geven en een Default gateway.

- PC-A: 2001:DB8:ACAD:A::3/64 
Default Gateway: FE80::1
- PC-B: 2001:DB8:ACAD:B::3/64
Default Gateway: FE80::1
- PC-C: 2001:DB8:ACAD:C::3/64
Default Gateway: FE80::3

![PC Configuratie](labo/PCConfig.png)

We gaan tevens ook bij elke router een module "NIM-2T" gaan aansluiten zodat we de Seriele poorten kunnen gebruiken.
Dit doe je door de Router uit te zetten de "NIM-2T" module aan de zijkant in de router te slepen en dan de Router weer aan te zetten.

![Router module](labo/Routermodule.png)

### STAP 2

Nu gaan we de configuratie van alle Switches doen. (S1 / S2 / S3)

S1 / S2 / S3: 

    VOOR IETS TE DOEN:
    sdm prefer dual-ipv4-and-ipv6 default
    reload je switch hierna en save de configuration

    hostname S1 (S2 / S3)
    no ip domain-lookup
    ip domain-name ccna-lab.com
    service password-encryption
    banner motd "Toegang voor onbevoegden is verboden"
    username admin password classadm
    enable secret class
    line console 0
    password cisco
    login
    crypto key generate rsa (1024)
    line vty 0 15
    transport input all
    login local
    int vlan1
    ipv6 enable
    ipv6 address 2001:DB8:ACAD:A::A/64 (Verander dit door het IP van S2 / S3 bij hun configuratie.)
    no shut

 ### STAP 3

 Nu gaan we de basisconfiguratie van alle Routers doen. (S1 / S2 / S3)

 R1 / R2 / R3:

    hostname R1 (R2 / R3)
    no ip domain-lookup
    ip domain-name ccna-lab.com
    service password-encryption
    banner motd "Toegang voor onbevoegden is verboden"
    username admin password classadm
    enable secret class
    line console 0
    password cisco
    login
    crypto key generate rsa [1024]
    line vty 0 15
    transport input all
    login local

### STAP 4

Individuele IPv6 configuratie van R1

R1:

    ipv6 unicast-routing

    int g0/0/0
    ipv6 enable
    ipv6 address 2001:DB8:ACAD:B::1/64
    no shut
    ipv6 address FE80::1 link-local 
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    int g0/0/1
    ipv6 enable
    ipv6 address 2001:DB8:ACAD:A::1/64
    no shut
    ipv6 address FE80::1 link-local
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    int s0/1/0
    clock rate 128000
    ipv6 enable
    ipv6 address 2001:DB8:AAAA:1::1/64
    no shut
    ipv6 address FE80::1 link-local
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    int s0/1/1
    ipv6 enable
    ipv6 address 2001:DB8:AAAA:3::1/64
    no shut
    ipv6 address FE80::1 link-local
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    ipv6 router ospf 10
    router-id 1.1.1.1
    auto-cost reference-bandwidth 1000
    passive-interface g0/0/0
    passive-interface g0/0/1

### STAP 5

Individuele IPv6 configuratie van R2

R2:

    ipv6 unicast-routing

    int s0/1/0
    ipv6 enable
    ipv6 address 2001:DB8:AAAA:1::2/64
    no shut
    ipv6 address FE80::2 link-local
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    int s0/1/1
    clock rate 128000
    ipv6 enable
    ipv6 address 2001:DB8:AAAA:2::2/64
    no shut
    ipv6 address FE80::2 link-local
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    int Lo1
    ipv6 enable
    ipv6 address 2001:DB8:AAAA:4::1/64
    no shut
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    ipv6 route ::/0 Lo1

    ipv6 router ospf 10
    router-id 2.2.2.2
    auto-cost reference-bandwidth 1000

### STAP 6

Individuele IPv6 configuratie van R3

R3:

    ipv6 unicast-routing

    int s0/1/0
    clock rate 128000
    ipv6 enable
    ipv6 address 2001:DB8:AAAA:3::2/64
    no shut
    ipv6 address FE80::3 link-local
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    int s0/1/1
    ipv6 enable
    ipv6 address 2001:DB8:AAAA:2::1/64
    no shut
    ipv6 address FE80::3 link-local
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    int G0/0/1
    ipv6 enable
    ipv6 address 2001:DB8:ACAD:C::1/64
    no shut
    ipv6 address FE80::3 link-local
    ipv6 ospf 10 area 0 (Doe dit na dat je OSPF activeert op de Router)

    ipv6 router ospf 10
    router-id 3.3.3.3
    auto-cost reference-bandwidth 1000
    passive-interface G0/0/1

### STAP 7

Alle PC's moeten naar elkaar kunnen pingen

- ping 2001:DB8:ACAD:A::3
- ping 2001:DB8:ACAD:B::3
- ping 2001:DB8:ACAD:C::3

Telnet & SSH naar R1 met alle PC's:

- telnet 2001:DB8:ACAD:A::1

Voor SSH ga je naar de PC en klik je bij het tab "Desktop" op Telnet / SSH Client

Geef het IP: 2001:DB8:ACAD:A::1
Login met admin & password: classadm

Telnet & SSH naar S1 met alle PC's:

- telnet 2001:DB8:ACAD:A::A

Voor SSH ga je naar de PC en klik je bij het tab "Desktop" op Telnet / SSH Client

Geef het IP: 2001:DB8:ACAD:A::A
Login met admin & password: classadm

## ACL's (DEEL 3 & 4)

### DEEL 3 STAP 1

a:

    ipv6 access-list RESTRICT-VTY
    permit tcp 2001:DB8:ACAD:A::/64 any
    permit tcp any any eq 22
    deny tcp any any eq 23
b:

    line vty 0 15
    ipv6 access-class RESTRICT-VTY in

c:

    show access-lists
![Uitvoer Commando](labo/Router1_Deel3_C1.png)

### DEEL 3 STAP 2

a:

    ipv6 access-list RESTRICTED-LAN
    deny tcp any 2001:DB8:ACAD:A::/64 eq telnet
    permit ipv6 any any

b:

    int g0/0/1
    ipv6 traffic-filter RESTRICTED-LAN out

d:

    show access-lists
![Uitvoer Commando](labo/Router1_Deel3_2D.png)

f:

    show access-list RESTRICTED-LAN
![Uitvoer Commando](labo/Router1_Deel3_F2.png)

### DEEL 4 STAP 1

    int g0/0/1
    no ipv6 traffic-filter RESTRICTED-LAN out

### DEEL 4 STAP 2

    show access-lists
![Uitvoer Commando](labo/Router1_Deel4_Stap2.png)

### DEEL 4 STAP 3

    Het zorgt er voor dat hosts van het 2001:DB8:ACAD:B::/64 kunnen telnetten naar Switch 1 (S1)

### DEEL 4 STAP 4

    permit tcp any host 2001:db8:acad:a::3 eq www 

### DEEL 4 STAP 5

    show access-lists
    Als je nog in een ACL configuratie zit: do show access-lists
![Uitvoer Commando](labo/Router1_Deel4_Stap5.png)

### DEEL 4 STAP 6

    ipv6 access-list RESTRICTED-LAN
    no permit tcp any host 2001:db8:acad:a::3 eq www

### DEEL 4 STAP 7

    show access-list RESTRICTED-LAN
    Als je nog in een ACL configuratie zit: do show access-list RESTRICTED-LAN
![Uitvoer Commando](labo/Router1_Deel4_Stap7.png)

### DEEL 4 STAP 8

    int g0/0/1
    ipv6 traffic-filter RESTRICTED-LAN out