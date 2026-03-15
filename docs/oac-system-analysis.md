# Kitty + OpenCode + Open Agents Control (OAC)
## Comprehensive System Analysis & Architecture Documentation

**Date:** 2026-03-15
**Analysis Scope:** Complete reverse-engineering of the custom AI-assisted development workflow
**Philosophy:** "Toyota Tercel" — Minimal, explicit, mastered, no technical debt

---

## 1. HIGH-LEVEL ARCHITECTURE & METHODOLOGY

### 1.1 Core Philosophy: The "Toyota Tercel" Approach

This system embodies a **minimalist, controlled, and explicit** approach to AI-assisted development. Named after the reliable Toyota Tercel (simple, fixable, no black boxes), the philosophy rejects:
- ❌ **Magic black boxes** — Every step must be understandable
- ❌ **Technical debt** — No shortcuts that create future problems
- ❌ **Bloated complexity** — Only what's necessary
- ❌ **Vendor lock-in** — Model-agnostic, editable, portable

**In Practice:**
- Code patterns are explicitly defined, not inferred
- AI agents request approval before every action
- Configuration is version-controlled and symlinked (single source of truth)
- Installation scripts are idempotent, verbose, and always backup before modifying

---

### 1.2 System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         THE THREE PILLARS                                   │
├──────────────────┬─────────────────────┬────────────────────────────────────┤
│     KITTY        │     OPENCODE        │   OPEN AGENTS CONTROL (OAC)        │
│   (Terminal)     │   (AI CLI Tool)     │   (Agent Framework)                │
├──────────────────┼─────────────────────┼────────────────────────────────────┤
│ • GPU-accelerated│ • Open-source AI    │ • Pattern-learning agents          │
│ • Truecolor TUI  │   coding interface  │ • Approval gates                   │
│ • Split-screen   │ • Multi-model       │ • Context management               │
│   optimized      │   support           │ • Specialized subagents            │
└──────────────────┴─────────────────────┴────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                      SPLIT-SCREEN WORKFLOW LAYOUT                           │
│                                                                             │
│  ┌─────────────────────────────────────┬─────────────────────────────────┐  │
│  │                                     │                                 │  │
│  │      VS CODE (70% width)            │    KITTY + OpenCode (30%)       │  │
│  │      ─────────────────              │    ─────────────────────        │  │
│  │                                     │                                 │  │
│  │  • File explorer                    │  • Interactive TUI interface    │  │
│  │  • Code editor (live edits)         │  • AI prompts & responses       │  │
│  │  • Diff viewer (proposed changes)   │  • Execution logs               │  │
│  │  • Source of truth                  │  • Human approval prompts       │  │
│  │                                     │                                 │  │
│  │  [Meta + ← Snap]                    │  [Meta + → Snap]                │  │
│  │                                     │                                 │  │
│  └─────────────────────────────────────┴─────────────────────────────────┘  │
│                                    ↑                                        │
│                     Real-time synchronization via filesystem                │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 1.3 Component Interactions

#### **The Data Flow:**

```
1. USER REQUEST
   ↓
2. KITTY (Terminal)
   ↓ Captures input, launches OpenCode
3. OPCODE (AI CLI)
   ↓ Parses command, loads agent
4. OAC AGENT (e.g., OpenCoder)
   ↓ Discovers context via ContextScout
5. CONTEXT SYSTEM (.opencode/context/)
   ↓ Loads YOUR patterns, standards, conventions
6. AI MODEL (Claude/GPT/Gemini/Local)
   ↓ Generates code using YOUR patterns
7. APPROVAL GATE
   ↓ User reviews in Kitty → approves/modifies/rejects
8. FILE SYSTEM
   ↓ Changes appear in VS Code (left pane)
9. VALIDATION
   ↓ Tests, type-checking, security review
10. SHIP
    ↓ Production-ready code matching your standards
```

#### **IDE Integration Points:**

| Component | Interacts With | Method |
|-----------|---------------|--------|
| **Kitty** | VS Code | Side-by-side window snapping (KDE Meta+Arrow) |
| **OpenCode** | Filesystem | Direct file read/write with approval gates |
| **OAC Agents** | VS Code | Via filesystem changes (user sees live updates) |
| **Context System** | Git | Version-controlled patterns in `.opencode/context/` |

