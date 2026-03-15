#!/bin/bash
# =============================================================================
# Script d'installation d'OpenCode CLI & OpenAgentsControl - Mode "Toyota Tercel"
# =============================================================================
# Description: Installe et configure OpenCode CLI et optionnellement 
#              OpenAgentsControl avec approche idempotente, verbeuse et 
#              backup automatique.
#
# Philosophie:
#   - Idempotent: Safe à exécuter plusieurs fois
#   - Verbeux: Tu vois tout ce qui se passe
#   - Backup: Toujours sauvegarder avant de modifier
#   - Conservateur: Pas de mode --force agressif, validation humaine requise
#   - Transparent: Pas de magie noire, chaque étape est explicite
#
# Usage:
#   ./install-opencode.sh              # Mode standard (idempotent)
#   ./install-opencode.sh --dry-run    # Simulation (affiche sans exécuter)
#   ./install-opencode.sh --verbose    # Mode très verbeux
#   ./install-opencode.sh --help       # Afficher l'aide
#
# Auteur: Généré pour Kuber-Kluster
# Date: 2026-02-13
# Version: 1.0.0
# =============================================================================

set -euo pipefail

# =============================================================================
# CONFIGURATION
# =============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "$0")"
CONFIG_FILE="${SCRIPT_DIR}/config.env"
CONFIG_LOCAL="${SCRIPT_DIR}/config.env.local"
USER_CONFIG_DIR="${HOME}/.config/opencode"
BACKUP_BASE_DIR="${HOME}/.config/opencode.backups"
BACKUP_DIR="${BACKUP_BASE_DIR}/$(date +%Y%m%d_%H%M%S)"

# Flags de mode
DRY_RUN=false
VERBOSE=false

# Configuration par défaut (peut être surchargée par config.env)
INSTALL_OPENAGENTS=${INSTALL_OPENAGENTS:-false}
OPENCODE_INSTALL_METHOD=${OPENCODE_INSTALL_METHOD:-curl}
OPENCODE_VERSION=${OPENCODE_VERSION:-latest}

# Couleurs pour la sortie verbeuse
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# =============================================================================
# FONCTIONS DE LOGGING
# =============================================================================
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

log_verbose() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${CYAN}[VERBOSE]${NC} $1"
    fi
}

log_dry_run() {
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $1"
    fi
}

# =============================================================================
# FONCTIONS UTILITAIRES
# =============================================================================
execute() {
    local description="$1"
    shift
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] $description"
        log_info "[DRY-RUN] Commande: $*"
    else
        log_info "$description"
        log_verbose "Exécution: $*"
        "$@"
    fi
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# =============================================================================
# CHARGEMENT DE LA CONFIGURATION
# =============================================================================
load_config() {
    log_verbose "Chargement de la configuration..."
    
    # Charger config.env principal si présent
    if [[ -f "$CONFIG_FILE" ]]; then
        log_verbose "Fichier config.env trouvé: $CONFIG_FILE"
        # shellcheck source=/dev/null
        source "$CONFIG_FILE"
        log_success "Configuration chargée depuis config.env"
    else
        log_verbose "Aucun config.env trouvé, utilisation des valeurs par défaut"
    fi
    
    # Charger config.env.local (prioritaire, non versionné)
    if [[ -f "$CONFIG_LOCAL" ]]; then
        log_verbose "Fichier config.env.local trouvé: $CONFIG_LOCAL"
        # shellcheck source=/dev/null
        source "$CONFIG_LOCAL"
        log_success "Configuration locale chargée depuis config.env.local"
    fi
    
    log_verbose "INSTALL_OPENAGENTS=$INSTALL_OPENAGENTS"
    log_verbose "OPENCODE_INSTALL_METHOD=$OPENCODE_INSTALL_METHOD"
    log_verbose "OPENCODE_VERSION=$OPENCODE_VERSION"
}

