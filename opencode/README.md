# OpenCode & OpenAgentsControl - Installation pour Kitty

Configuration et installation d'OpenCode CLI et OpenAgentsControl dans l'environnement Kitty.

## Vue d'ensemble

| Élément | Valeur |
|---------|--------|
| **OpenCode** | Agent de codage IA open source (interface TUI) |
| **OpenAgentsControl** | Framework d'agents IA pour workflows planifiés |
| **Terminal** | Kitty (GPU-acceleré, truecolor) |
| **Philosophie** | Toyota Tercel - Minimal, explicite, maîtrisé |

## Prérequis

- Kitty déjà installé et configuré
- Git installé
- curl ou npm (selon méthode choisie)
- Node.js 18+ (si installation via npm)

## Structure

```
05-DESKTOPS/kitty/opencode/
├── install-opencode.sh      # Script d'installation idempotent
├── config.env               # Fichier de configuration
├── config.env.local         # Clés API (ne pas versionner!)
├── README.md                # Ce fichier
└── WORKFLOW.md              # Guide d'utilisation split-screen
```

## Installation rapide

```bash
# 1. Aller dans le dossier
cd ~/Dev/kuber-kluster/05-DESKTOPS/kitty/opencode

# 2. Configurer les variables (optionnel)
cp config.env config.env.local
# Éditer config.env.local avec vos préférences

# 3. Exécuter le script
./install-opencode.sh
```

## Options du script

```bash
./install-opencode.sh              # Mode standard (idempotent)
./install-opencode.sh --dry-run    # Simulation (affiche sans exécuter)
./install-opencode.sh --verbose    # Mode très verbeux
```

## Post-installation

### 1. Configurer les clés API

```bash
# Éditer le fichier local (non versionné)
nano ~/.config/opencode/config.env.local

# Ou utiliser la commande opencode
opencode config set ANTHROPIC_API_KEY=votre_cle
```

### 2. Vérifier l'installation

```bash
# Tester OpenCode
opencode --version

# Tester OpenAgentsControl
opencode --agent OpenAgent
```

### 3. Lancer en mode split-screen

Voir [WORKFLOW.md](WORKFLOW.md) pour le guide complet.

## Workflow recommandé

### Mode "Architecte" (Développement)

```
┌────────────────────────────┬─────────────┐
│                            │   KITTY     │
│      VS CODE               │  OpenCode   │
│   (Édition de code)        │   TUI       │
│                            │             │
│   [fichiers modifiés]      │  [prompts   │
│   [diffs à approuver]      │   & logs]   │
│                            │             │
└────────────────────────────┴─────────────┘
```

### Commandes essentielles

| Commande | Description |
|----------|-------------|
| `opencode` | Lancer l'interface TUI interactive |
| `opencode --agent OpenAgent` | Lancer avec un agent spécifique |
| `opencode "créer une API REST"` | Commande directe |
| `opencode --continue` | Reprendre la dernière session |

## Raccourcis Kitty configurés

| Raccourci | Action |
|-----------|--------|
| `Ctrl+Shift+o` | Ouvrir OpenCode dans un nouvel onglet |
| `Ctrl+Shift+a` | Ouvrir OpenAgentsControl |

## Dépannage

### OpenCode ne démarre pas

```bash
# Vérifier l'installation
which opencode
opencode --version

# Vérifier la configuration
opencode config list
```

### Erreur de clé API

```bash
# Vérifier les clés configurées
opencode config list | grep -i api

# Définir une clé
opencode config set ANTHROPIC_API_KEY=votre_cle
```

### Restaurer une configuration précédente

```bash
# Lister les backups
ls -la ~/.config/opencode.backups/

# Restaurer
cp -r ~/.config/opencode.backups/YYYYMMDD_HHMMSS/* ~/.config/opencode/
```

## Ressources

