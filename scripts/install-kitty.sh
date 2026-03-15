#!/bin/bash
# =============================================================================
# Script d'installation de Kitty - Mode "Toyota Tercel"
# =============================================================================
# Description: Installe et configure Kitty depuis les repos Debian
#              avec approche idempotente, verbeuse et backup automatique.
#
# Philosophie:
#   - Idempotent: Safe à exécuter plusieurs fois
#   - Verbeux: Tu vois tout ce qui se passe
#   - Backup: Toujours sauvegarder avant de modifier
#   - Symlink: Single source of truth depuis le repo
#
# Usage:
#   ./install-kitty.sh              # Mode standard
#   ./install-kitty.sh --dry-run    # Simulation (affiche sans exécuter)
#   ./install-kitty.sh --force      # Force réinstallation même si présent
#
# Auteur: Généré pour infra-startup
# Date: 2026-02-13
# =============================================================================

set -euo pipefail

# =============================================================================
# CONFIGURATION
# =============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_KITTY_DIR="${SCRIPT_DIR}"
USER_KITTY_DIR="${HOME}/.config/kitty"
BACKUP_DIR="${HOME}/.config/kitty.backup.$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
FORCE=false

# Couleurs pour la sortie verbeuse
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =============================================================================
# FONCTIONS D'AFFICHAGE
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

# =============================================================================
# FONCTIONS UTILITAIRES
# =============================================================================
execute() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] $1"
        log_info "[DRY-RUN] Commande: $2"
    else
        log_info "$1"
        eval "$2"
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
# FONCTIONS DE DÉTECTION
# =============================================================================
detect_shell() {
    local current_shell
    current_shell=$(basename "$SHELL")
    log_info "Shell détecté: $current_shell"
    
    if check_command zsh; then
        log_info "✓ zsh est installé"
        if [[ -f "${HOME}/.p10k.zsh" ]]; then
            log_info "✓ powerlevel10k détecté (.p10k.zsh présent)"
        else
            log_warning "powerlevel10k non détecté"
        fi
    else
        log_warning "zsh non installé"
    fi
}

detect_tmux() {
    if check_command tmux; then
        log_info "✓ tmux est installé ($(tmux -V))"
        if [[ -f "${HOME}/.tmux.conf" ]]; then
            log_info "✓ Configuration tmux détectée (.tmux.conf présent)"
        fi
    else
        log_warning "tmux non installé"
    fi
}

detect_kitty() {
    if check_command kitty; then
        log_info "✓ Kitty déjà installé ($(kitty --version))"
        return 0
    else
        log_info "Kitty non installé"
        return 1
    fi
}

# =============================================================================
# FONCTIONS DE BACKUP
# =============================================================================
backup_existing_config() {
    if [[ -d "$USER_KITTY_DIR" ]]; then
        log_warning "Configuration Kitty existante détectée"
        execute "Backup de la configuration existante vers ${BACKUP_DIR}" \
                "mkdir -p '${BACKUP_DIR}' && cp -r '${USER_KITTY_DIR}/'* '${BACKUP_DIR}/' 2>/dev/null || true"
        log_success "Backup créé: ${BACKUP_DIR}"
        
        # Suppression de l'ancien symlink ou dossier
        execute "Suppression de l'ancienne configuration" \
                "rm -rf '${USER_KITTY_DIR}'"
    fi
}

# =============================================================================
# FONCTIONS D'INSTALLATION
# =============================================================================
install_kitty_debian() {
    log_section "INSTALLATION DE KITTY"
    
    local os
    os=$(detect_os)
    log_info "OS détecté: $os"
    
    if [[ "$os" != "debian" ]] && [[ "$os" != "ubuntu" ]]; then
        log_warning "OS non Debian ($os). Tentative d'installation quand même..."
    fi
    
    if detect_kitty && [[ "$FORCE" != true ]]; then
        log_success "Kitty est déjà installé. Utilise --force pour réinstaller."
        return 0
    fi
    
    # Mise à jour des repos
    execute "Mise à jour des dépôts" \
            "sudo apt-get update"
    
    # Installation de Kitty
    execute "Installation de Kitty depuis les repos Debian" \
            "sudo apt-get install -y kitty kitty-terminfo"
    
    log_success "Kitty installé avec succès"
}

install_fonts() {
    log_section "VÉRIFICATION DES POLICES"
    
    # Vérifier si MesloLGS NF est installée
    if fc-list | grep -qi "meslolgs"; then
        log_success "Police MesloLGS NF déjà installée"
    else
        log_warning "Police MesloLGS NF non détectée"
        log_info "Installation recommandée pour powerlevel10k:"
        log_info "  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k"
        log_info "  ~/.powerlevel10k/fonts/install.sh"
    fi
}

