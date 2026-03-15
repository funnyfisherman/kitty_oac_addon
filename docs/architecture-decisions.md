# Architecture des Solutions de Configuration Kitty

## 1. GESTION DE LA CONFIGURATION - Comparaison des approches

### Option A: Symlink (Recommandé pour ton profil)

```
┌─────────────────────────────────────────────────────────────┐
│                    REPO infra-startup                       │
│  ┌─────────────────┐          ┌──────────────────────┐     │
│  │ scripts/desktop/│          │ 05-DESKTOPS/kitty/   │     │
│  │                 │          │                      │     │
│  │  install-kitty.sh ───────► │  kitty.conf         │◄────┼── Versionné dans Git
│  │  (orchestrateur)│          │  themes/dracula.conf │     │
│  └─────────────────┘          └──────────────────────┘     │
│            │                           │                    │
│            │    ┌─────────────────┐    │                    │
│            └───►│  ln -s (symlink)│◄───┘                    │
│                 └─────────────────┘                         │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     SYSTÈME (Dell/ThinkPad)                 │
│  ~/.config/kitty/kitty.conf ─────► [LIEN SYMBOLIQUE]        │
│                                    pointe vers le repo      │
│                                                             │
│  Résultat: Quand tu modifies dans VS Code → instantanément  │
│  actif dans Kitty. Une source de vérité versionnée.         │
└─────────────────────────────────────────────────────────────┘
```

**Avantages:**
- ✅ Une seule source de vérité (le repo)
- ✅ Modifications dans VS Code = instantanément actif
n- ✅ Backup naturel (Git)
- ✅ Parfait pour ton workflow "architecte"

**Inconvénients:**
- ❌ Si tu déplaces le repo, le lien casse
- ❌ Nécessite de garder le repo accessible

---

### Option B: Copie Statique

```
┌─────────────────────────────────────────────────────────────┐
│                    REPO infra-startup                       │
│  ┌─────────────────┐          ┌──────────────────────┐     │
│  │ scripts/desktop/│          │ assets/kitty/        │     │
│  │                 │          │                      │     │
│  │  install-kitty.sh ───────► │  kitty.conf         │     │
│  │                 │          │  themes/             │     │
│  └─────────────────┘          └──────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼ cp -r (copie récursive)
┌─────────────────────────────────────────────────────────────┐
│                     SYSTÈME                                 │
│  ~/.config/kitty/kitty.conf ─────► [FICHIER COPIÉ]          │
│                                                             │
│  Résultat: Fichier indépendant. Si tu modifies dans VS Code,│
│  tu dois relancer le script pour propager.                  │
└─────────────────────────────────────────────────────────────┘
```

**Avantages:**
- ✅ Fonctionne même si le repo est déplacé/supprimé
- ✅ Plus simple conceptuellement

**Inconvénients:**
- ❌ Deux versions du fichier (repo vs système)
- ❌ Risque de divergence
- ❌ Moins "Toyota Tercel" (pas de single source of truth)

---

### Option C: Template Généré

```
┌─────────────────────────────────────────────────────────────┐
│                    REPO infra-startup                       │
│  ┌─────────────────┐          ┌──────────────────────┐     │
│  │ scripts/desktop/│          │ templates/           │     │
│  │                 │          │                      │     │
│  │  install-kitty.sh ───────► │  kitty.conf.j2      │     │
│  │    (moteur de   │          │  ━━{{ theme }}━━    │     │
│  │     template)   │          │  ━━{{ font }}━━     │     │
│  └─────────────────┘          └──────────────────────┘     │
│            │                           ▲                    │
│            │    ┌─────────────────┐    │ variables          │
│            └───►│  GÉNÉRATION     │────┘ (thème, police)    │
│                 │  (sed/jinja2)   │                         │
│                 └─────────────────┘                         │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     SYSTÈME                                 │
│  ~/.config/kitty/kitty.conf ─────► [FICHIER GÉNÉRÉ]         │
│                                                             │
│  Résultat: Le script génère une config sur mesure selon     │
│  les variables passées en paramètre.                        │
└─────────────────────────────────────────────────────────────┘
```

**Avantages:**
- ✅ Un seul template pour plusieurs machines
- ✅ Personnalisation via variables (Dell vs ThinkPad)

**Inconvénients:**
- ❌ Plus complexe
- ❌ Nécessite un moteur de template
- ❌ Overkill pour ton cas (2 machines similaires)

---

## 2. DÉTECTION CONFIG EXISTANTE - Analyse des risques

### L'approche "Adaptation" (Recommandée)

```
┌─────────────────────────────────────────────────────────────┐
│                    SCRIPT install-kitty.sh                  │
│                                                             │
│  ┌─────────────────┐                                       │
│  │ 1. DÉTECTION    │                                       │
│  │    ├─ zsh installé ? ──► OUI ──► note pour intégration │
│  │    ├─ power10k ? ──────► OUI ──► vérifie compatibilité │
│  │    ├─ tmux ? ──────────► OUI ──► configure keybindings │
│  │    └─ kitty déjà là ? ─► OUI ──► backup + skip install │
│  └─────────────────┘                                       │
│                           │                                 │
│                           ▼                                 │
│  ┌─────────────────┐                                       │
│  │ 2. ADAPTATION   │                                       │
│  │    ├─ Garde le shell par défaut (ne force pas zsh)     │
│  │    ├─ Intègre avec power10k existant                   │
│  │    └─ Configure keybindings tmux SEULEMENT si présent  │
│  └─────────────────┘                                       │
│                           │                                 │
│                           ▼                                 │
│  ┌─────────────────┐                                       │
│  │ 3. INSTALLATION │                                       │
│  │    └─ Kitty depuis repos Debian                        │
│  └─────────────────┘                                       │
└─────────────────────────────────────────────────────────────┘
```

