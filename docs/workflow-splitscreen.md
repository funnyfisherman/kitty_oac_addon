# Workflow Split-Screen : Code à Gauche, Terminal à Droite

## 🎯 Objectif
Configuration optimale pour utiliser OpenCode avec un **split-screen côte-à-côte** :
- **GAUCHE** : VS Code (éditeur de code)
- **DROITE** : Kitty Terminal (pour voir les exécutions et logs)

## 📐 Pourquoi ce layout ?

### Contexte 1 : Mode "Architecte" (Développement)
**Quand l'utiliser :** Quand tu écris du code, modifies des fichiers, ou fais de l'architecture.

**Workflow :**
1. Tu ouvres VS Code sur ton projet
2. Tu places Kitty à droite (plus petit, ~30-40% de l'écran)
3. Dans Kitty, tu lances les commandes de build/test
4. Tu vois **en temps réel** les résultats sans quitter VS Code

**Exemple concret :**
```
┌────────────────────────────┬─────────────┐
│                            │   KITTY     │
│      VS CODE               │   Terminal  │
│   (Édition de code)        │   $ npm run │
│                            │   dev       │
│   [server.js]              │   [logs     │
│   app.listen(...)          │    qui      │
│                            │    scroll]  │
└────────────────────────────┴─────────────┘
```

### Contexte 2 : Mode "Réparateur Rapide" (Admin Sys)
**Quand l'utiliser :** Quand tu dois SSH sur un serveur, débugger, ou faire des opérations rapides.

**Workflow :**
1. Kitty en **plein écran** ou **fenêtre unique**
2. Pas besoin de VS Code - juste le terminal
3. Connexions SSH, commandes système, monitoring

**Exemple concret :**
```
┌────────────────────────────┐
│                            │
│        KITTY               │
│      Full Screen           │
│                            │
│   $ ssh thin04             │
│   $ sudo systemctl status  │
│   $ htop                   │
│                            │
└────────────────────────────┘
```

### Contexte 3 : Mode "OpenCode Actif"
**Quand l'utiliser :** Quand OpenCode te demande d'approuver des modifications.

**Workflow :**
1. **GAUCHE** : VS Code - Tu vois le fichier que OpenCode propose de modifier
2. **DROITE** : Kitty - Tu vois les logs et la sortie des commandes
3. Tu compares les deux côtés avant d'approuver

## 🎮 Comment configurer le split-screen

### Méthode 1 : Manuel (Windows/Super Key)
1. Ouvre VS Code
2. Ouvre Kitty
3. **Super + Flèche Gauche** sur VS Code → se place à gauche
4. **Super + Flèche Droite** sur Kitty → se place à droite

### Méthode 2 : KDE Plasma Shortcuts
Dans KDE Plasma (ton environnement), utilise :
- `Meta + Ctrl + Flèche Gauche` : Snap fenêtre à gauche
- `Meta + Ctrl + Flèche Droite` : Snap fenêtre à droite

### Méthode 3 : Taille de fenêtre Kitty prédéfinie
Dans ton [`kitty.conf`](05-DESKTOPS/kitty/kitty.conf:132) :
```
initial_window_width  100c   # ~100 caractères de large
initial_window_height 30c    # ~30 lignes de haut
```

Déplace manuellement Kitty à droite de l'écran après ouverture.

## 🔄 Triggers (Déclencheurs)

### Quand passer en mode Split-Screen ?
| Situation | Action |
|-----------|--------|
| OpenCode dit "Je vais modifier X fichiers" | Ouvrir split-screen |
| Tu écris du code et veux voir les tests | Ouvrir split-screen |
| Tu debugges avec logs en temps réel | Ouvrir split-screen |
| Tu fais du review de code approfondi | Ouvrir split-screen |

### Quand rester en Full-Screen ?
| Situation | Action |
|-----------|--------|
| SSH sur serveur distant | Full-screen Kitty |
| Commande rapide (1-2 lignes) | Full-screen Kitty |
| Tu préfères Alt-Tab entre fenêtres | Full-screen chaque app |

## 📝 Résumé des raccourcis clés

### Dans Kitty
- `Ctrl+Shift+Enter` : Nouvelle fenêtre (split horizontal)
- `Ctrl+Shift+L` : Changer de layout
- `Ctrl+Shift+Égal` : Zoom + (agrandir police)
- `Ctrl+Shift+Moins` : Zoom - (réduire police)

### Dans KDE Plasma
- `Meta + Flèche` : Snap fenêtre aux bords
- `Meta + Page Up` : Maximiser fenêtre
- `Meta + Page Down` : Restaurer fenêtre

## 💡 Astuce pour OpenCode

Crée un alias rapide dans ton `~/.zshrc` pour lancer le workflow split :

```bash
# Ouvre VS Code + Kitty côte à côte
alias opencode-workflow='code ~/Dev/kuber-kluster & kitty --directory ~/Dev/kuber-kluster &'
```

Puis utilise :
```bash
opencode-workflow
```

Et arrange manuellement les fenêtres avec `Meta + Flèche`.

---

**Philosophie "Toyota Tercel" :** Pas besoin d'automatisation complexe. Un simple snap de fenêtre manuel fait le job et tu gardes le contrôle total !