# =============================================================================
# FONCTIONS DE CONFIGURATION
# =============================================================================
configure_kitty() {
    log_section "CONFIGURATION DE KITTY"
    
    # Créer le répertoire parent si nécessaire
    execute "Création du répertoire .config" \
            "mkdir -p '${HOME}/.config'"
    
    # Backup si nécessaire
    backup_existing_config
    
    # Créer le symlink
    execute "Création du symlink vers le repo" \
            "ln -sf '${REPO_KITTY_DIR}' '${USER_KITTY_DIR}'"
    
    log_success "Configuration liée: ${USER_KITTY_DIR} -> ${REPO_KITTY_DIR}"
    
    # Vérifier que le symlink fonctionne (sauf en dry-run)
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] Vérification du symlink ignorée"
    elif [[ -L "$USER_KITTY_DIR" ]] && [[ -e "$USER_KITTY_DIR" ]]; then
        log_success "Symlink valide et fonctionnel"
    else
        log_error "Problème avec le symlink"
        return 1
    fi
}

# =============================================================================
# FONCTIONS DE VÉRIFICATION
# =============================================================================
verify_installation() {
    log_section "VÉRIFICATION DE L'INSTALLATION"
    
    # Vérifier que kitty est accessible (sauf en dry-run)
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] Vérification de Kitty ignorée"
    elif check_command kitty; then
        log_success "Kitty accessible dans le PATH"
        log_info "Version: $(kitty --version)"
    else
        log_error "Kitty non accessible dans le PATH"
        return 1
    fi
    
    # Vérifier la configuration (sauf en dry-run)
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] Vérification de la configuration ignorée"
    elif [[ -L "$USER_KITTY_DIR" ]]; then
        log_success "Symlink de configuration présent"
        log_info "Pointe vers: $(readlink -f "$USER_KITTY_DIR")"
    else
        log_error "Symlink de configuration manquant"
        return 1
    fi
    
    # Vérifier les fichiers de config (sauf en dry-run)
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] Vérification de kitty.conf ignorée"
    elif [[ -f "${USER_KITTY_DIR}/kitty.conf" ]]; then
        log_success "Fichier kitty.conf présent"
    else
        log_error "Fichier kitty.conf manquant"
        return 1
    fi
    
    # Vérifier le thème (sauf en dry-run)
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] Vérification du thème ignorée"
    elif [[ -f "${USER_KITTY_DIR}/themes/dracula.conf" ]]; then
        log_success "Thème Dracula présent"
    else
        log_warning "Thème Dracula manquant"
    fi
}

# =============================================================================
# FONCTIONS D'AFFICHAGE RÉCAPITULATIF
# =============================================================================
show_summary() {
    log_section "RÉCAPITULATIF"
    
    echo ""
    echo -e "${GREEN}Installation de Kitty terminée avec succès!${NC}"
    echo ""
    echo -e "${BLUE}Prochaines étapes:${NC}"
    echo "  1. Lance Kitty:           kitty"
    echo "  2. Test la config:        kitty + list-fonts | grep Meslo"
    echo "  3. Vérifie le thème:      Regarde les couleurs Dracula"
    echo ""
    echo -e "${BLUE}Raccourcis clavier importants:${NC}"
    echo "  Ctrl+Shift+t     Nouvel onglet"
    echo "  Ctrl+Shift+w     Fermer onglet"
    echo "  Ctrl+Shift+c     Copier"
    echo "  Ctrl+Shift+v     Coller"
    echo "  Ctrl+Shift++     Zoom +"
    echo "  Ctrl+Shift+-     Zoom -"
    echo ""
    echo -e "${BLUE}Intégration avec ton workflow:${NC}"
    echo "  - Modifie la config dans VS Code: 05-DESKTOPS/kitty/kitty.conf"
    echo "  - Kitty recharge auto ou: Ctrl+Shift+F5"
    echo "  - Pour layout OpenCode: Place VS Code à gauche, Kitty à droite"
    echo ""
    
    if [[ -d "$BACKUP_DIR" ]]; then
        echo -e "${YELLOW}Backup de l'ancienne config: ${BACKUP_DIR}${NC}"
    fi
    
    echo ""
    log_info "Pour utiliser Kitty comme terminal par défaut dans KDE:"
    log_info "  Paramètres système → Applications par défaut → Terminal = kitty"
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================
main() {
    log_section "INSTALLATION DE KITTY - infra-startup"
    log_info "Script: ${SCRIPT_DIR}/$(basename "$0")"
    log_info "Date: $(date)"
    log_info "Utilisateur: $(whoami)"
    log_info "Machine: $(hostname)"
    
    # Parsing des arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                log_warning "MODE DRY-RUN: Aucune modification ne sera effectuée"
                shift
                ;;
            --force)
                FORCE=true
                log_warning "MODE FORCE: Réinstallation forcée"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [--dry-run] [--force] [--help]"
                echo ""
                echo "Options:"
                echo "  --dry-run    Simulation, aucune modification"
                echo "  --force      Forcer la réinstallation"
                echo "  --help       Afficher cette aide"
                exit 0
                ;;
            *)
                log_error "Option inconnue: $1"
                exit 1
                ;;
        esac
    done
    
    # Détection de l'environnement
    log_section "DÉTECTION DE L'ENVIRONNEMENT"
    detect_shell
    detect_tmux
    
    # Installation
    install_kitty_debian
    install_fonts
    configure_kitty
    
    # Vérification
    verify_installation
    
    # Récapitulatif
    show_summary
    
    log_section "TERMINÉ"
    log_success "Script exécuté avec succès!"
}

# =============================================================================
# POINT D'ENTRÉE
# =============================================================================
main "$@"
