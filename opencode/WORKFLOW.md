# Workflow Split-Screen : OpenCode dans Kitty

Guide d'utilisation d'OpenCode et OpenAgentsControl avec le workflow "Code à gauche, Terminal à droite".

## Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────┐
│                      ÉCRAN PRINCIPAL                        │
├─────────────────────────────────┬───────────────────────────┤
│                                 │                           │
│      VS CODE (70%)              │    KITTY + OpenCode       │
│      ─────────────              │    ────────────────       │
│                                 │                           │
│  • Fichiers en édition          │  • Interface TUI          │
│  • Diffs à approuver            │  • Prompts & réponses     │
│  • Explorateur de code          │  • Logs d'exécution       │
│  • Terminal intégré (optionnel) │  • Validation humaine     │
│                                 │                           │
│  [Ctrl+Shift+t = terminal VS]   │  [Ctrl+Shift+t = onglet]  │
│                                 │                           │
└─────────────────────────────────┴───────────────────────────┘
```

## Pourquoi ce layout ?

### Contexte 1 : Mode "Architecte" (Développement planifié)

**Quand l'utiliser :**
- Écrire du code avec assistance IA
- Modifier des fichiers complexes
- Architecture de systèmes
- Review de code approfondi

**Workflow :**
1. Ouvre VS Code sur ton projet (`code .`)
2. Place VS Code à gauche (70% de l'écran) - `Meta + Flèche Gauche`
3. Ouvre Kitty à droite (30% de l'écran) - `Meta + Flèche Droite`
4. Dans Kitty, lance OpenCode: `opencode`
5. Pose ta question/prompt à l'IA
6. **OBSERVE** les fichiers se modifier dans VS Code (gauche)
7. **VALIDE** les changements dans le terminal Kitty (droite)
8. Approuve ou demande des modifications

**Exemple concret :**
```
┌────────────────────────────┬─────────────┐
│  VS CODE                   │   KITTY     │
│  [server.js] ← modifié     │  opencode>  │
│  + app.listen(...)         │  Créer une  │
│  + nouvelle route          │  API REST   │
│                            │             │
│  [proposed changes]        │  ✓ Fichier  │
│  - ligne 15: port = 3000   │  server.js  │
│  + ligne 15: port = 8080   │  modifié    │
│                            │  Approuver? │
│                            │  [y/n/e/d]  │
└────────────────────────────┴─────────────┘
```

### Contexte 2 : Mode "Réparateur Rapide" (Admin Sys)

**Quand l'utiliser :**
- Debug rapide sur serveur
- Commandes système
- SSH sur nodes
- Monitoring

**Workflow :**
1. Kitty en plein écran
2. Pas de split-screen nécessaire
3. Utilise OpenCode pour générer des commandes complexes

**Exemple :**
```bash
$ opencode "génère une commande pour trouver les fichiers > 100MB modifiés il y a 7 jours"
→ IA génère la commande find
→ Tu copies/colles ou exécutes directement
```

### Contexte 3 : Mode "OpenAgentsControl Active"

**Quand l'utiliser :**
- Workflows complexes avec approbations
- Génération de code multi-étapes
- Utilisation d'agents spécialisés

**Workflow :**
1. Split-screen comme Contexte 1
2. Lance un agent spécifique: `opencode --agent OpenAgent`
3. L'agent exécute son workflow avec points d'approbation
4. **GAUCHE** : Tu vois les fichiers se créer/modifier
5. **DROITE** : Tu vois les logs et décides d'approuver/refuser chaque étape

## Comment configurer le split-screen

### Méthode 1 : Manuel (KDE Plasma)

1. Ouvre VS Code : `code /chemin/du/projet`
2. Ouvre Kitty
3. **Meta + Flèche Gauche** sur VS Code → snap à gauche
4. **Meta + Flèche Droite** sur Kitty → snap à droite
5. Ajuste la taille manuellement (~70/30)

### Méthode 2 : Taille Kitty prédéfinie

Dans `kitty.conf` (déjà configuré) :
```conf
initial_window_width  100c   # ~100 caractères
initial_window_height 30c    # ~30 lignes
```

Puis place manuellement à droite.

### Méthode 3 : Script de lancement

Crée un script `launch-split.sh` :
```bash
#!/bin/bash
# Lancer VS Code + Kitty côte-à-côte

# VS Code à gauche
code . &
sleep 2
xdotool search --class code windowactivate key Meta+Left

# Kitty à droite
kitty opencode &
sleep 1
xdotool search --class kitty windowactivate key Meta+Right
```

## Triggers (Déclencheurs)

### Quand passer en mode Split-Screen ?

| Situation | Action |
|-----------|--------|
| OpenCode dit "Je vais modifier X fichiers" | Ouvrir split-screen |
| Tu écris du code avec assistance IA | Ouvrir split-screen |
| Tu veux voir les logs en temps réel | Ouvrir split-screen |
| Review de code généré par l'IA | Ouvrir split-screen |
| Configuration complexe (nginx, docker, etc.) | Ouvrir split-screen |

### Quand rester en Full-Screen ?

| Situation | Action |
|-----------|--------|
| Question rapide à l'IA | Full-screen Kitty |
| Génération de commandes shell | Full-screen Kitty |
| SSH sur serveur distant | Full-screen Kitty |
| Exploration de code existant | Full-screen VS Code |

## Raccourcis clavier essentiels

### Dans VS Code

| Raccourci | Action |
|-----------|--------|
| `Ctrl+\`` | Ouvrir/fermer terminal intégré |
| `Ctrl+Shift+E` | Explorer de fichiers |
| `Ctrl+Shift+G G` | Git / Diff |
| `Ctrl+Shift+F` | Recherche globale |

