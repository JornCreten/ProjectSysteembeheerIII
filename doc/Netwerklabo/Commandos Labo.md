# Commando's 

## Deel2: 
### Stap2
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
### Stap3:
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
### Stap4:
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
### Stap5:

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
    default-information originate
 ### Stap6:
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


# ACLs

## DEEL 3 STAP 1
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

## DEEL 3 STAP 2

a:

    ipv6 access-list RESTRICTED-LAN
    deny tcp any 2001:DB8:ACAD:A::/64 eq telnet
    permit ipv6 any any

b:

    int g0/0/1
    ipv6 traffic-filter RESTRICTED-LAN out

d:

    show access-lists

f:

    show access-list RESTRICTED-LAN

## DEEL 4 

### STAP 1
    int g0/0/1
    no ipv6 traffic-filter RESTRICTED-LAN out

### STAP 2
    show access-lists

### STAP 3
    Het zorgt er voor dat hosts van het 2001:DB8:ACAD:B::/64 kunnen
    telnetten naar Switch 1 (S1)

### STAP 5
    show access-lists
    Als je nog in een ACL configuratie zit: do show access-lists

### STAP 6
    no permit tcp any host 2001:DB8:ACAD:A::3 eq www

### STAP 7
    show access-list RESTRICTED-LAN
    Als je nog in een ACL configuratie zit: do show access-list RESTRICTED-LAN

### STAP 8
    int g0/0/1
    ipv6 traffic-filter RESTRICTED-LAN out