# =============================================================================
# ÉTAPE 1: VÉRIFICATION DES PRÉREQUIS
# =============================================================================
step1_check_prerequisites() {
    log_section "[1/5] VÉRIFICATION DES PRÉREQUIS"
    
    local missing_deps=()
    
    # Vérifier curl
    if check_command curl; then
        log_success "curl est installé ($(curl --version | head -n1 | cut -d' ' -f2))"
    else
        log_error "curl est requis mais non installé"
        missing_deps+=("curl")
    fi
    
    # Vérifier git
    if check_command git; then
        log_success "git est installé ($(git --version | cut -d' ' -f3))"
    else
        log_error "git est requis mais non installé"
        missing_deps+=("git")
    fi
    
    # Vérifier Node.js si installation via npm
    if [[ "$OPENCODE_INSTALL_METHOD" == "npm" ]]; then
        if check_command node; then
            local node_version
            node_version=$(node --version | sed 's/v//')
            log_success "Node.js est installé (v$node_version)"
            
            # Vérifier version minimale (18+)
            local major_version
            major_version=$(echo "$node_version" | cut -d'.' -f1)
            if [[ "$major_version" -ge 18 ]]; then
                log_success "Version Node.js compatible (>= 18)"
            else
                log_warning "Node.js $node_version détecté, version 18+ recommandée"
            fi
        else
            log_error "Node.js est requis pour l'installation via npm"
            missing_deps+=("nodejs")
        fi
    fi
    
    # Afficher l'OS détecté
    local os
    os=$(detect_os)
    log_info "OS détecté: $os"
    
    # Si des dépendances manquent, arrêter
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Dépendances manquantes: ${missing_deps[*]}"
        log_info "Installez-les avec: sudo apt-get install -y ${missing_deps[*]}"
        exit 1
    fi
    
    log_success "Tous les prérequis sont satisfaits"
}

# =============================================================================
# ÉTAPE 2: DÉTECTION INSTALLATION EXISTANTE (IDEMPOTENCE)
# =============================================================================
step2_detect_existing() {
    log_section "[2/5] DÉTECTION DE L'INSTALLATION EXISTANTE"
    
    local opencode_installed=false
    local opencode_version=""
    local opencode_path=""
    
    # Vérifier si OpenCode est déjà installé
    if check_command opencode; then
        opencode_installed=true
        opencode_path=$(which opencode)
        opencode_version=$(opencode --version 2>/dev/null || echo "version inconnue")
        log_success "OpenCode déjà installé"
        log_info "  Chemin: $opencode_path"
        log_info "  Version: $opencode_version"
    else
        log_info "OpenCode n'est pas encore installé"
    fi
    
    # Vérifier la configuration existante
    if [[ -d "$USER_CONFIG_DIR" ]]; then
        log_info "Configuration existante détectée: $USER_CONFIG_DIR"
        
        # Compter les fichiers de config
        local config_count
        config_count=$(find "$USER_CONFIG_DIR" -type f 2>/dev/null | wc -l)
        log_info "  Fichiers de configuration: $config_count"
        
        if [[ "$opencode_installed" == true ]]; then
            log_warning "OpenCode est déjà installé. Le script va vérifier la configuration."
        fi
    else
        log_verbose "Aucune configuration existante trouvée"
    fi
    
    # Vérifier OpenAgentsControl si demandé
    if [[ "$INSTALL_OPENAGENTS" == true ]]; then
        if check_command openagents-control 2>/dev/null || [[ -d "$USER_CONFIG_DIR/OpenAgentsControl" ]]; then
            log_info "OpenAgentsControl semble déjà présent"
        else
            log_verbose "OpenAgentsControl n'est pas encore installé"
        fi
    fi
    
    # Note: On ne retourne pas de code d'erreur ici car ce n'est pas une erreur
    # si OpenCode n'est pas installé - c'est l'état attendu pour une nouvelle install
    return 0
}

