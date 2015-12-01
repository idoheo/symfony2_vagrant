Vagrant PHP Dev box
===================

Description
-----------

This is a Vagrant box that is setup to build a Nginx and Php 5 FPM development environment. It is also preconfigured for Symfony2 development, but Symfony2 setup can be disabled resulting in standard PHP app development box. System provisioning is done by Ansible, running from within the guest system.

Ansible Playbooks
-----------------
In vagrant/ansible you will find a dist folder containing distribution copy of ansible configuration. When needed this files will be copied into vagrant/ansible folder if not already present. Playbook-once files contain everything you want to run only during initial (or manualy triggered) provisioning. Playbook-always files contain everything that should run during each start. You can modifiy roles and common/independent varialbes trough files originaly located in ansible dist folder.

IP Address
----------
By default a host only visible IP network will get created by Virtual Box (192.168.100.x) and the guest box will bind to 192.168.100.254 (last available IP address). Usualy the host machine gets assigned 192.168.100.1 (first available IP address). If you need this changed, please correct the Vagrant file and common playbook variables file for Ansible.

Web ports
---------
Following web ports are going to be used for following roles:

- 80 - Dev site role
- 443 - Dev site HTTPS role
- 1080 - Log.io - Tool to keep track of Log files created by other roles in this box
- 1081 - PhpMyAdmin (with Nginx)
- 1082 - MailHog web gui (SMTP server localy installed on default port, that catches mails and does not move them along)
- 1083 - Mongo Management studio
- 1084 - Redis Commander
- 1085 - Git Web UI (only starts if git is initialized at web source)
- 1088 - Pinba GUI (Php profiling)
- 1089 - CodeBox


Note that where it was possible, login system was put in place. Username and password by default are ***admin*** and ***pass***, but they can be changed in common variables yml for Ansible.

Commands
--------
Some quick and usefull commands in boxes shell:
- goto-dev-site - Goes to source directory of development site
- xdebug-vars - Shows current values of xdebug environment variables for command line debuging
- xdebug-start - Sets xdebug environment variables for command line debuging
- xdebug-stop - Unsets xdebug envionment variables for command line debuging
- mailhog-test - Will send a test email that should get intercapted by the mailhog

SMTP and sendmail
-----------------
Mailhog is installed as a default SMTP server, catching and keeping all the mails that go trough it, enabling you to review what was set, from who and to whom. PHP sendmail is also replaced by Mailhogs substitution by default.

Source location, public web directory
-------------------------------------
On a **local** machine, source folder will get created in **./vagrant_source**, while in the vagrant machine this is located in **/opt/dev-site/source**. Web root folder is within **web** sub directory. If the Symfony2 dev site role was not disabled, then **app.php** is the index file, while only other **php** files callabe trough URL are **app_dev.php** and **config.php**.

MySQL database
--------------
By default playbook configuration, **application** database will be created on first provision. If the database got created this way then file **./vagrant_assets/mysql/application.sql** will be used to load the database. If the **./vagrant_assets/mysql/application_backup.sql.gz** is present then that file gets loaded instead on database creation. If database already existed, then non of the two files will be loaded, but the backup one will get (re)created.

Additional tools enabled by default
-----------------------------------
- MongoDB
- Redis Server
- Elastic Search
- RabbitMQ
- Composer
- Node.js

Additional tools not enabled by default
---------------------------------------
Additional tools that you might want to enable in playbook-once.yml and configure in common variables file:
- pip/pip_actions - Installs Pythons PIP package manager and trough configuration enables you to install some extra PIP packages on provision
- varnish/varnish_actions - Installs varnish. In ansible_assets copies varnihs config templates written in Jinja2 template (.j2)
- dev_site_cloud9/install_dev_site_cloud9 - Install Cloud 9 configured for dev site (on previously specified HTTP port)
- kibana/install_kibana - Tool to view elastic search
- webmin/install_webmin - Tool to adminster guest machine using web interface


Windows notice
--------------
On windows, share of development folder depends on Samba connection. For this to work under windows you will need Windows Power Shell 3 installed.
You will have to execute "vagrant up" as administrator. Vagrant will ask you for your username and password to setup Samba connection.

You have *windows_vagrant* and *windows_vagrant/commands* folders containing quick vagrant accessible scripts to help you avoid navigating to vagrant folder trough command line.

Additional
----------
All roles that you find in playbook named like {role}/actions_{role} are somewhat costumizable trough playbook variable files. Packages like ruby, node.js, apt, composer have (for example) posibillity to install additional tools related to those packages.