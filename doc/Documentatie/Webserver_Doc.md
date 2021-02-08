# Documentatie Webserver:
Author: Jorn Creten

## Gebruikte features, services & rollen:

In deze opstelling wordt gebruik gemaakt van een aantal prebuilt ansible galaxy rollen en een aantal rollen die ik zelf geschreven heb. Deze houden in:
- php door Jeff Geerling
- postgresql door Jeff Geerling
- Nginx door Jeff Geerling
- Drupal: Geschreven door Jorn Creten
- Webserver: Geschreven door Jorn Creten

## Aanpassingen te maken:
- in php: niks
- in postgresql:
    - We moeten nog de credentials voor de aan te maken database invoegen:
        ```
        postgresql_databases:
            - name: drupaldb
              owner: admin

        postgresql_users:
            - name:
              password: pass
        ```
    - Plaats deze onder group_vars in all.yml of in hostr_vars onder charlie.yml
    - Deze variables zorgen ervoor dat de databank met de juiste naam, eigenaar en wachtwoorden worden aangemaakt voor een Drupal website te kunnen installeren.

## Documentatie Drupal:
Deze rol heb ik zelf geschreven voor het project aangezien er geen degelijke drupalrollen beschikbaar leken te zijn die deden wat ik nodig had (nignx + postgresql). De rol gebruikt waar mogelijk ansible builtin modules om alle configuraties uit te voeren.

- Downloadt, extract en verplaatst de directory naar /var/www/html
```
- name: Download drupal
  get_url:
    url: https://ftp.drupal.org/files/projects/drupal-{{ DRUPAL_VERSION }}.tar.gz
    dest: /home/vagrant/drupal-{{ DRUPAL_VERSION }}.tar.gz

- name: extract package
  unarchive:
    src: /home/vagrant/drupal-{{ DRUPAL_VERSION }}.tar.gz
    dest: /home/vagrant
    remote_src: true

- name: make drupal dir
  file:
    path: /var/www/html/drupal
    state: directory

- copy:
    src: /home/vagrant/drupal-{{ DRUPAL_VERSION }}/
    dest: /var/www/html/drupal/
    remote_src: true
``` 
- Kopieert de nodige config files vanuit de templates folder naar de nodige folders
```
 name: make sites default folder
  file:
    path: /var/www/html/drupal/sites/default/files
    state: directory

- name: Copy file to php page 
  copy:
    src: /var/www/html/drupal/sites/default/default.settings.php
    dest: /var/www/html/drupal/sites/default/settings.php
    mode: '0755'
    remote_src: true

- name: nginx php-fpm config file
  template: 
    dest: /etc/php-fpm.d/
    src: phpdrupal.conf

- name: Rename phpdrupal to drupal.conf for /etc/php-fpm
  copy:
    src: /etc/php-fpm.d/phpdrupal.conf
    dest: /etc/php-fpm.d/drupal.conf
    mode: '0755'
    remote_src: true

- name: remove phpdrupal because it messes with the php-fpm daemon and this is a nasty workaround
  file:
    path: /etc/php-fpm.d/phpdrupal.conf
    state: absent


- name: nginx drupal.d config file
  template: 
    dest: /etc/nginx/conf.d
    src: drupal.conf
```

- Dit managet al de permissies die nginx nodig heeft om de webpagina te kunnen tonen en waar nodig aanpassingen te maken.

```
- name: Selinux permissions
  sefcontext:
    target: "/var/www/html/drupal(/.*)?"
    setype: httpd_sys_rw_content_t
    state: present
  sefcontext:
    target: '/var/www/html/drupal/sites/default/settings.php'
    setype: httpd_sys_rw_content_t
    state: present
  sefcontext:
    target: '/var/www/html/drupal/sites/default/files'
    setype: httpd_sys_rw_content_t
    state: present

- name: set permissions
  shell: restorecon -Rv /var/www/html/drupal
  shell: restorecon -v /var/www/html/drupal/sites/default/settings.php
  shell: restorecon -Rv /var/www/html/drupal/sites/default/files
 
- name: Recursively change ownership of a directory
  file:
    path: /var/www/html/drupal/
    state: directory
    recurse: yes
    owner: nginx
    group: nginx
```

## Documentatie Webserverrol
Deze rol doet enkele simpele taken zoals de juiste services aanzetten en bepaalde poorten in de firewall (http & https) open zetten
```
- name: start firewalld
  service:
    name: firewalld
    state: started
    enabled: yes

- firewalld:
    port: 80/tcp
    permanent: true
    state: enabled

- firewalld:
    port: 443/tcp
    permanent: true
    state: enabled

- name: reload service firewalld
  systemd:
    name: firewalld
    state: reloaded

```