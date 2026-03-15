# The Kitty Addon for Open Agents Control (OAC)
## A Terminal Environment Module for Visual AI-Assisted Development

**For:** OAC Framework Creators & Contributors
**Purpose:** Documenting the Kitty terminal wrapper/module that enhances OAC with IDE-like visual workflows
**Philosophy:** "Toyota Tercel" — explicit, minimal, mastered

---

## 1. THE KITTY ADDON PURPOSE

### 1.1 Problem Statement for OAC Users

**The Gap:** OAC is a CLI-based AI coding framework. By design, it operates in a terminal interface with a TUI (Terminal User Interface). While this provides power and flexibility, it creates a **visibility problem** during AI-assisted development:

```
PROBLEM SCENARIO (Without Kitty Addon):
┌─────────────────────────────────────────────────────────────┐
│  Terminal (Full Screen)                                     │
│  ─────────────────────                                      │
│                                                             │
│  $ opencode "add auth system"                               │
│  > [OpenCoder] I'll modify:                                 │
│    - src/server.ts                                          │
│    - src/routes/auth.ts                                     │
│    - src/db/schema.ts                                       │
│                                                             │
│  Approve? [y/n/e/d] > y                                     │
│                                                             │
│  ✓ Files modified                                           │
│                                                             │
│  [User switches to VS Code to review changes...]            │
│  [Alt-Tab, Alt-Tab, context switching fatigue...]           │
│  [User forgets what was changed, has to re-read...]         │
└─────────────────────────────────────────────────────────────┘
```

**The Friction Points:**
1. **Context Switching** — Terminal → IDE → Terminal → IDE repeatedly
2. **Delayed Visual Feedback** — Can't see files being modified in real-time
3. **Approval Blindness** — Approving changes without seeing the actual file context
4. **Workflow Fragmentation** — OAC runs in isolation from the code editor

### 1.2 The Solution: Split-Screen Bridge

**The Kitty Addon bridges the CLI-to-IDE gap** by orchestrating a side-by-side layout where:

```
SOLUTION (With Kitty Addon):
┌─────────────────────────────────────────────────────────────┐
│  VS Code (Left, 70%)          │  Kitty + OAC (Right, 30%)   │
│  ─────────────────            │  ─────────────────────────  │
│                               │                             │
│  📁 src/                      │  $ opencode                 │
│   ├─ server.ts ← modified    │  > "add auth system"        │
│   ├─ routes/                  │                             │
│   │  └─ auth.ts ← new        │  [OpenCoder] Proposing:     │
│   └─ db/                      │  1. src/server.ts           │
│      └─ schema.ts ← modified │  2. src/routes/auth.ts      │
│                               │  3. src/db/schema.ts        │
│  [You SEE files change live]  │                             │
│  [You SEE the diff in VS Code]│  Approve? [y/n/e/d] > _     │
│                               │  [You approve WITH context] │
└─────────────────────────────────────────────────────────────┘
```

**Value Proposition:**
- **Zero Context Switching** — Eyes never leave the screen
- **Live File Watching** — See files appear/modify as OAC works
- **Informed Approvals** — Review actual file state before approving
- **Unified Workflow** — Terminal and IDE become one cohesive environment

### 1.3 Target Audience

This addon is for OAC users who:
- Use a graphical IDE (VS Code, IntelliJ, etc.) alongside OAC
- Want visual confirmation of AI-generated changes
- Prefer not to Alt-Tab between terminal and editor
- Work on complex multi-file features where seeing the big picture matters

---

## 2. SEPARATION OF CONCERNS

### 2.1 Where OAC Ends (Core Framework Responsibilities)

**OAC handles:**
- Agent orchestration and delegation
- Context file discovery and loading
- Pattern-based code generation
- Approval gate logic and user prompts
- Model interaction (Claude, GPT, etc.)
- Subagent coordination (ContextScout, CoderAgent, etc.)

