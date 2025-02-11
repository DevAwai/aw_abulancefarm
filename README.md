# 🚑 Mission Médicale pour FiveM (QB-Core)

Bienvenue dans le projet **Mission Médicale** pour FiveM, un script complet pour QB-Core qui permet de gérer une mission où les joueurs incarnent des médecins et doivent secourir des PNJ blessés en ville. Ce script propose un système de récompenses et une interaction avec des véhicules d'ambulance.

## 🎯 Fonctionnalités

- 🚗 **Véhicules d'ambulance** : Vous pouvez créer des véhicules d'ambulance pour aider les PNJ blessés.
- 🧑‍⚕️ **Secourir des PNJ** : Les joueurs doivent secourir des PNJ dans différents scénarios (accidents, bagarres, chutes, etc.).
- 💰 **Récompenses financières** : Gagnez de l'argent pour chaque PNJ soigné (10 $ par personne).
- 📍 **Blips et Waypoints** : Des blips et waypoints sont utilisés pour guider les joueurs vers les endroits où ils doivent intervenir.

## 📜 Installation

1. **Téléchargez le projet** ou clonez-le depuis GitHub :
    ```bash
    git clone https://github.com/DevAwai/aw_abulancefarm.git
    ```
2. **Ajoutez le script à votre serveur FiveM** :
    - Placez le dossier `aw_ambulance` dans votre répertoire `resources`.
    - Ajoutez `ensure mission_medicale` dans votre `server.cfg`.
  
3. **Dépendances** :
    - Ce script fonctionne avec **QB-Core**. Assurez-vous d'avoir installé QB-Core sur votre serveur.

## ⚙️ Configuration

Le script est conçu pour être simple à configurer. Vous pouvez personnaliser plusieurs éléments dans les fichiers **client.lua** et **server.lua**.

### Modifications possibles :

- **Position du médecin** : Vous pouvez changer la position du PNJ médecin en modifiant `medicMissionPedCoords` dans le fichier **client.lua**.
- **Scénarios de secours** : Les différents scénarios (accidents, bagarres, etc.) sont définis dans la variable `scenarios`. Modifiez les coordonnées pour ajouter ou supprimer des lieux.
- **Récompenses** : Le montant de la récompense peut être ajusté dans la fonction `rewardPlayer` du fichier **server.lua**.

## 📚 Commandes

### Commandes du script

- **[E] Interagir avec le médecin** : Permet de commencer ou de terminer une mission de secours.
- **[E] Ranger le véhicule** : Lorsque le joueur gare le véhicule d'ambulance près du point de rangement, l'argent est ajouté à son inventaire.


## 📢 Acknowledgements

- Ce script utilise **QB-Core**, un framework populaire pour les serveurs FiveM.
- Merci à la communauté FiveM pour le soutien et l'inspiration.

## 📣 Contact

Si vous avez des questions, des suggestions ou des bugs à signaler, contactez-moi à :  
**Discord** : Awai#9999

---

Profitez bien de votre mission médicale et soignez bien vos PNJ ! 🚑💉💰


