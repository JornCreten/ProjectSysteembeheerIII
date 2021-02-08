# Emailserver documentatie
De configuratie is bedoeld om een Emailserver op te stellen, waarmee er binnen het domein 'corona2020.local', mailverkeer kan plaatsvinden.

## Gebruikte rollen
Voor het configureren van de Emailserver wordt er gebruik gemaakt een aantal voorgedefinieerde rollen afkomstig van Ansible Galaxy.
Deze rollen zijn:
- rh-base (configuratie van user en wachtwoord)
- mailserver-master (configuratie van mailserver)
- Om deze rollen toe te voegen aan je project, ga je als volgt te werk:
    - Clone of download de gewenste rollen van de GitHub repository
    - Navigeer naar de map: p3ops-2021-a01/src/ansible/roles
    - plaats de rollen hierin
    - rollen die toegevoegd moeten worden:
        - bertvv-mailserver: https://github.com/bertvv/ansible-role-mailserver.git
        - bertvv-rh-base: https://github.com/bertvv/ansible-role-rh-base.git

## initiële configuratie
- Navigeer naar het bestand: **p3ops-2021-a01/src/vagrant-hosts.yml**.
- In dit bestand plaats je de volgende code:
    ```
    name: delta
    box: bento/centos-8.2
    ip: 192.168.55.5
    ```
- Dit zorgt ervoor dat er wordt gebruik gemaakt van de laatste versie van Ansible en dat de machine het juiste IP krijgt.

## site.yml
- Navigeer naar het bestand: **p3ops-2021-a01/src/ansible.site.yml**.
- Hier binnen definiëren we de verschillende hosts.
- In dit bestand plaays je de volgende code:
    ```
  - hosts: delta
    roles: 
        - ansible-role-rh-base-master
        - ansible-role-mailserver-master
        - custom.resolv_conf
    ```

## COnfiguratie van het hoofdbestand
- Maak binnen de map: **p3ops-2021-a01/src/ansible/host_vars**, een nieuw bestand aan genaamd **delta.yml**
- Als eerste zullen we een aantal nodige/handige packages installeren:
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
        - telnet
    ```

- Dan zullen we een aantal services toevoegen aan de firewall, voor de goede werking van de Mailserver te kunnen garanderen:

    ```
    rhbase_firewall_allow_services:
        - imap
        - imaps
        - pop3
        - pop3s
        - smtp
        - smtps
        - smtp-submission
    ```

- Hier volgt de configuratie van de hostname en het domein waarin gewerkt wordt:

    ```
    postfix_myhostname: delta.corona2020.local
    postfix_mydomain: corona2020.local
    ```

- Als laatste volgt de configuratie van de verschillende users die u op de mailserver wilt hebben. */sbin/nologin* zorgt ervoor dat de gebruiker kan inloggen op de mailserver maar niet op de Linux machine

    ```
    rhbase_users:
     - name: yvesvdd
        password: '$6$eFpVtcpnGKJxv4tX$3WBM6.3yvhlDd/vdupLjqK5MBf81A2vQyY1h13Go7k1GGLRYnI6W5uYttGS9yIbXpakwlh3j8qpDamNlAYR/c0'
        shell: /sbin/nologin
     - name: svendv
        password: '$6$eFpVtcpnGKJxv4tX$3WBM6.3yvhlDd/vdupLjqK5MBf81A2vQyY1h13Go7k1GGLRYnI6W5uYttGS9yIbXpakwlh3j8qpDamNlAYR/c0'
        shell: /sbin/nologin
    - name: manonj
        password: '$6$eFpVtcpnGKJxv4tX$3WBM6.3yvhlDd/vdupLjqK5MBf81A2vQyY1h13Go7k1GGLRYnI6W5uYttGS9yIbXpakwlh3j8qpDamNlAYR/c0'
        shell: /sbin/nologin
    - name: dariovh
        password: 'Project'
        shell: /sbin/nologin
    - name: jornc
        password: '$6$eFpVtcpnGKJxv4tX$3WBM6.3yvhlDd/vdupLjqK5MBf81A2vQyY1h13Go7k1GGLRYnI6W5uYttGS9yIbXpakwlh3j8qpDamNlAYR/c0'
        shell: /sbin/nologin
    - name: smtpuser
        password: '$6$eFpVtcpnGKJxv4tX$3WBM6.3yvhlDd/vdupLjqK5MBf81A2vQyY1h13Go7k1GGLRYnI6W5uYttGS9yIbXpakwlh3j8qpDamNlAYR/c0'
        shell: /sbin/nologin
    ```