**OAC does NOT handle:**
- Terminal environment setup
- Window management
- IDE integration
- Font/rendering configuration
- Installation of dependencies (Kitty, fonts)

### 2.2 Where The Kitty Addon Begins (Module Responsibilities)

**The Kitty Addon handles:**

| Responsibility | Description |
|----------------|-------------|
| **Terminal Environment** | Installing and configuring Kitty terminal |
| **Visual Layout** | Window sizing, positioning, split-screen optimization |
| **Launch Shortcuts** | Keybindings to launch OAC from within Kitty |
| **Configuration Management** | Symlink strategy for version-controlled settings |
| **Installation Orchestration** | Idempotent scripts with backup strategies |
| **TUI Optimization** | Truecolor, fonts, scrollback for OAC's interface |

### 2.3 Architectural Boundary

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SYSTEM ARCHITECTURE                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    OAC FRAMEWORK (Unmodified)                       │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                 │   │
│  │  │   Agents    │  │   Context   │  │  Approval   │                 │   │
│  │  │  (Core)     │  │   System    │  │   Gates     │                 │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘                 │   │
│  │                                                                     │   │
│  │  Entry Point: opencode [args]                                      │   │
│  │  Interface: TUI (stdin/stdout)                                     │   │
│  │  Config: ~/.config/opencode/ or ./.opencode/                       │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    ▲                                        │
│                                    │ Launches in                             │
│                                    │                                         │
│  ┌─────────────────────────────────┴─────────────────────────────────────┐   │
│  │                    KITTY ADDON MODULE (This System)                   │   │
│  │                                                                       │   │
│  │  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐    │   │
│  │  │   install-       │  │   kitty.conf     │  │   Window         │    │   │
│  │  │   kitty.sh       │  │   (shortcuts,    │  │   Management     │    │   │
│  │  │                  │  │   sizing)        │  │   (KDE snap)     │    │   │
│  │  └──────────────────┘  └──────────────────┘  └──────────────────┘    │   │
│  │                                                                       │   │
│  │  ┌──────────────────┐  ┌──────────────────┐                          │   │
│  │  │   install-       │  │   Symlink        │                          │   │
│  │  │   opencode.sh    │  │   Config Mgmt    │                          │   │
│  │  │   (orchestrates  │  │   (Git → System) │                          │   │
│  │  │    OAC install)  │  │                  │                          │   │
│  │  └──────────────────┘  └──────────────────┘                          │   │
│  │                                                                       │   │
│  │  Entry Point: Ctrl+Shift+O (launch opencode)                         │   │
│  │  Interface: Terminal window positioned alongside IDE                 │   │
│  │  Config: ~/Dev/kuber-kluster/05-DESKTOPS/kitty/ → ~/.config/kitty/  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Key Principle:** The Kitty Addon wraps OAC but does not modify it. OAC remains unaware of Kitty's existence — it simply runs in a terminal that happens to be optimized for side-by-side workflows.

---

## 3. SPECIFIC FEATURES OF THE KITTY ADDON

### 3.1 The Split-Screen Workflow

**Core Innovation:** A documented, reproducible window layout that positions Kitty (running OAC) alongside the IDE.

#### **Layout Specifications:**

```
┌─────────────────────────────────────────────────────────────┐
│  KDE Plasma Desktop (or any DE with window snapping)        │
├────────────────────────────────┬────────────────────────────┤
│                                │                            │
│  WIDTH: 70% of screen          │  WIDTH: 30% of screen      │
│  HEIGHT: Full                  │  HEIGHT: 100c × 30c chars  │
│                                │                            │
│  VS Code                       │  Kitty Terminal            │
│  ─────────                     │  ─────────────             │
│  • File Explorer               │  • OAC TUI Interface       │
│  • Code Editor                 │  • Approval Prompts        │
│  • Diff Viewer                 │  • Execution Logs          │
│  • Git Integration             │  • Scrollback (10k lines)  │
│                                │                            │
│  [Meta + ← Snap]               │  [Meta + → Snap]           │
│                                │                            │
└────────────────────────────────┴────────────────────────────┘
```

