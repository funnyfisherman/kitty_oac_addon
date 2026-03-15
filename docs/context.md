
🎯 Récapitulatif du profil 

Philosophie	Toyota Tercel > Lada. Pas de black box, pas de dette technique, pas de machine à gaz
Contexte	Infrastructure Linux privée multi-nodes, NAS, flotte de laptops, projets professionels.

Personnalités	1) Réparateur rapide (terminal) / 2) Architecte (IDE) / 3) Tout entre les deux

Stack actuel	Debian 13 Trixie, KDE Plasma, bash/zsh+power10k, tmux installé, VS Code

Matériel	Dell Inspiron 15 (Iris Xe) + ThinkPad T490 i7 (à standardiser)

Écrans	Dell 27" (principal) + HP Compaq LA2205WG (à remplacer) + laptop
✅ Décisions déjà prises
Élément	Choix	Justification
Terminal	Kitty	Puissant, configurable, bien documenté, truecolor, GPU-acceleré
Source d'installation	Debian repos	Philosophie "Toyota Tercel" - pas de binary externe, intégration native, mises à jour avec le système
Risque 6 mois de retard	Accepté	OpenCode fonctionnera parfaitement - truecolor est standardisé depuis longtemps
tmux	Les deux	Apprendre avec ET sans, flexibilité maximale
Layout OpenCode	Code à gauche, terminal à droite	QA/approbation visuelle




4. Comportement du script lui-même
Aspect	Option A	Option B
Idempotence	Vérifier "déjà installé ?" → skip	Toujours réinstaller/forcer
Backup	Sauvegarder config existante avant écrasement	Écraser sans pitié
Verbosité	--verbose flag possible	Toujours verbeux
Debug	set -x mode optionnel	Intégré dans la verbosité
5. Nom et structure du script



Proposition de structure :

infra-startup/
├── scripts/
│   ├── desktop/
│   │   ├── install-kitty.sh          # ← LE SCRIPT
│   │   ├── configure-kitty.sh        # ← Config post-install
│   │   └── kitty/                    # ← Assets
│   │       ├── kitty.conf.template
│   │       ├── themes/
│  

