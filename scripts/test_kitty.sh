#!/bin/bash
# ============================================
# Script de test pour Kitty Terminal
# Vérifie: Thème Dracula, Police MesloLGS NF, Icônes Nerd Fonts
# ============================================

echo -e "\033[0m"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║           🧪 TEST DE CONFIGURATION KITTY                         ║"
echo "║           Thème: Dracula | Police: MesloLGS NF                   ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# ============================================
# SECTION 1: TEST DES COULEURS (Thème Dracula)
# ============================================
echo "📋 SECTION 1: PALETTE DE COULEURS DRACULA"
echo "────────────────────────────────────────────────────────────────────"
echo ""
echo "Couleurs de base:"
echo -e "  \033[38;5;231m██\033[0m Foreground (#f8f8f2)   \033[38;5;59m██\033[0m Background (#282a36)"
echo ""
echo "Couleurs ANSI (16 couleurs):"
echo -e "  \033[30m█\033[0m\033[38;5;212mc0  Noir         \033[0m \033[31m█\033[0m\033[38;5;203mc1  Rouge        \033[0m \033[32m█\033[0m\033[38;5;84mc2  Vert         \033[0m \033[33m█\033[0m\033[38;5;228mc3  Jaune"
echo -e "  \033[34m█\033[0m\033[38;5;141mc4  Bleu         \033[0m \033[35m█\033[0m\033[38;5;212mc5  Magenta      \033[0m \033[36m█\033[0m\033[38;5;117mc6  Cyan         \033[0m \033[37m█\033[0m\033[38;5;231mc7  Blanc"
echo -e "  \033[90m█\033[0m\033[38;5;61mc8  Gris         \033[0m \033[91m█\033[0m\033[38;5;210mc9  Rouge clair  \033[0m \033[92m█\033[0m\033[38;5;86mc10 Vert clair   \033[0m \033[93m█\033[0m\033[38;5;229mc11 Jaune clair"
echo -e "  \033[94m█\033[0m\033[38;5;183mc12 Bleu clair   \033[0m \033[95m█\033[0m\033[38;5;218mc13 Magenta clair\033[0m \033[96m█\033[0m\033[38;5;159mc14 Cyan clair   \033[0m \033[97m█\033[0m\033[38;5;15mc15 Blanc brillant"
echo ""
echo "Couleurs spécifiques Dracula:"
echo -e "  \033[38;5;141m●\033[0m Purple (#bd93f9)    \033[38;5;117m●\033[0m Cyan (#8be9fd)    \033[38;5;84m●\033[0m Green (#50fa7b)"
echo -e "  \033[38;5;203m●\033[0m Red (#ff5555)       \033[38;5;228m●\033[0m Yellow (#f1fa8c)   \033[38;5;212m●\033[0m Pink (#ff79c6)"
echo ""

# ============================================
# SECTION 2: TEST TRUECOLOR (24-bit)
# ============================================
echo ""
echo "📋 SECTION 2: SUPPORT TRUECOLOR (24-bit)"
echo "────────────────────────────────────────────────────────────────────"
echo ""
echo "Dégradé de couleurs lisses (si tu vois des bandes, truecolor fonctionne):"
echo -e "\033[48;2;255;0;0m  \033[48;2;255;42;0m  \033[48;2;255;85;0m  \033[48;2;255;127;0m  \033[48;2;255;170;0m  \033[48;2;255;212;0m  \033[48;2;255;255;0m  \033[48;2;212;255;0m  \033[48;2;170;255;0m  \033[48;2;127;255;0m  \033[48;2;85;255;0m  \033[48;2;42;255;0m  \033[48;2;0;255;0m  \033[48;2;0;255;42m  \033[48;2;0;255;85m  \033[48;2;0;255;127m  \033[48;2;0;255;170m  \033[48;2;0;255;212m  \033[48;2;0;255;255m  \033[48;2;0;212;255m  \033[48;2;0;170;255m  \033[48;2;0;127;255m  \033[48;2;0;85;255m  \033[48;2;0;42;255m  \033[48;2;0;0;255m  \033[0m"
echo ""
echo "Dégradé Dracula (Purple → Cyan):"
echo -e "\033[48;2;189;147;249m  \033[48;2;168;154;248m  \033[48;2;147;161;247m  \033[48;2;126;168;246m  \033[48;2;105;175;245m  \033[48;2;84;182;244m  \033[48;2;63;189;243m  \033[48;2;42;196;242m  \033[48;2;21;203;241m  \033[48;2;0;210;240m  \033[48;2;20;213;241m  \033[48;2;40;216;242m  \033[48;2;60;219;243m  \033[48;2;80;222;244m  \033[48;2;100;225;245m  \033[48;2;120;228;246m  \033[48;2;140;231;247m  \033[48;2;160;234;248m  \033[48;2;180;237;249m  \033[48;2;200;240;250m  \033[48;2;220;243;251m  \033[48;2;240;246;252m  \033[48;2;255;250;253m  \033[48;2;255;255;255m  \033[0m"
echo ""