#### **Three Usage Modes:**

| Mode | Trigger | Layout | Use Case |
|------|---------|--------|----------|
| **Architect Mode** | `code .` + `kitty` + manual snap | Split-screen 70/30 | Complex development with OAC |
| **Repairman Mode** | `kitty` full-screen | Full-screen | Quick commands, SSH, debugging |
| **OAC Active Mode** | `Ctrl+Shift+O` in Kitty | Split-screen with agent | Multi-step approval workflows |

#### **Window Positioning Methods:**

The addon supports three methods to achieve the split-screen:

1. **Manual Snap (Primary Method):**
   ```bash
   # VS Code
   code ~/project &
   sleep 2 && xdotool search --class code windowactivate key Meta+Left

   # Kitty (pre-sized)
   kitty --directory ~/project &
   sleep 1 && xdotool search --class kitty windowactivate key Meta+Right
   ```

2. **Predefined Window Size (Kitty config):**
   ```conf
   # kitty.conf
   remember_window_size yes
   initial_window_width  100c   # Character-based sizing
   initial_window_height 30c
   ```

3. **Alias Method (User-customizable):**
   ```bash
   # ~/.zshrc
   alias opencode-workflow='code ~/project & kitty --directory ~/project &'
   ```

### 3.2 Configuration Management (Symlink Strategy)

**Problem:** Traditional dotfile management copies configs to `~/.config/`, creating divergence between repo and system.

**Solution:** Symlink from system to repo — the repo IS the configuration.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      SINGLE SOURCE OF TRUTH FLOW                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   REPO (Git-Versioned)              SYSTEM (Runtime)                        │
│   ─────────────────────             ────────────────                        │
│                                                                             │
│   05-DESKTOPS/kitty/                ~/.config/                              │
│   ├── kitty.conf                    │                                       │
│   ├── themes/                       └── kitty/  ◄── SYMLINK ──┐            │
│   │   └── dracula.conf                      │                  │            │
│   └── opencode/                             ▼                  │            │
│       └── ...                      ~/Dev/kuber-kluster/        │            │
│                                         05-DESKTOPS/kitty/  ◄──┘            │
│                                                                             │
│   Edit in VS Code ──────────────────────► Instant activation in Kitty       │
│   git commit ───────────────────────────► Version-controlled config         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Benefits:**
- ✅ Edit once in VS Code, active everywhere
- ✅ Git history for configuration changes
- ✅ No "which version is correct?" confusion
- ✅ Reproducible across machines

**Trade-off:** Moving the repo breaks the symlink (documented, easy fix with re-run).

### 3.3 Idempotent Installation Scripts

**Philosophy:** Scripts should be safe to run multiple times without side effects.

#### **install-kitty.sh Features:**

```bash
# Core safety mechanisms:
set -euo pipefail                    # Strict error handling
check_command kitty                  # Detect existing installation
BACKUP_DIR="kitty.backup.$(date +%Y%m%d_%H%M%S)"  # Always backup
DRY_RUN=false                        # Simulation mode available
```

**Idempotency Logic:**
```bash
detect_kitty() {
    if check_command kitty; then
        log_info "✓ Kitty déjà installé"
        return 0  # Skip installation, proceed to config
    fi
}
```

**Backup Strategy:**
```bash
backup_existing_config() {
    if [[ -d "$USER_KITTY_DIR" && ! -L "$USER_KITTY_DIR" ]]; then
        # Real directory (not symlink) — back it up
        cp -r "$USER_KITTY_DIR" "$BACKUP_DIR"
        log_success "Backup créé: $BACKUP_DIR"
    fi
}
```

#### **install-opencode.sh Features:**

