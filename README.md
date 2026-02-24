








## 👥 Contributions de chaque membre

Le projet a été réalisé en collaboration par 4 membres.
Les contributions ci-dessous décrivent les responsabilités techniques effectivement assumées par chacun, ainsi que l’évolution du projet entre les premières implémentations et la version finale.

---

### BANKOLE Christopher  (AZERT-TY) — Architecture, Backend, Intégration et Refactorisation

Responsabilités principales

Azert-ty a pris en charge :

La mise en place de l’architecture backend avec Flask

La conception et l’implémentation des routes API REST

L’intégration Flutter ↔ API

La refactorisation des premières versions des pages

La stabilisation technique globale du projet

L’implémentation du système de maintenance

La mise en place du monitoring temps réel

Monitoring temps réel (HomePage)

La première version de la page Home affichait des données statiques.

Les modifications apportées :

Implémentation d’appels API périodiques

Mise en place d’un rafraîchissement automatique

Ajout de filtres (All / Active / Warning / Fault)

Ajout de la vérification mounted avant setState()

La page est ainsi passée d’un affichage fixe à une supervision dynamique actualisée automatiquement.

Page History

Symelle a développé la première version de la page History.

Azert-ty a ensuite modifié et amélioré cette implémentation.

Les ajustements effectués :

Modification de la structure existante

Amélioration du modèle de données (TelemetryEvent)

Refactorisation du controller

Reconnexion à l’API d’archives

Réorganisation de l’affichage sous forme de “Time Machine”

Système de Maintenance

Fonctionnalité transversale intégrée au projet :

Ajout d’une route backend pour activer/désactiver la maintenance

Implémentation de la gestion d’état côté Flutter

Connexion du bouton toggle à l’API

Adaptation de l’affichage sur Home, Alerts et MachineDetail

Cette fonctionnalité implique :

Backend

API service

Controller

Interface utilisateur

Synchronisation client / serveur

---

### Symelle — Pages History, Navigation et Structure Frontend

Contributions principales

Symelle a :

Développé la page History

Créé le HistoryController initial

Assuré la liaison entre Home, History et Equipment

Implémenté app_bottom_bar

Mis en place la première version de api_service

Créé le modèle machine.dart

Apporté des modifications à la page Equipment

Page History

Implémentation de l’affichage des données historiques

Création de la logique du controller

Connexion des données à l’interface

Cette version a ensuite été modifiée et améliorée dans les itérations suivantes.

Navigation (AppBottomBar)

Implémentation de la barre de navigation inférieure

Gestion de la navigation entre les pages

Structuration du routing principal

La structure de navigation initiale repose sur cette implémentation.

API Service

Configuration initiale de Dio

Implémentation des premiers appels API

Structuration des méthodes de récupération des données

Des ajustements ont ensuite été effectués lors des phases d’intégration et d’optimisation.

---

### Ursule — HomePage initiale et Début Equipment

Ursule a :

Développé une première version de la HomePage

Commencé l’implémentation de la page Equipment

Ces éléments ont permis :

De définir l’organisation visuelle initiale

De structurer l’affichage de base des machines

Ces pages ont ensuite été modifiées et connectées au backend et au système de monitoring lors des phases ultérieures.

---

### Trinité — Page Alerts

Trinité a :

Développé la première version de la page Alerts

Structuré l’affichage des alertes

Lors des itérations suivantes :

Connexion de la page aux données backend

Adaptation au système de maintenance

Harmonisation avec le monitoring global

Synthèse

Le projet a évolué par étapes successives :

Mise en place initiale des pages et de la navigation

Développement du backend et des API

Intégration frontend ↔ backend

Refactorisations et améliorations structurelles

Stabilisation de la version finale

---
---
Chaque membre a contribué à des parties identifiables du projet.
Certaines fonctionnalités ont évolué au fil des itérations, avec des phases d’implémentation initiale puis de modification ou d’amélioration technique.

