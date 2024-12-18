#!/bin/bash
set -e

# Vérification des mises à jour
if [ ! -f /tmp/updates_done ]; then
  echo "Échec : Les mises à jour n'ont pas été terminées avec succès."
  exit 1
fi

# Vérification du hardening
if [ ! -f /tmp/hardening_done ]; then
  echo "Échec : Le hardening n'a pas été appliqué avec succès."
  exit 1
fi

echo "Validation réussie. Toutes les étapes précédentes sont OK."
exit 0