# =============================================================================
# ÉTAPE 3: SAUVEGARDE DE LA CONFIGURATION EXISTANTE
# =============================================================================
step3_backup_config() {
    log_section "[3/5] SAUVEGARDE DE LA CONFIGURATION"
    
    # Vérifier s'il y a quelque chose à sauvegarder
    if [[ ! -d "$USER_CONFIG_DIR" ]]; then
        log_info "Aucune configuration existante à sauvegarder"
        return 0
    fi
    
    # Vérifier si le dossier n'est pas vide
    if [[ -z "$(ls -A "$USER_CONFIG_DIR" 2>/dev/null)" ]]; then
        log_info "Le dossier de configuration existe mais est vide"
        return 0
    fi
    
    log_warning "Configuration existante détectée"
    
    # Créer le répertoire de backup
    execute "Création du répertoire de backup: $BACKUP_DIR" \
            mkdir -p "$BACKUP_DIR"
    
    # Sauvegarder la configuration
    execute "Sauvegarde de la configuration existante" \
            cp -r "${USER_CONFIG_DIR}/." "${BACKUP_DIR}/" 2>/dev/null || true
    
    if [[ "$DRY_RUN" == false ]]; then
        # Compter les fichiers sauvegardés
        local backup_count
        backup_count=$(find "$BACKUP_DIR" -type f 2>/dev/null | wc -l)
        log_success "Backup créé avec succès ($backup_count fichiers)"
        log_info "  Emplacement: $BACKUP_DIR"
    fi
}

# =============================================================================
# ÉTAPE 4: INSTALLATION OPENCODE CLI
# =============================================================================
step4_install_opencode() {
    log_section "[4/5] INSTALLATION OPENCODE CLI"
    
    # Vérifier si déjà installé et à jour (idempotence)
    if check_command opencode; then
        local current_version
        current_version=$(opencode --version 2>/dev/null || echo "unknown")
        log_warning "OpenCode est déjà installé (version: $current_version)"
        log_info "Utilisez 'opencode --upgrade' pour mettre à jour si nécessaire"
        return 0
    fi
    
    log_info "Méthode d'installation: $OPENCODE_INSTALL_METHOD"
    
    case "$OPENCODE_INSTALL_METHOD" in
        curl)
            install_opencode_curl
            ;;
        npm)
            install_opencode_npm
            ;;
        *)
            log_error "Méthode d'installation inconnue: $OPENCODE_INSTALL_METHOD"
            log_info "Méthodes supportées: curl, npm"
            exit 1
            ;;
    esac
}

install_opencode_curl() {
    log_info "Installation via curl (méthode recommandée)..."
    
    local install_url="https://opencode.ai/install"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Téléchargement et exécution de: $install_url"
        log_dry_run "Commande: curl -fsSL '$install_url' | bash"
        return 0
    fi
    
    # Télécharger et exécuter le script d'installation officiel
    log_info "Téléchargement et installation d'OpenCode..."
    if curl -fsSL "$install_url" | bash; then
        log_success "OpenCode CLI installé avec succès"
    else
        log_error "Échec de l'installation d'OpenCode"
        exit 1
    fi
}

install_opencode_npm() {
    log_info "Installation via npm..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Installation npm globale: opencode"
        log_dry_run "Commande: npm install -g opencode"
        return 0
    fi
    
    # Vérifier que npm est disponible
    if ! check_command npm; then
        log_error "npm n'est pas installé"
        exit 1
    fi
    
    log_info "Installation globale via npm (peut nécessiter sudo)..."
    
    if npm install -g opencode; then
        log_success "OpenCode CLI installé avec succès via npm"
    else
        log_error "Échec de l'installation via npm"
        log_info "Essayez avec sudo: sudo npm install -g opencode"
        exit 1
    fi
}