---

### 1.4 Configuration Management Architecture

**The Symlink Strategy (Single Source of Truth):**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           GIT REPOSITORY                                    │
│                    (~/Dev/kuber-kluster/05-DESKTOPS/kitty/)                │
│                                                                             │
│  ┌─────────────────┐          ┌──────────────────────┐                      │
│  │ install-kitty.sh│─────────►│  kitty.conf          │◄── Versioned config  │
│  │ (orchestrator)  │          │  themes/dracula.conf │                      │
│  └─────────────────┘          │  opencode/           │                      │
│                               └──────────────────────┘                      │
│                                         │                                   │
│                              [SYMLINK]  │                                   │
│                                         ▼                                   │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SYSTEM (~/.config/)                              │
│                                                                             │
│  ~/.config/kitty/ ────────► [SYMLINK] ────────► ~/Dev/kuber-kluster/...   │
│                                                                             │
│  Result: Edit in VS Code → Instant activation in Kitty                      │
│          No copy-paste, no divergence, no "which version is true?"          │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Key Principle:** The repository IS the configuration. No templates, no generated files, no drift.

---

## 2. FEATURES & CAPABILITIES

### 2.1 What This System Enables

#### **A. Dual-Personality Workflow**

| Mode | Use Case | Configuration |
|------|----------|---------------|
| **"The Architect"** | Planned development, complex features, code review | Split-screen: VS Code (70%) + Kitty (30%) |
| **"The Repairman"** | Quick fixes, system admin, SSH, debugging | Full-screen Kitty only |
| **"OAC Active"** | Multi-step AI workflows with approval gates | Split-screen with agent delegation visible |

#### **B. AI Code Generation with YOUR Patterns**

**Traditional AI Tools:**
```typescript
// Generic AI output (doesn't match your codebase)
export async function POST(request: Request) {
  const data = await request.json();
  return Response.json({ success: true });
}
// ↓ You spend 20 minutes refactoring to match your patterns
```

**OAC System:**
```typescript
// AI output using YOUR patterns (from .opencode/context/)
export async function POST(request: Request) {
  const body = await request.json();
  const validated = UserSchema.parse(body);        // Your Zod validation
  const result = await db.users.create(validated); // Your Drizzle ORM
  return Response.json(result, { status: 201 });   // Your response format
}
// ↓ Ships immediately, no refactoring needed
```

#### **C. Human-Guided AI (Approval Gates)**

Every action requires explicit approval:

```bash
[OpenCoder] I propose to modify 3 files:
  1. src/server.ts (add authentication middleware)
  2. src/routes/admin.ts (protect /admin routes)
  3. src/db/schema.ts (add sessions table)

Approve? [y/n/e/d/s]
  y = yes (approve all)
  n = no (cancel)
  e = edit (modify the proposal)
  d = diff (see detailed changes)
  s = skip (skip this step)
```

**You are always in control.** No "oh no, what did the AI just do?" moments.

#### **D. ContextScout — Smart Pattern Discovery**

Before generating code, the system discovers relevant patterns:

```
1. Check local: .opencode/context/core/navigation.md
   ↓ Found? → Use local patterns. Done.
   ↓ Not found?
2. Check global: ~/.config/opencode/context/core/navigation.md
   ↓ Found? → Use global patterns for core files only.
   ↓ Not found? → Proceed with defaults.

Priority: Critical → High → Medium (ranked relevance)
```

#### **E. Token Efficiency (MVI Principle)**

**MVI = Minimal Viable Information** — Only load what's needed:

| Aspect | Traditional AI | OAC Approach |
|--------|---------------|--------------|
| Context loaded | Entire codebase | Relevant patterns only |
| Context file size | 2000+ lines | <200 lines per file |
| Token usage | ~8,000 tokens | ~750 tokens (80% reduction) |
| Loading strategy | Eager | Lazy (load when needed) |

---

### 2.2 UI/UX Effects

#### **Visual Layout — Split-Screen Workflow:**

