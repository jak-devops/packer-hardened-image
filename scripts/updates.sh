#!/bin/bash
set -e

# Mise à jour et nettoyage du système
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get clean