# ============================================
# SECTION 3: TEST DES ICÔNES NERD FONTS
# ============================================
echo ""
echo "📋 SECTION 3: ICÔNES NERD FONTS (MesloLGS NF)"
echo "────────────────────────────────────────────────────────────────────"
echo ""
echo "Icônes de dossiers:"
echo "  󰉋 dossier    󰝰 ouvert    󰉖 nouveau    󰷏 workspace"
echo ""
echo "Icônes de fichiers:"
echo "  󰈔 document   󰌠 code      󰈙 texte     󰈛 config"
echo ""
echo "Icônes de développement:"
echo "  󰘳 git        󰣚 docker    󰌝 node      󰛦 python"
echo "  󰌆 react      󰛈 angular   󰙢 vue       󰌨 database"
echo ""
echo "Icônes système:"
echo "  󰌽 linux      󰌂 debian    󰌆 terminal  󰒓 settings"
echo "  󰌌 cloud      󰍛 server    󰌘 network   󰒓 security"
echo ""
echo "Powerline symbols:"
echo "                 "
echo "                 "
echo ""
echo "Icônes Powerlevel10k courantes:"
echo "  󰘬 git-branch    ✓ check       ✗ cross       ⚠ warning"
echo "  󰌽 os-icon       󰃭 home        󰉋 folder      󱞜 arrow"
echo ""

# ============================================
# SECTION 4: TEST DES LIGATURES
# ============================================
echo ""
echo "📋 SECTION 4: LIGATURES DE POLICE"
echo "────────────────────────────────────────────────────────────────────"
echo ""
echo "Opérateurs de comparaison:"
echo "    !=    ==    ===    >=    <=    =>"
echo ""
echo "Flèches et assignations:"
echo "    ->    <-    =>    <--    -->    <->"
echo ""
echo "Opérateurs logiques:"
echo "    &&    ||    !!    ??    ::"
echo ""
echo "Mathématiques:"
echo "    >=    <=    /=    :=    ::=    ++    --"
echo ""
echo "Commentaires et hashtags:"
echo "    /*    */    <!--    -->    #{    #["
echo ""
echo "Divers:"
echo "    |>    <|    ::    ~~    ##    ###    ####"
echo ""

# ============================================
# SECTION 5: TEST DE LA CONFIGURATION
# ============================================
echo ""
echo "📋 SECTION 5: INFORMATIONS DE CONFIGURATION"
echo "────────────────────────────────────────────────────────────────────"
echo ""
echo "Kitty version:"
kitty --version 2>/dev/null || echo "  ❌ Kitty non trouvé dans le PATH"
echo ""
echo "Fichier de configuration:"
if [ -f ~/.config/kitty/kitty.conf ]; then
    echo "  ✓ ~/.config/kitty/kitty.conf trouvé"
    echo "    Police configurée:"
    grep "font_family" ~/.config/kitty/kitty.conf | head -1 || echo "    (non détectée)"
else
    echo "  ❌ ~/.config/kitty/kitty.conf non trouvé"
fi
echo ""
echo "Thème Dracula:"
if [ -f ~/.config/kitty/themes/dracula.conf ]; then
    echo "  ✓ Thème Dracula trouvé"
else
    echo "  ❌ Thème Dracula non trouvé"
fi
echo ""

# ============================================
# SECTION 6: RÉSUMÉ
# ============================================
echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "                        📊 RÉSUMÉ DES TESTS"
echo "════════════════════════════════════════════════════════════════════"
echo ""
echo "✓ TrueColor (24-bit) : Vérifie le dégradé lisse ci-dessus"
echo "✓ Thème Dracula      : Les couleurs correspondent-elles à la palette?"
echo "✓ Icônes Nerd Fonts  : Les icônes s'affichent-elles correctement?"
echo "✓ Ligatures          : Les flèches se combinent-elles?"
echo "✓ Police MesloLGS NF : Vérifie dans les infos ci-dessus"
echo ""
echo "💡 Si tu vois des carrés ou des points d'interrogation à la place"
echo "   des icônes, la police Nerd Font n'est pas correctement installée."
echo ""
echo "════════════════════════════════════════════════════════════════════"
echo ""