```
┌────────────────────────────────────────────────────────────┐
│ KDE Plasma Desktop                                          │
├────────────────────────────────┬───────────────────────────┤
│   VS CODE                      │   KITTY                   │
│   ─────────                    │   ─────                   │
│                                │                           │
│  📁 src/                       │   $ opencode              │
│   ├─ server.ts ← modified     │   > "Add JWT auth"        │
│   ├─ routes/                   │                           │
│   │  └─ admin.ts ← new        │   [OpenCoder] Proposing:  │
│   └─ db/                       │   1. Add auth middleware  │
│      └─ schema.ts ← modified  │   2. Protect routes       │
│                                │                           │
│  [Diff viewer showing          │   Approve? [y/n/e/d]      │
│   proposed changes]           │   > _                     │
│                                │                           │
│  📝 Changes appear live        │   🤖 Waiting for input    │
│     as you approve            │                           │
└────────────────────────────────┴───────────────────────────┘
     ↑                              ↑
   Mouse/Keyboard              Keyboard only
   Navigation                  (TUI interface)
```

#### **Key UX Benefits:**

| Feature | Effect |
|---------|--------|
| **Live File Watching** | See files appear/modify in VS Code as AI works |
| **Approval Gates** | Review every change before it happens |
| **Diff Preview** | See exactly what will change (`d` option) |
| **Non-Blocking** | Can edit files manually while AI works |
| **Keyboard-Driven** | Efficient TUI in Kitty, mouse-friendly VS Code |

---

### 2.3 Agent Ecosystem

#### **Main Agents:**

| Agent | Purpose | Best For |
|-------|---------|----------|
| **OpenAgent** | General tasks, learning | First-time users, questions, simple features |
| **OpenCoder** | Production development | Complex features, multi-file refactoring |
| **SystemBuilder** | Custom AI systems | Building domain-specific agent systems |

#### **Specialized Subagents (Auto-Delegated):**

| Subagent | Responsibility |
|----------|---------------|
| **ContextScout** | Discovers relevant patterns from context files |
| **TaskManager** | Breaks complex features into atomic subtasks |
| **CoderAgent** | Focused code implementations |
| **TestEngineer** | Test authoring and TDD |
| **CodeReviewer** | Security analysis and code review |
| **BuildAgent** | Type checking and build validation |
| **DocWriter** | Documentation generation |
| **ExternalScout** | Fetches live docs for external libraries |

---

### 2.4 Terminal (Kitty) Features

| Feature | Configuration | Purpose |
|---------|--------------|---------|
| **GPU Acceleration** | Native | Smooth TUI rendering |
| **Truecolor** | 24-bit color | Accurate Dracula theme |
| **Font** | MesloLGS NF | Powerlevel10k + Nerd Fonts compatibility |
| **Split-Screen Size** | 100c × 30c | Optimized for side-by-side with VS Code |
| **Scrollback** | 10,000 lines | Full log history |
| **Copy-on-Select** | Enabled | Fast clipboard integration |
| **Opencode Shortcuts** | Ctrl+Shift+O | Launch OpenCode instantly |

---

## 3. LIMITATIONS & BOUNDARIES

### 3.1 Hard Limits

| Limitation | Description | Reasoning |
|------------|-------------|-----------|
| **Sequential Execution** | Agents work one step at a time | Approval gates require human input between steps |
| **No Full Autonomy** | Cannot run unsupervised | Philosophy: Human must approve every action |
| **Context File Size** | <200 lines recommended | MVI principle — large contexts reduce efficiency |
| **Debian Repos Only** | Kitty from official repos | "Toyota Tercel" — no external binaries |
| **Approval Required** | Every file write needs `y` | No "--yes-to-all" mode exists |

### 3.2 What It Does NOT Do

❌ **Autonomous Execution** — Unlike Oh My OpenCode, this system will NOT run without human approval at each step

❌ **Parallel Agents** — Subagents execute sequentially, not in parallel (trade-off for control)

❌ **Full Codebase Context** — Intentionally does NOT load entire codebase (token efficiency > completeness)

❌ **Auto-Retry on Error** — Stops and asks instead of automatically retrying failed operations

❌ **Zero-Config Setup** — Requires initial `/add-context` to teach your patterns (10-15 minutes)

❌ **Magic Problem-Solving** — Won't fix architectural issues; enforces YOUR patterns, not create new ones

