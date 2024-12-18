#!/bin/bash
set -e

echo "Application des mesures de sécurisation..."

# Désactiver les services inutiles
systemctl disable bluetooth.service
systemctl disable cups.service

# Configuration du pare-feu UFW
ufw default deny incoming
ufw default allow outgoing
ufw enable

# Configuration de fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/backend = auto/backend = systemd/' /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban

# Renforcement SSH
echo "Protocol 2" >> /etc/ssh/sshd_config
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
echo "AllowUsers admin" >> /etc/ssh/sshd_config

# Installation et configuration de AIDE (détection d'intrusion)
aide-check
aide-update

# Désactiver les modules du noyau non nécessaires
echo "install cramfs /bin/true" >> /etc/modprobe.d/disable-cramfs.conf
echo "install freevxfs /bin/true" >> /etc/modprobe.d/disable-freevxfs.conf
echo "install jffs2 /bin/true" >> /etc/modprobe.d/disable-jffs2.conf
echo "install hfs /bin/true" >> /etc/modprobe.d/disable-hfs.conf
echo "install hfsplus /bin/true" >> /etc/modprobe.d/disable-hfsplus.conf
echo "install squashfs /bin/true" >> /etc/modprobe.d/disable-squashfs.conf
echo "install udf /bin/true" >> /etc/modprobe.d/disable-udf.confgit

# Créer un indicateur si tout est OK
touch /tmp/hardening_done