### Dans Kitty + OpenCode

| Raccourci | Action |
|-----------|--------|
| `Ctrl+Shift+t` | Nouvel onglet |
| `Ctrl+Shift+w` | Fermer onglet |
| `Ctrl+Shift+→` | Onglet suivant |
| `Ctrl+Shift+←` | Onglet précédent |
| `Ctrl+c` (dans OpenCode) | Interrompre la génération |
| `y` / `n` / `e` / `d` | Approuver / Refuser / Éditer / Diff |

### Navigation entre fenêtres

| Raccourci | Action |
|-----------|--------|
| `Alt+Tab` | Switcher entre apps |
| `Meta+Left/Right` | Snap fenêtre gauche/droite |
| `Meta+Up` | Maximiser |
| `Meta+Down` | Restaurer/minimiser |

## Exemples de sessions

### Exemple 1 : Créer une API Express

```bash
# Dans Kitty (droite)
$ opencode "crée une API Express avec routes users et auth"

# OpenCode propose:
# ✓ Créer server.js
# ✓ Créer routes/users.js
# ✓ Créer routes/auth.js
# ✓ Créer package.json
#
# Approuver tout? [y/n/e/d/s] (y=yes, n=no, e=edit, d=diff, s=skip)
```

**Dans VS Code (gauche) :**
- Tu vois les fichiers apparaître dans l'explorateur
- Tu peux cliquer sur chaque fichier pour voir le contenu
- Tu valides ou demandes des changements

### Exemple 2 : Modifier un fichier existant

```bash
# Dans Kitty (droite)
$ opencode "ajoute la validation JWT à la route /admin"

# OpenCode affiche:
# ✓ Modifier server.js
# 
# --- a/server.js
# +++ b/server.js
# @@ -15,6 +15,12 @@
#  app.use('/admin', (req, res, next) => {
# +  const token = req.headers.authorization;
# +  if (!token) return res.status(401).send('Non autorisé');
# +  jwt.verify(token, SECRET, (err, user) => {
# +    if (err) return res.status(403).send('Token invalide');
# +    req.user = user;
# +    next();
# +  });
#  });
#
# Approuver? [y/n/e/d]
```

**Dans VS Code (gauche) :**
- Ouvre `server.js`
- Tu vois les modifications en temps réel quand tu approuves

### Exemple 3 : Utiliser OpenAgentsControl

```bash
# Dans Kitty (droite)
$ opencode --agent OpenAgent

# L'agent OpenAgent est un agent généraliste pour le développement
# Il va poser des questions, planifier, et demander des approbations

[OpenAgent] Quel type de projet veux-tu créer?
> Une application web avec React et Node.js

[OpenAgent] Je vais créer:
# 1. Structure de dossiers
# 2. Configuration Docker
# 3. Frontend React avec Vite
# 4. Backend Node.js/Express
# 5. Docker Compose
#
# Approuver le plan? [y/n/e]
```

## Bonnes pratiques

### 1. Toujours relire avant d'approuver

```
❌ Mauvais:
[OpenCode] Je vais modifier 15 fichiers. Approuver? [y]
> y (trop rapide, sans vérifier)

✅ Bon:
[OpenCode] Je vais modifier 15 fichiers. Approuver? [y/n/e/d]
> d (voir le diff d'abord)
# Relire chaque changement
> y (approuver après vérification)
```

### 2. Utiliser l'édition pour les modifications mineures

```
[OpenCode] Je propose ce changement. Approuver? [y/n/e/d]
> e (éditer)
# Tu modifies directement la proposition dans l'éditeur
```

### 3. Valider étape par étape avec OpenAgentsControl

```
[OpenAgent] Étape 1/5: Créer la structure. Approuver? [y/n/s]
> y
[OpenAgent] Étape 2/5: Configuration Docker. Approuver? [y/n/s]
> n (tu vois une erreur)
[OpenAgent] Que faut-il changer?
> "Utilise Node 18, pas Node 16"
[OpenAgent] Je corrige... Nouveau diff. Approuver? [y/n/e/d]
> y
```

### 4. Garder VS Code comme source de vérité

Même quand OpenCode modifie des fichiers, VS Code reste ton éditeur principal :
- Tu peux éditer manuellement à tout moment
- Le terminal Kitty est là pour l'interaction IA
- Les deux sont synchronisés

## Dépannage

### OpenCode cache VS Code

```bash
# Solution: Ajuster la taille
# Dans kitty.conf, réduire la taille:
initial_window_width  80c  # Plus petit
```

### Trop de fenêtres, c'est confus

```bash
# Solution: Utiliser les bureaux virtuels KDE
# Bureau 1: VS Code + Kitty (split-screen)
# Bureau 2: Documentation, navigateur
# Bureau 3: Communication (Slack, etc.)
```

### OpenCode ralentit

```bash
# Solution: Réduire la taille du contexte
# Dans opencode, utilise:
# /compact - réduire le contexte
# /clear - effacer l'historique
```

## Ressources

- [Documentation OpenCode](https://opencode.ai)
- [OpenAgentsControl GitHub](https://github.com/darrenhinde/OpenAgentsControl)
- [Guide des agents OpenCode](https://opencode.ai/agents)

---

**Rappel**: Ce workflow est conçu pour la "qualité visuelle" - tu dois TOUJOURS voir ce que l'IA fait avant d'approuver. La split-screen est ton outil de QA.