| Feature | Implementation | Purpose |
|---------|---------------|---------|
| **Config Layering** | `config.env` → `config.env.local` | Versioned defaults + local secrets |
| **Dependency Check** | `step1_check_prerequisites()` | Fail fast with clear messages |
| **Existing Detection** | `step2_detect_existing()` | Idempotent behavior |
| **Verbose Logging** | `log_info()`, `log_success()` | Transparency in every step |
| **Dry-Run Mode** | `DRY_RUN=true` | Preview changes without applying |

**Configuration Precedence:**
```
1. config.env (versioned defaults)
2. config.env.local (user overrides, gitignored)
3. Environment variables (runtime overrides)
```

### 3.4 Terminal UI Optimizations for OAC

The addon configures Kitty specifically for OAC's TUI interface:

#### **Visual Configuration:**

```conf
# kitty.conf

# ============================================
# FONTS (Powerlevel10k + Nerd Fonts)
# ============================================
font_family      MesloLGS NF
font_size 11.0

# ============================================
# GPU ACCELERATION
# ============================================
repaint_delay 10
input_delay 3
sync_to_monitor yes

# ============================================
# TRUECOLOR (Required for OAC's TUI)
# ============================================
# Kitty default — no config needed
# Ensures OAC's colors render correctly

# ============================================
# SCROLLBACK (For long OAC sessions)
# ============================================
scrollback_lines 10000
scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS

# ============================================
# OPENCODE SHORTCUTS (The Bridge)
# ============================================
map ctrl+shift+o launch --type=tab opencode
map ctrl+shift+a launch --type=tab opencode --agent OpenAgent
map ctrl+shift+alt+o launch opencode  # New window for split-screen

# ============================================
# SPLIT-SCREEN SIZING
# ============================================
initial_window_width  100c
initial_window_height 30c
```

#### **Why These Settings Matter for OAC:**

| Setting | OAC Benefit |
|---------|-------------|
| **MesloLGS NF** | Nerd Fonts icons render correctly in OAC's TUI |
| **GPU Acceleration** | Smooth scrolling through long agent outputs |
| **Truecolor** | OAC's syntax highlighting and UI colors accurate |
| **10k Scrollback** | Can review entire long agent conversations |
| **Ctrl+Shift+O** | Launch OAC without leaving the keyboard |
| **100c × 30c** | Perfect size for right-side split-screen |

---

## 4. TECHNICAL IMPLEMENTATION

### 4.1 Module Structure

```
05-DESKTOPS/kitty/                          # MODULE ROOT
├── kitty.conf                              # Terminal config (shortcuts, sizing)
├── install-kitty.sh                        # Idempotent Kitty installer
├── test_kitty.sh                           # Configuration verifier
├── themes/
│   └── dracula.conf                        # Color scheme
├── README.md                               # User documentation
└── opencode/                               # OAC INTEGRATION SUBMODULE
    ├── install-opencode.sh                 # OAC orchestrator script
    ├── config.env                          # Default configuration
    ├── config.env.local                    # User secrets (gitignored)
    ├── WORKFLOW.md                         # Split-screen usage guide
    └── README.md                           # Integration documentation
```

### 4.2 How The Module Orchestrates Without Modifying OAC

**Principle:** OAC runs unchanged; the module optimizes the environment around it.

#### **Integration Points:**

| Integration | Mechanism | OAC Awareness |
|-------------|-----------|---------------|
| **Launch** | Kitty keybinding `Ctrl+Shift+O` | None — just runs `opencode` |
| **Display** | Window sizing in `kitty.conf` | None — OAC sees standard terminal |
| **Config** | Symlink `~/.config/kitty/` → repo | None — OAC doesn't read Kitty config |
| **Fonts** | `font_family MesloLGS NF` | None — OAC inherits terminal font |
| **Install** | `install-opencode.sh` wraps OAC installer | None — calls official install script |

#### **Data Flow:**

