# King of Tour — prototype 0.1

Prototype 2D de tower defense hors ligne sous Godot 4.4.1.

## Fonctionnalités actuelles
- 50 héros affichés dans le sélecteur, tous marqués disponibles.
- Première carte de test et chemin d'ennemis.
- Vagues, pièces, vies et construction de tours.
- Sauvegarde locale simple.
- Projet prévu pour export Android via GitHub Actions.

## Limites du prototype
Ce n'est pas encore un jeu complet : les héros sont pour l'instant des entrées de données et un indicateur visuel, les tours utilisent une logique de tir simplifiée, et les 100 missions, animations, sons, menus avancés et équilibrage restent à développer.

## Compilation
Le workflow `.github/workflows/android.yml` tente d'exporter l'APK avec Godot 4.4.1 et les modèles d'exportation correspondants. Consultez l'onglet Actions du dépôt GitHub et téléchargez l'artefact `King-of-Tour-debug-apk` si le workflow réussit.

## Contrôles
- « Lancer la vague » démarre une vague.
- « Construire (100) » ajoute une tour.
- Le sélecteur permet de choisir l'un des 50 héros.
- « Sauvegarder » enregistre les pièces, les vies et le numéro de vague localement.

## Licence
Le code de départ peut être modifié librement. Ajoutez une licence explicite avant de redistribuer le projet.