- [Documentation OpenCode](https://opencode.ai)
- [OpenAgentsControl GitHub](https://github.com/darrenhinde/OpenAgentsControl)
- [Guide Kitty](https://sw.kovidgoyal.net/kitty/)

## Philosophie

Ce setup suit les principes "Toyota Tercel":
- **Pas de magie noire** : Chaque étape est explicite
- **Idempotent** : Safe à relancer plusieurs fois
- **Backup automatique** : Jamais de perte de configuration
- **Verbeux** : Tu vois tout ce qui se passe

## rapport de fin d'instalation : 

✅ Installation OpenCode & OpenAgentsControl - TERMINÉE
Résumé de l'installation
Composant	Version/Statut	Emplacement
OpenCode CLI	✅ 1.1.65	~/.opencode/bin/opencode
OpenAgentsControl	✅ Cloné	~/.config/opencode/OpenAgentsControl/
Configuration	✅ Prête	~/.config/opencode/
Ce qui a été fait
1. Script d'installation créé et testé
install-opencode.sh - Script idempotent, sécurisé (sans eval)
config.env - Configuration personnalisable
README.md - Documentation complète
WORKFLOW.md - Guide split-screen
2. Corrections appliquées
✅ Remplacé eval par "$@" pour la sécurité
✅ Corrigé l'URL d'installation (https://opencode.ai/install)
✅ Tests dry-run validés
3. Intégration Kitty
✅ Raccourcis configurés dans kitty.conf:
Ctrl+Shift+O : Ouvrir OpenCode
Ctrl+Shift+A : Ouvrir avec agent
Prochaines étapes
1. Configurer une clé API (obligatoire pour utiliser OpenCode)
# Option 1: Anthropic (Claude) - Recommandé
opencode config set ANTHROPIC_API_KEY=votre_cle_ici

# Option 2: OpenAI (GPT)
opencode config set OPENAI_API_KEY=votre_cle_ici

# Option 3: Google (Gemini)
opencode config set GEMINI_API_KEY=votre_cle_ici
2. Tester OpenCode
# Vérifier la configuration
opencode config list

# Lancer l'interface TUI
opencode

# Commande directe
opencode "créer une API REST en Node.js"
3. Tester le workflow split-screen
# 1. Ouvrir VS Code sur votre projet
code ~/votre-projet

# 2. Ouvrir Kitty avec OpenCode (utiliser le raccourci Ctrl+Shift+O)
# Ou manuellement:
kitty opencode

# 3. Organiser les fenêtres côte-à-côte
# VS Code à gauche (70%), Kitty à droite (30%)
4. Utiliser OpenAgentsControl
# Lancer avec l'agent OpenAgent
opencode --agent OpenAgent

# Ou depuis le répertoire cloné
cd ~/.config/opencode/OpenAgentsControl
./install.sh  # Si un script d'installation existe
Commandes essentielles
Commande	Description
opencode	Interface TUI interactive
opencode "prompt"	Exécution directe
opencode --version	Version installée
opencode config list	Voir la configuration
opencode config set KEY=value	Définir une clé API
Fichiers créés/modifiés
05-DESKTOPS/kitty/opencode/
├── install-opencode.sh      # Script d'installation (440 lignes)
├── config.env               # Configuration
├── README.md                # Documentation
└── WORKFLOW.md              # Guide d'utilisation

05-DESKTOPS/kitty/kitty.conf  # + Raccourcis OpenCode

~/.opencode/                  # Installation OpenCode
~/.config/opencode/           # Configuration et OpenAgentsControl
⚠️ Important
Sans clé API configurée, OpenCode ne pourra pas fonctionner. Les modèles gratuits sont inclus mais nécessitent quand même une configuration initiale.

Pour obtenir une clé API:

Anthropic: https://console.anthropic.com/
OpenAI: https://platform.openai.com/
Google: https://aistudio.google.com/
Installation réussie ! Vous pouvez maintenant utiliser OpenCode dans Kitty avec le workflow split-screen.