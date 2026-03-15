# Kitty - Terminal Configuration

Configuration Kitty pour infrastructure Linux privée - Profil "Toyota Tercel" (minimal, maîtrisé, sans dette technique).

## 📋 Vue d'ensemble

| Élément | Valeur |
|---------|--------|
| **Terminal** | Kitty (GPU-acceleré, truecolor) |
| **Source** | Repos Debian officiels |
| **Thème** | Dracula |
| **Police** | MesloLGS NF (compatibilité powerlevel10k) |
| **Gestion config** | Symlink depuis repo (single source of truth) |
| **Philosophie** | Toyota Tercel > Lada |

## 🗂️ Structure

```
05-DESKTOPS/kitty/
├── install-kitty.sh       # Script d'installation idempotent
├── kitty.conf            # Configuration principale
├── themes/
│   └── dracula.conf      # Thème Dracula
└── README.md             # Ce fichier
```

## 🚀 Installation rapide

```bash
# 1. Aller dans le dossier
cd ~/Dev/infra-startup/05-DESKTOPS/kitty

# 2. Exécuter le script
./install-kitty.sh

# Options disponibles:
./install-kitty.sh --dry-run    # Simulation (voir sans modifier)
./install-kitty.sh --force      # Forcer réinstallation
```

## ⚙️ Caractéristiques du script

| Caractéristique | Implémentation |
|-----------------|----------------|
| **Idempotent** | Vérifie avant d'installer, safe à relancer |
| **Backup** | Sauvegarde automatique timestampée avant écrasement |
| **Verbosité** | Toujours verbeux, tu vois tout ce qui se passe |
| **Détection** | Détecte zsh, powerlevel10k, tmux, adapte en conséquence |
| **Symlink** | Crée un lien symbolique vers le repo (single source of truth) |

## 🎨 Thème Dracula

Le thème Dracula est pré-configuré avec les couleurs optimales pour:
- Lisibilité longue durée
- Compatibilité avec powerlevel10k
- Support des icônes Nerdfonts

## ⌨️ Raccourcis clavier essentiels

| Raccourci | Action |
|-----------|--------|
| `Ctrl+Shift+t` | Nouvel onglet |
| `Ctrl+Shift+w` | Fermer onglet |
| `Ctrl+Shift+→` | Onglet suivant |
| `Ctrl+Shift+←` | Onglet précédent |
| `Ctrl+Shift+Enter` | Nouvelle fenêtre (split) |
| `Ctrl+Shift+c` | Copier |
| `Ctrl+Shift+v` | Coller |
| `Ctrl+Shift++` | Zoom + |
| `Ctrl+Shift+-` | Zoom - |
| `Ctrl+Shift+0` | Reset zoom |

## 🖥️ Workflow recommandé (OpenCode)

Pour le layout "Code à gauche, Terminal à droite":

1. **Ouvrir VS Code** à gauche (70% de l'écran)
2. **Ouvrir Kitty** à droite (30% de l'écran)
3. **Dans Kitty**: Lancer OpenCode: `opencode`

Cela te permet de:
- Voir les fichiers modifiés en temps réel à gauche
- Valider/éditer les suggestions OpenCode à droite
- Avoir ta logique QA visuelle intacte

## 📝 Modification de la configuration

**Important**: La configuration est gérée via **symlink**.

```
~/.config/kitty/  ──────►  [SYMLINK]  ──────►  ~/Dev/infra-startup/05-DESKTOPS/kitty/
```

**Pour modifier:**
1. Édite `05-DESKTOPS/kitty/kitty.conf` dans VS Code
2. Sauvegarde (Ctrl+S)
3. Kitty recharge automatiquement OU `Ctrl+Shift+F5`

**Ne modifie PAS** directement `~/.config/kitty/kitty.conf` - ce fichier est un symlink!

## 🔧 Personnalisation

### Changer la taille de police

Dans `kitty.conf`:
```conf
font_size 12.0    # Augmenter pour écran haute résolution
font_size 10.0    # Diminuer pour plus de contenu
```

### Changer de thème

1. Télécharge un thème dans `themes/`
2. Modifie dans `kitty.conf`:
   ```conf
   include themes/nom-du-theme.conf
   ```

### Activer l'opacité (transparence)

Dans `kitty.conf`, décommente:
```conf
background_opacity 0.95
```

## 🔄 Mise à jour

### Mettre à jour Kitty

```bash
sudo apt update && sudo apt upgrade kitty
```

### Mettre à jour la configuration

```bash
# Pull les changements depuis le repo
cd ~/Dev/infra-startup
git pull

# Relancer le script pour s'assurer que tout est à jour
./05-DESKTOPS/kitty/install-kitty.sh
```

## 🐛 Dépannage

### Kitty ne démarre pas

```bash
# Vérifier l'installation
which kitty
kitty --version

# Lancer en mode debug
kitty --debug-config
```

### Les polices ne s'affichent pas correctement

```bash
# Vérifier les polices disponibles
kitty + list-fonts | grep -i meslo

# Si absent, installer MesloLGS NF:
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
~/.powerlevel10k/fonts/install.sh
fc-cache -fv
```

### Le symlink est cassé

```bash
# Recréer le symlink
./install-kitty.sh --force
```

### Restaurer une ancienne configuration

```bash
# Lister les backups
ls -la ~/.config/ | grep kitty.backup

# Restaurer
cp -r ~/.config/kitty.backup.YYYYMMDD_HHMMSS/* ~/.config/kitty/
```

## 📚 Ressources

- [Documentation Kitty](https://sw.kovidgoyal.net/kitty/)
- [Dracula Theme](https://draculatheme.com/kitty)
- [Powerlevel10k Fonts](https://github.com/romkatv/powerlevel10k#fonts)

## 🏗️ Architecture de la solution

Voir: `docs/kitty_architecture_decisions.md` pour l'analyse complète des décisions architecturales (symlink vs copie, détection des risques, etc.).

---

**Philosophie**: Ce setup est conçu pour être maintenable, versionné, et "Toyota Tercel" - pas de magie noire, tout est explicite et maîtrisé.