```
1. USER PRESSES Ctrl+Shift+O IN KITTY
   ↓
2. KITTY CONFIG (kitty.conf:152)
   map ctrl+shift+o launch --type=tab opencode
   ↓
3. SHELL EXECUTES "opencode"
   ↓
4. OAC STARTS (unchanged, unaware of Kitty)
   ↓
5. OAC TUI RENDERS
   ↓
6. KITTY DISPLAYS TUI (with truecolor, proper fonts, etc.)
   ↓
7. USER SEES OAC INTERFACE optimized by Kitty settings
```

### 4.3 The Installation Orchestration Flow

**install-kitty.sh:**
```bash
main() {
    detect_os                    # Debian/Ubuntu check
    detect_shell                 # zsh/bash detection
    detect_kitty                 # Idempotency check

    if [[ -d "$USER_KITTY_DIR" && ! -L "$USER_KITTY_DIR" ]]; then
        backup_existing_config   # Safety first
        rm -rf "$USER_KITTY_DIR"
    fi

    install_kitty_debian         # apt-get install kitty
    install_fonts                # MesloLGS NF

    ln -sf "$REPO_KITTY_DIR" "$USER_KITTY_DIR"  # Symlink strategy

    verify_installation          # Confirm everything works
}
```

**install-opencode.sh:**
```bash
main() {
    load_config                  # config.env + config.env.local

    step1_check_prerequisites    # curl, git, node (if npm method)
    step2_detect_existing        # Idempotency
    step3_install_opencode       # curl -fsSL https://opencode.ai/install | bash
    step4_install_openagents     # git clone OpenAgentsControl
    step5_configure_shell        # Add to PATH if needed

    show_summary                 # Next steps for user
}
```

### 4.4 KDE Plasma Integration (Window Management)

The addon leverages KDE's window snapping for the split-screen layout:

```conf
# User workflow (documented in WORKFLOW.md)
1. Open VS Code: code ~/project
2. Meta + Left Arrow  → Snap VS Code to left 70%
3. Open Kitty: kitty
4. Meta + Right Arrow → Snap Kitty to right 30%
```

**Note:** The addon doesn't automate window snapping (would require xdotool/wmctrl dependencies) but documents the manual method and provides window sizing presets.

### 4.5 Extensibility Hooks

The module provides clear extension points:

| Hook | Location | Purpose |
|------|----------|---------|
| **Custom Keybindings** | `kitty.conf` after line 160 | Add more OAC agent shortcuts |
| **Pre-Install Hooks** | `install-opencode.sh` step1 | Add custom dependency checks |
| **Post-Install Hooks** | `install-opencode.sh` step5 | Add shell customization |
| **Config Overrides** | `config.env.local` | User-specific settings |

---

## 5. SUMMARY

### What This Module Adds to OAC

| Without Kitty Addon | With Kitty Addon |
|--------------------|--------------------|
| OAC runs in any terminal | OAC runs in an optimized, pre-configured terminal |
| User manually manages window layout | User follows documented split-screen pattern |
| Configuration scattered | Configuration version-controlled and symlinked |
| Generic terminal experience | TUI-optimized (truecolor, fonts, scrollback) |
| Launch OAC via shell command | Launch OAC via `Ctrl+Shift+O` keybinding |
| Installation manual per system | Installation idempotent and automated |

### The Core Value

**The Kitty Addon transforms OAC from a CLI tool into a visual IDE companion.** It doesn't change how OAC works — it changes how the user *experiences* OAC by:

1. **Bridging the CLI-to-IDE gap** with a side-by-side workflow
2. **Eliminating context switching** through window orchestration
3. **Enabling informed approvals** by showing file changes in real-time
4. **Providing reproducible configuration** through symlink-based dotfiles

### Maintenance Boundary

- **OAC Updates:** Transparent — OAC updates independently via its own installer
- **Kitty Updates:** Managed by system package manager (`apt upgrade`)
- **Config Updates:** Edit in repo, commit, pull on other machines
- **Breaking Changes:** None expected — OAC CLI interface is stable

---

*This module is a terminal environment wrapper, not a fork or modification of OAC. It respects the separation between the AI framework and the developer's terminal experience.*