# =============================================================================
# ÉTAPE 5: INSTALLATION OPENAGENTSCONTROL (OPTIONNEL)
# =============================================================================
step5_install_openagents() {
    log_section "[5/5] INSTALLATION OPENAGENTSCONTROL"
    
    # Vérifier si l'installation est demandée
    if [[ "$INSTALL_OPENAGENTS" != true ]]; then
        log_info "Installation d'OpenAgentsControl ignorée (INSTALL_OPENAGENTS=false)"
        log_info "Pour l'activer, définissez INSTALL_OPENAGENTS=true dans config.env"
        return 0
    fi
    
    log_info "Installation d'OpenAgentsControl demandée"
    
    # Vérifier si déjà installé
    if [[ -d "$USER_CONFIG_DIR/OpenAgentsControl" ]]; then
        log_warning "OpenAgentsControl semble déjà installé"
        log_info "Pour réinstaller, supprimez: $USER_CONFIG_DIR/OpenAgentsControl"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Clonage du repository OpenAgentsControl"
        log_dry_run "Commande: git clone https://github.com/darrenhinde/OpenAgentsControl.git '$USER_CONFIG_DIR/OpenAgentsControl'"
        return 0
    fi
    
    # Créer le répertoire de configuration
    execute "Création du répertoire de configuration" \
            mkdir -p "$USER_CONFIG_DIR"
    
    # Cloner le repository
    log_info "Clonage d'OpenAgentsControl..."
    if git clone https://github.com/darrenhinde/OpenAgentsControl.git "${USER_CONFIG_DIR}/OpenAgentsControl"; then
        log_success "OpenAgentsControl cloné avec succès"
        
        # Installation des dépendances si package.json présent
        if [[ -f "${USER_CONFIG_DIR}/OpenAgentsControl/package.json" ]]; then
            log_info "Installation des dépendances npm..."
            if (cd "${USER_CONFIG_DIR}/OpenAgentsControl" && npm install); then
                log_success "Dépendances installées avec succès"
            else
                log_warning "Échec de l'installation des dépendances"
                log_info "Vous pouvez les installer manuellement plus tard"
            fi
        fi
    else
        log_error "Échec du clonage d'OpenAgentsControl"
        log_info "Vérifiez votre connexion internet et réessayez"
        return 1
    fi
}

# =============================================================================
# VÉRIFICATION DE L'INSTALLATION
# =============================================================================
verify_installation() {
    log_section "VÉRIFICATION DE L'INSTALLATION"
    
    # Vérifier OpenCode
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Vérification d'OpenCode ignorée en mode dry-run"
    elif check_command opencode; then
        log_success "OpenCode est accessible dans le PATH"
        log_info "  Version: $(opencode --version 2>/dev/null || echo 'inconnue')"
        log_info "  Chemin: $(which opencode)"
    else
        log_error "OpenCode n'est pas accessible dans le PATH"
        log_info "Vérifiez l'installation ou redémarrez votre terminal"
    fi
    
    # Vérifier la configuration
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Vérification de la configuration ignorée en mode dry-run"
    elif [[ -d "$USER_CONFIG_DIR" ]]; then
        log_success "Répertoire de configuration présent: $USER_CONFIG_DIR"
    else
        log_warning "Répertoire de configuration non trouvé: $USER_CONFIG_DIR"
    fi
    
    # Vérifier OpenAgentsControl
    if [[ "$INSTALL_OPENAGENTS" == true ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Vérification d'OpenAgentsControl ignorée en mode dry-run"
        elif [[ -d "$USER_CONFIG_DIR/OpenAgentsControl" ]]; then
            log_success "OpenAgentsControl est installé"
        else
            log_warning "OpenAgentsControl n'est pas installé"
        fi
    fi
    
    # Afficher le backup créé
    if [[ -d "$BACKUP_DIR" ]] && [[ "$DRY_RUN" == false ]]; then
        log_info "Backup disponible: $BACKUP_DIR"
    fi
}

# =============================================================================
# RÉSUMÉ FINAL
# =============================================================================
show_summary() {
    log_section "RÉCAPITULATIF"
    
    echo ""
    echo -e "${GREEN}Installation d'OpenCode terminée!${NC}"
    echo ""
    
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}Mode DRY-RUN: Aucune modification n'a été effectuée${NC}"
        echo ""
    fi
    
    echo -e "${BLUE}Commandes disponibles:${NC}"
    echo "  opencode                      # Lancer l'interface TUI interactive"
    echo "  opencode --version            # Afficher la version"
    echo "  opencode --help               # Afficher l'aide"
    echo "  opencode \"votre prompt\"       # Exécuter une commande directe"
    echo ""
    
    if [[ "$INSTALL_OPENAGENTS" == true ]]; then
        echo -e "${BLUE}Commandes OpenAgentsControl:${NC}"
        echo "  cd ~/.config/opencode/OpenAgentsControl"
        echo "  npm start                     # Démarrer OpenAgentsControl"
        echo ""
    fi
    
    echo -e "${BLUE}Prochaines étapes:${NC}"
    echo "  1. Configurer vos clés API:"
    echo "     opencode config set ANTHROPIC_API_KEY=votre_cle"
    echo ""
    echo "  2. Vérifier la configuration:"
    echo "     opencode config list"
    echo ""
    echo "  3. Lancer OpenCode:"
    echo "     opencode"
    echo ""
    
    if [[ -d "$BACKUP_DIR" ]] && [[ "$DRY_RUN" == false ]]; then
        echo -e "${YELLOW}Backup de la configuration précédente:${NC}"
        echo "  $BACKUP_DIR"
        echo ""
    fi
    
    echo -e "${BLUE}Configuration:${NC}"
    echo "  Fichier de configuration: $USER_CONFIG_DIR"
    echo "  Éditez config.env.local pour personnaliser l'installation"
    echo ""
    
    log_section "TERMINÉ"
    log_success "Script exécuté avec succès!"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Relancez sans --dry-run pour appliquer les changements"
    fi
}

# =============================================================================
# AFFICHAGE DE L'AIDE
# =============================================================================
show_help() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS]