### 3.3 Bottlenecks & Friction Points

| Bottleneck | Impact | Mitigation |
|------------|--------|------------|
| **Approval Latency** | Each step waits for human input | Use for complex tasks only; quick tasks in full-screen Kitty |
| **Pattern Maintenance** | Context files need updating as project evolves | `/add-context --update` command |
| **Symlink Fragility** | Moving repo breaks Kitty config | Documented in README; easy to re-run install script |
| **Model API Dependency** | Requires API keys (Anthropic/OpenAI/Google) | Local model support available |
| **Learning Curve** | Understanding approval gates and context system | Start with OpenAgent; documentation in WORKFLOW.md |

### 3.4 When NOT to Use This System

⚠️ **Skip OAC if you:**
- Want "just do it" mode without approvals
- Need multi-agent parallelization (use Oh My OpenCode instead)
- Don't have established coding patterns yet
- Prefer plug-and-play with zero configuration
- Need fully autonomous execution

---

## 4. CODE-LEVEL BREAKDOWN

### 4.1 File Inventory

#### **Core Kitty Configuration:**

| File | Path | Role |
|------|------|------|
| [`kitty.conf`](05-DESKTOPS/kitty/kitty.conf:1) | `05-DESKTOPS/kitty/kitty.conf` | Main terminal configuration (fonts, theme, shortcuts, window sizing) |
| [`dracula.conf`](05-DESKTOPS/kitty/themes/dracula.conf:1) | `05-DESKTOPS/kitty/themes/dracula.conf` | Dracula color scheme for truecolor support |
| [`install-kitty.sh`](05-DESKTOPS/kitty/install-kitty.sh:1) | `05-DESKTOPS/kitty/install-kitty.sh` | Idempotent installation script with backup and symlink creation |
| [`test_kitty.sh`](05-DESKTOPS/kitty/test_kitty.sh:1) | `05-DESKTOPS/kitty/test_kitty.sh` | Verification script for configuration |

#### **OpenCode Integration:**

| File | Path | Role |
|------|------|------|
| [`install-opencode.sh`](05-DESKTOPS/kitty/opencode/install-opencode.sh:1) | `05-DESKTOPS/kitty/opencode/install-opencode.sh` | Installs OpenCode CLI and OAC framework |
| [`config.env`](05-DESKTOPS/kitty/opencode/config.env) | `05-DESKTOPS/kitty/opencode/config.env` | Configuration template (versioned) |
| [`config.env.local`](05-DESKTOPS/kitty/opencode/config.env.local) | `05-DESKTOPS/kitty/opencode/config.env.local` | Local API keys (NOT versioned) |

#### **Documentation:**

| File | Path | Role |
|------|------|------|
| [`README.md`](05-DESKTOPS/kitty/README.md:1) | `05-DESKTOPS/kitty/README.md` | Kitty setup and usage guide |
| [`README.md`](05-DESKTOPS/kitty/opencode/README.md:1) | `05-DESKTOPS/kitty/opencode/README.md` | OpenCode/OAC installation and configuration |
| [`WORKFLOW.md`](05-DESKTOPS/kitty/opencode/WORKFLOW.md:1) | `05-DESKTOPS/kitty/opencode/WORKFLOW.md` | Split-screen workflow guide with examples |
| [`kitty_architecture_decisions.md`](07-DOCS/kitty_architecture_decisions.md:1) | `07-DOCS/kitty_architecture_decisions.md` | Rationale for symlink vs copy vs template approaches |
| [`kitty_context.md`](07-DOCS/kitty_context.md:1) | `07-DOCS/kitty_context.md` | Context and decisions summary |
| [`kitty_workflow_splitscreen.md`](07-DOCS/kitty_workflow_splitscreen.md:1) | `07-DOCS/kitty_workflow_splitscreen.md` | Detailed split-screen workflow documentation |
| [`open_agent_control.md`](07-DOCS/open_agent_control.md:1) | `07-DOCS/open_agent_control.md` | Complete OAC framework documentation |

---

### 4.2 Key Configuration Details

#### **Kitty Configuration Highlights:**