### RISQUES de la détection (et mitigation)

| Risque | Probabilité | Mitigation |
|--------|-------------|------------|
| Faux positif (détecte zsh mais cassé) | Faible | Vérifie que `zsh --version` fonctionne |
| Conflit power10k | Faible | Power10k est standard, Kitty s'intègre bien |
| tmux mal configuré | Moyenne | Le script vérifie `tmux -V` avant keybindings |
| Détection lente | Nulle | Les checks sont instantanés (`which`, `test -f`) |

**Verdict:** L'adaptation est sûre et "Toyota Tercel" - on ne casse rien, on s'intègre.

---

## 3. KEYBINDINGS KITTY → TMUX - Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────┐
│              WORKFLOW: Code à gauche, Terminal à droite     │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────────────────────────────┐ │
│  │              │  │  KITTY (sans tmux)                   │ │
│  │   VS CODE    │  │  ┌────────────────────────────────┐  │ │
│  │   (OpenCode) │  │  │  $ opencode                    │  │ │
│  │              │  │  │                                │  │ │
│  │  ┌────────┐  │  │  │  Ctrl+Shift+t = nouvel onglet  │  │ │
│  │  │ Fichier│  │  │  │  Ctrl+Shift+w = fermer        │  │ │
│  │  │ en     │  │  │  │  Ctrl+Shift+↑ = split haut    │  │ │
│  │  │ cours  │  │  │  │  Ctrl+Shift+→ = split droite  │  │ │
│  │  └────────┘  │  │  └────────────────────────────────┘  │ │
│  │              │  │                                      │ │
│  └──────────────┘  └──────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  OU AVEC TMUX (quand tu veux multiplex):                    │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────────────────────────────┐ │
│  │   VS CODE    │  │  KITTY + TMUX                        │ │
│  │              │  │  ┌────────────────────────────────┐  │ │
│  │              │  │  │  ┌────────┐ ┌────────┐        │  │ │
│  │              │  │  │  │ssh thin│ │ htop   │        │  │ │
│  │              │  │  │  │  01    │ │        │        │  │ │
│  │              │  │  │  └────────┘ └────────┘        │  │ │
│  │              │  │  │  ┌─────────────────────┐      │  │ │
│  │              │  │  │  │     logs            │      │  │ │
│  │              │  │  │  └─────────────────────┘      │  │ │
│  │              │  │  │                               │  │ │
│  │              │  │  │  Ctrl+b c = nouvelle fenêtre  │  │ │
│  │              │  │  │  Ctrl+b % = split vertical    │  │ │
│  │              │  │  │  Ctrl+b " = split horizontal  │  │ │
│  │              │  │  │  Ctrl+b flèche = navigation   │  │ │
│  │              │  │  └────────────────────────────────┘  │ │
│  └──────────────┘  └──────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Harmonisation proposée

Le script peut configurer Kitty pour que **certains raccourcis soient identiques** entre Kitty natif et tmux:

| Action | Kitty natif | tmux | Harmonisation ? |
|--------|-------------|------|-----------------|
| Nouvel onglet/fenêtre | Ctrl+Shift+t | Ctrl+b c | Non (trop différent) |
| Split vertical | Ctrl+Shift+→ | Ctrl+b % | Optionnel |
| Split horizontal | Ctrl+Shift+↓ | Ctrl+b " | Optionnel |
| Navigation | Ctrl+Shift+flèche | Ctrl+b flèche | Optionnel |

**Recommandation:** Garder les raccourcis natifs de chacun. Tmux a sa logique (préfixe Ctrl+b), Kitty a la sienne. L'harmonisation complète crée plus de confusion qu'autre chose.

---

## 4. COMPORTEMENT DU SCRIPT - Récapitulatif

Basé sur tes réponses:
- ✅ **Idempotent:** OUI (vérifie avant d'agir)
- ✅ **Backup:** TOUJOURS (timestampé dans `~/.config/kitty.backup.YYYYMMDD_HHMMSS/`)
- ✅ **Verbosité:** TOUJOURS (pas besoin de flag --verbose)
- ✅ **Debug:** Intégré dans la verbosité (set -x quand tu veux, ou sortie détaillée)
- ✅ **Thème:** Dracula (déjà en place sur ton système)

---

## 5. STRUCTURE FINALE PROPOSÉE

```
infra-startup/
├── scripts/
│   └── desktop/
│       ├── install-kitty.sh          # ← SCRIPT PRINCIPAL (idempotent, verbeux)
│       └── kitty/
│           ├── kitty.conf            # ← Config versionnée (symlink vers ~/.config/kitty/)
│           ├── themes/
│           │   └── dracula.conf      # ← Thème Dracula
│           └── README.md             # ← Documentation d'utilisation
```

---

## QUESTION FINALE POUR TOI

Maintenant que tu as l'architecture complète:

1. **Quelle gestion de config?**
   - **A - Symlink** (recommandé: single source of truth)
   - **B - Copie statique** (plus robuste si repo déplacé)

2. **Keybindings harmonieux?**
   - **OUI** - Configurer quelques raccourcis communs (splits, navigation)
   - **NON** - Garder les raccourcis natifs de chaque outil (recommandé pour débuter)

3. **Police par défaut?**
   - **JetBrains Mono** (excellente lisibilité, ligatures)
   - **Fira Code** (très populaire, ligatures)
   - **Police système KDE** (pas d'installation nécessaire)

Réponds-moi et je crée la todo list définitive.