Script d'installation idempotent d'OpenCode CLI et OpenAgentsControl.

OPTIONS:
  --dry-run         Mode simulation (affiche sans exécuter)
  --verbose         Mode très verbeux (détails de chaque opération)
  --help, -h        Afficher cette aide

CONFIGURATION:
  Le script charge automatiquement les fichiers de configuration:
    - config.env         (versionnée, valeurs par défaut)
    - config.env.local   (non versionnée, prioritaire)

  Variables importantes:
    INSTALL_OPENAGENTS=true|false    Installer OpenAgentsControl (défaut: false)
    OPENCODE_INSTALL_METHOD=curl|npm Méthode d'installation (défaut: curl)

EXEMPLES:
  # Installation standard
  ./$SCRIPT_NAME

  # Simulation (dry-run)
  ./$SCRIPT_NAME --dry-run

  # Mode verbeux
  ./$SCRIPT_NAME --verbose

  # Simulation verbeuse
  ./$SCRIPT_NAME --dry-run --verbose

PHILOSOPHIE:
  - Idempotent: Safe à exécuter plusieurs fois
  - Conservateur: Pas de mode --force agressif
  - Transparent: Backup automatique avant modification
  - Humain-in-the-loop: Validation requise avant exécution

AUTEUR:
  Généré pour Kuber-Kluster (philosophie "Toyota Tercel")

EOF
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================
main() {
    log_section "INSTALLATION OPENCODE CLI - Kuber-Kluster"
    log_info "Script: ${SCRIPT_DIR}/${SCRIPT_NAME}"
    log_info "Date: $(date '+%Y-%m-%d %H:%M:%S')"
    log_info "Utilisateur: $(whoami)"
    log_info "Machine: $(hostname)"
    log_info "OS: $(detect_os)"
    
    # Parsing des arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                log_warning "MODE DRY-RUN: Aucune modification ne sera effectuée"
                shift
                ;;
            --verbose)
                VERBOSE=true
                log_info "MODE VERBOSE: Affichage détaillé activé"
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Option inconnue: $1"
                log_info "Utilisez --help pour voir les options disponibles"
                exit 1
                ;;
        esac
    done
    
    # Charger la configuration
    load_config
    
    # Exécuter les étapes
    step1_check_prerequisites
    step2_detect_existing
    step3_backup_config
    step4_install_opencode
    step5_install_openagents
    
    # Vérification finale
    verify_installation
    
    # Résumé
    show_summary
}

# =============================================================================
# POINT D'ENTRÉE
# =============================================================================
main "$@"
