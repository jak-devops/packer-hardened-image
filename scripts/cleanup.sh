#!/bin/bash
set -e

# Nettoyage des logs et fichiers temporaires
rm -rf /var/log/*.log
rm -rf /var/cache/apt/archives/*.deb
rm -rf /tmp/*

# Réinitialiser l'historique des commandes
cat /dev/null > ~/.bash_history
history -c