```conf
# From kitty.conf
# ============================================
# FONTS (Powerlevel10k compatible)
# ============================================
font_family      MesloLGS NF
font_size 11.0

# ============================================
# OPENCODE / WORKFLOW SPLIT-SCREEN
# ============================================
remember_window_size yes
initial_window_width  100c   # ~100 chars wide
initial_window_height 30c    # ~30 lines tall

# ============================================
# OPENCODE SHORTCUTS
# ============================================
# Ctrl+Shift+O : Ouvrir OpenCode dans un nouvel onglet
# Ctrl+Shift+A : Ouvrir avec agent
```

#### **Installation Script Features:**

```bash
# From install-kitty.sh & install-opencode.sh

# Core Principles:
set -euo pipefail          # Strict error handling

# Idempotency:
detect_kitty() {
    if check_command kitty; then
        log_info "✓ Kitty déjà installé"
        return 0
    fi
}

# Backup Strategy:
BACKUP_DIR="${HOME}/.config/kitty.backup.$(date +%Y%m%d_%H%M%S)"
backup_existing_config() {
    if [[ -d "$USER_KITTY_DIR" ]]; then
        cp -r "${USER_KITTY_DIR}/*" "${BACKUP_DIR}/"
    fi
}

# Symlink Creation (Single Source of Truth):
execute "Création du symlink vers le repo" \
        "ln -sf '${REPO_KITTY_DIR}' '${USER_KITTY_DIR}'"
```

---

### 4.3 OAC Context System Structure

```
~/.config/opencode/ or ./.opencode/ (project-local)
├── agent/
│   ├── core/
│   │   ├── opencoder.md       # Production development agent
│   │   ├── openagent.md       # General purpose agent
│   │   └── systembuilder.md   # Custom AI system builder
│   └── specialized/
│       ├── contextscout.md    # Pattern discovery
│       ├── taskmanager.md     # Task breakdown
│       ├── coderagent.md      # Code implementation
│       ├── testengineer.md    # Test authoring
│       ├── codereviewer.md    # Security review
│       └── externalscout.md   # Live documentation fetch
├── context/
│   ├── core/
│   │   ├── navigation.md      # Standards & workflows
│   │   ├── code-quality.md    # Your code standards
│   │   ├── ui-design.md       # Design system patterns
│   │   └── task-management.md # Workflow definitions
│   ├── libraries/
│   │   ├── react.md           # React-specific patterns
│   │   ├── drizzle.md         # ORM patterns
│   │   └── zod.md             # Validation patterns
│   └── project-intelligence/
│       ├── tech-stack.md      # Your tech stack
│       ├── api-patterns.md    # Your API conventions
│       ├── component-patterns.md # Your component style
│       └── naming-conventions.md # Your naming rules
└── commands/
    ├── add-context.md         # Pattern wizard
    ├── commit.md              # Smart git commits
    └── test.md                # Testing workflows
```

---

## 5. SUMMARY

### What You've Built

This is a **human-centered AI development environment** that prioritizes **control, transparency, and code quality** over speed and autonomy.

**Key Innovations:**
1. **Split-Screen Workflow** — Visual approval process with VS Code + Kitty
2. **Pattern-Learning Agents** — AI that writes YOUR code, not generic code
3. **Symlink Configuration** — Single source of truth, version-controlled
4. **Toyota Tercel Philosophy** — Explicit, minimal, maintainable

**Target User:**
- Developers with established patterns
- Teams needing consistent code quality
- Users who want AI assistance without losing control

**Not For:**
- Users wanting fully autonomous AI
- Rapid prototyping without standards
- Those unwilling to invest 10-15 minutes in initial setup

---

## 6. COMMUNITY SHARING NOTES

This system is **highly reproducible** and **well-documented**. To share with the open-source community:

1. **The Core Pattern** — The split-screen approval workflow is language-agnostic
2. **The Context System** — MVI principle and pattern files can adapt to any stack
3. **The Philosophy** — "Toyota Tercel" resonates with developers tired of complexity
4. **The Installation** — Idempotent scripts make onboarding easy

**Potential Community Value:**
- Alternative to Cursor/Copilot for control-focused developers
- Educational example of human-in-the-loop AI workflows
- Starting point for custom agent frameworks

---

*Documentation generated by reverse-engineering analysis of the Kuber-Kluster workspace.*
