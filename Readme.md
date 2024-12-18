# Packer Hardened Image for Proxmox

## Description

Ce projet utilise **Packer** pour créer une image **hardened** (sécurisée) sur une infrastructure **Proxmox VE**. Il inclut une configuration d'automatisation basée sur des scripts Shell pour appliquer :

- les mises à jour système,
- des mesures de sécurisation (hardening),
- une étape de validation intermédiaire,
- et un nettoyage final.

⚠️ **Projet en cours** :
Les scripts présents dans ce repository sont une première ébauche. Je vais revoir et valider chaque étape en m'appuyant sur la documentation officielle et les bonnes pratiques.

---

## Structure du projet

\`\`\`plaintext
packer-hardened-image/
│
├── http/                        # Fichiers pour Cloud-init
│   ├── meta-data.yml
│   └── user-data.yml
│
├── scripts/                     # Scripts Shell exécutés pendant la construction
│   ├── updates.sh               # Appliquer les mises à jour
│   ├── hardening.sh             # Appliquer des mesures de sécurisation
│   ├── validate.sh              # Vérifier si les étapes précédentes ont réussi
│   └── cleanup.sh               # Nettoyer les fichiers inutiles
│
├── secrets.auto.pkrvars.hcl     # Fichier de variables sensibles (à exclure via .gitignore)
├── variables.pkr.hcl            # Définition des variables Packer
└── ubuntu-proxmox.pkr.hcl       # Configuration principale Packer
\`\`\`

---

## Statut du projet

- **Étape actuelle :**
  - Intégration des scripts de base (`updates`, `hardening`, `validate`, `cleanup`).
  - Ajout d'une validation intermédiaire pour conditionner le nettoyage.

- **Prochaines étapes :**
  - Relecture et validation des scripts avec la documentation officielle.
  - Amélioration des mesures de sécurisation (conformité CIS Benchmarks).
  - Optimisation des commandes Shell pour plus de robustesse.

---

## Pré-requis

1. **Packer** doit être installé : [Installer Packer](https://developer.hashicorp.com/packer/tutorials)
2. Un accès à **Proxmox VE** configuré (variables \`proxmox_url\`, \`proxmox_username\`, etc.).
3. SSH configuré pour accéder à la VM en construction.

---

## Exécution du build

### Variables nécessaires

Définir les variables dans le fichier \`variables.pkr.hcl\` :

\`\`\`hcl
variable "proxmox_url" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type = string
}
\`\`\`

### Commandes pour exécuter Packer

1. **Initialiser les plugins :**
   \`\`\`bash
   packer init .
   \`\`\`

2. **Lancer le build :**
   \`\`\`bash
   packer build ubuntu-proxmox.pkr.hcl
   \`\`\`

---

## Notes supplémentaires

- Les scripts Shell sont encore en version bêta et peuvent nécessiter des ajustements.
- Toute contribution ou suggestion est la bienvenue pour améliorer ce projet.

---

## Contact

Pour toute question ou suggestion, n'hésitez pas à me **contacter sur LinkedIn** :

[Jean-Baptiste Faria](https://www.linkedin.com/in/faria-jean-baptiste/)
