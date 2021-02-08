## DNS Documentatie
Volg de stappen zoals ze hier geschreven staan in deze volgorde, dit zou een DNS server succesvol moeten kunnen opzetten.

### 1) vagrant-hosts.yml
  - Navigeer naar **p3ops-2021-a01/src/vagrant-hosts.yml**
  - Hier moet de DNS server toegevoegd worden, samen met het ip-adres
  - Voeg volgende code toe aan het bestand:
  ```
  - name: bravo
    box: bento/centos-8.2
    ip: 192.168.55.3
  ```
  
### 2) site.yml
  - Navigeer naar **p3ops-2021-a01/src/ansible/site.yml**
  - De server moet hier toegevoegd worden samen met de benodigde rollen hiervoor
  - Voeg hiervoor volgende code toe:
  ```
  - hosts: bravo
    roles:
      - bertvv.rh-base
      - bertvv.bind
  ``` 
  
### 3) roles
  - De benodigde rollen zullen nu nog moeten gedownload worden.
  - Navigeer eerst naar **p3ops-2021-a01/src/ansible/roles/**
  - Maak hier de mappen aan waar je de rollen zal in toevoegen. Het is belangrijk dat deze dezelfde naam hebben als in het      **site.yml** bestand
      - Maak map aan: **bertvv.rh-base**
      - Maak map aan: **bertvv.bind**
  - De rollen moeten nu gedownload en toegevoegd worden
      - **bertvv.rh-base:** https://github.com/bertvv/ansible-role-rh-base
      - **bertvv.bind:** https://github.com/bertvv/ansible-role-bind
  - Download deze rollen als een ZIP-bestand en pak ze uit in de juist mappen
  
### 4) bravo.yml
  - Navigeer naar **p3ops-2021-a01/src/ansible/**
  - Maak een nieuw bestand **bravo.yml** aan
  - Als eerste stap zullen de nodige packages geïnstalleerd moeten worden
  ```
  rhbase_install_packages:
    - bind-utils
    - bash-completion
    - git
    - nano
    - vim-enhanced
    - tree
    - wget
    - samba-client
  ``` 
  - Hierna zullen we instellen dat de nodige services zullen starten bij de opstart van de server en ze door de firewall laten
  ```
  rhbase_start_services:
    - named
    
  rhbase_firewall_allow_services:
    - dns
  ```
  - We zullen instellen naar welke adressen en queries er wordt geluisterd
  ```
  bind_listen_ipv4:
    - any
    
  bind_allow_query:
    - any
  ```
  - Recursie moet aan staan vooraleer de DNS kan werken
  ```
  bind_recursion: true
  ```
  - Nu moeten we de bind zones instellen. Hier zullen we dus de servers in ons domein moeten toevoegen
  ```
  bind_zones:
  - name: corona2020.local
#    create_reverse_zones: true 
#    create_forward_zones: true  
    primaries:
      - 192.168.55.3
    name_servers:
      - bravo.corona2020.local.
    networks:
      - '192.168.55'
    hosts:
      - name: alfa
        ip: 192.168.55.2
      - name: bravo
        ip: 192.168.55.3
        aliases:
          - ns1
      - name: '@'   #charlie
        ip: 192.168.55.4
        aliases:
          - www
      - name: delta
        ip: 192.168.55.5
        aliases:
          - mail-in
          - mail-out
          - nx
      - name: gamma
        ip: 192.168.55.100
    mail_servers:
      - name: delta
        preference: 10
  ```
  - De forwarders moeten extern zijn
  ``` 
  bind_forwarders:
    - "8.8.8.8"
    - "8.8.4.4"
  ```
  - Als laatste moeten de access lists aangemaakt worden
  ```
  bind_acls:
    - name: trusted
      match_list:
        - 192.168.55.0
        - 192.168.55.3
  ```

