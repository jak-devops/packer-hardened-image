#!/bin/bash
set -e

echo "Application des mises à jour..."
apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get clean

# Créer un indicateur si tout est OK
touch /tmp/updates_done
