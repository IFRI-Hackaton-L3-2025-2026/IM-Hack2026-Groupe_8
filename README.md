
# IM-Hack2026-Groupe_8

##  Membres de l’équipe et leur Identifiants github

## 👥 Membres de l’équipe

| Nom complet | E-mail | Identifiant GitHub |
|------------|--------|-------------------|
| AHOHOUINDO Ursule Sènan | ursulahohouindo@gmail.com | Ursulee |
| VIDEDANNON Iffa Symelle | videdannoniffasymelle@gmail.com | videdannonsymelle-lang |
| BANKOLE Nathan Christopher Adéyèmi | bankolechristopher91@gmail.com | Azert-ty |
|ADJAKOTAN Oboubé Trinité Sylvio | triniteadj1@gmail.com | Sylvio41 |










## RAPPORT TECHNIQUE
### Application de supervision industrielle

### 1. Introduction

    Le projet consiste en une application de supervision industrielle et de maintenance prédictive permettant :

    la surveillance temps réel des machines,

    la détection d’états anormaux,

    la simulation de pannes,

    l’analyse historique des données,

    la génération d’alertes visuelles.

    L’architecture repose sur une séparation claire :

    Backend : API REST en Python (Flask)

    Frontend : Application Flutter (Dart)

    Communication via HTTP (Dio)

#### 1.1  Le Choix du Mobile : L'Intelligence au Cœur de l'Usine


    Dans le cadre de l'industrie 4.0, la donnée n'a de valeur que si elle est actionnable immédiatement. En développant l'appli sur support mobile, nous avons fait le choix stratégique de la mobilité opérationnelle.

    Contrairement à un logiciel de bureau classique, notre application transforme le smartphone du technicien en un véritable terminal de diagnostic portable. Voici pourquoi ce choix est crucial pour le succès du projet :

    Réactivité sur le terrain : Le technicien n'est plus enchaîné à un poste fixe ; il accède aux graphiques de vibration ou de température directement au pied du convoyeur ou du robot.

    Ergonomie Tactile : L'interface a été pensée pour une manipulation naturelle. Le défilement et le zoom sur les "montagnes" de données se font d'un simple glissement de doigt, offrant une précision d'analyse impossible à obtenir avec une souris classique.

    Aide à la décision en temps réel : En limitant le flux à 200 points clés, nous garantissons une fluidité parfaite, permettant de repérer une anomalie en quelques secondes, même sur les réseaux industriels parfois instables.



### 2. Architecture Générale

#### 2.1 Backend – API REST en Python


    Framework utilisé : Flask

    Pourquoi Flask ?

    Léger

    Rapide à mettre en place

    Adapté au prototypage

    Parfait pour exposer une API REST claire

    Serveur de production

    Utilisation de Waitress comme serveur WSGI

    Remplacement du mode debug Flask

    Justification :
    Le serveur de développement Flask n’est pas conçu pour la production. Waitress garantit une gestion correcte des requêtes concurrentes.

#### 2.2 Frontend – Application Flutter


    Framework : Flutter 3.x

    Pourquoi Flutter ?

    Multiplateforme (Android, iOS, Web)

    Performance native

    UI fluide

    Idéal pour visualisation temps réel

    Gestion d’état : GetX

    Justification :

    Réactivité simple (.obs)

    Injection de dépendances

    Navigation simplifiée

    Moins de boilerplate que Provider ou BLoC

    Communication réseau : Dio

    Pourquoi Dio ?

    Gestion propre des erreurs

    Intercepteurs

    Support avancé HTTP

### 3. Architecture Logicielle

#### 3.1 Séparation des responsabilités


    Architecture type MVC-like :

    Backend

    Modèles implicites : machines, profils, historique

    Logique métier : simulation, calculs seuils, prédiction

    Routes API : exposition des données

    Frontend

    Models : Machine, TelemetryEvent

    Controllers : logique métier (GetX)

    Views : écrans

    Services : ApiService

    Cette séparation permet :

    Maintenabilité

    Testabilité

    Scalabilité

### 4. Conception du Backend

#### 4.1 Simulation des machines


    28 machines réparties en 4 catégories industrielles.

    Chaque type possède un profil :

    - température de base

    - facteur de vibration

    - consommation électrique

    - comportement dynamique

    Les données ne sont pas aléatoires pures.

    Il existe une logique physique simplifiée :

    Température élevée → vibration augmente

    Vibration élevée → risque de panne

    Courant anormal → warning

    Seuils critiques → "en panne"


#### 4.2 Génération des capteurs


Capteurs simulés :

- temp_mean

- temp_max

- vib_mean

- current_mean

- acoustic_energy

- rpm_mean

- oil_particle_count

- maintenance_age_days

Chaque appel API régénère des données dynamiques.

- Historique conservé :
    20 derniers points par machine.

    Pourquoi 20 ?

    Évite surcharge mémoire

    Maintient fluidité graphique

    Suffisant pour visualisation courte durée


#### 4.3 Système de prédiction


    Champ : failure_next_24h

    Logique basée sur seuils :

    temp > 85°C

    vib > 10

    courant anormal

    Ce n’est pas une IA entraînée, mais :

    Simulation cohérente

    Démonstration de concept

    Architecture prête pour intégrer un modèle ML réel


#### 4.4 Archives historiques


    Dataset CSV traité avec Pandas.

    Route : /api/archive

    Filtrage par date.

    Limitation à 200 lignes :

    Justification technique :

    Optimisation mémoire

    Réduction bande passante

    Fluidité Flutter

    Distinction importante :

    200 (Pandas head) = limite données

    HTTP 200 = succès requête

### 5. Conception du Frontend

#### 5.1 Dashboard Principal


    Fonctionnalités :

    Liste machines

    Statuts temps réel

    Filtres : All / Active / Warning / Fault

    Compteurs globaux

    Refresh automatique toutes les 5 secondes

    Objectif UX :

    Permettre à un opérateur de voir immédiatement :

    combien de machines sont critiques

    quelles machines nécessitent action


#### 5.2 Page Détail Machine



    Affiche :

    Jauges radiales (Syncfusion)

    Graphiques linéaires (fl_chart)

    Statut dynamique

    Bouton toggle maintenance

    Les jauges :

    Température

    Vibrations

    Courant

    Les graphiques :

    20 derniers points

    Mise à jour automatique

    But : diagnostic rapide et visuel.


#### 5.3 Time Machine (Analyse Historique)



Page la plus technique.

Fonctionnalités :

Sélecteur date

Sélecteur heure

Sélecteur machine

Sélecteur métrique (temp, vib, rpm…)

Traitement :

Chargement async CSV

Calcul KPI :

Moyenne

Pic

Minimum

Graphique :

Axe Y adaptatif (minY / maxY dynamique)

Axe X basé sur timestamp converti en double

Ce module permet :

Analyse rétrospective

Identification patterns

Support décision maintenance


#### 5.4 Module Alertes



    Logique :

    Filtrage automatique machines en panne

    Classification : critical / warning / info

    Tri par gravité et temps

    Animation visuelle :

    Icône pulsante via AnimationController

    Mise à jour globale grâce au state partagé

    Objectif :

    Réactivité immédiate.


#### 6. Sécurité et Performance


    CORS activé

    Limitation historique 20 points

    Limitation CSV à 200 lignes

    Timers contrôlés

    Gestion erreurs réseau via try/catch

    Snackbars pour feedback utilisateur


#### 7. Expérience Utilisateur (UX)


    Thème sombre industriel :

    Fond noir/gris profond

    Accent cyan

    Rouge pour critique

    Orange pour warning

    Pourquoi sombre ?

    Environnement industriel

    Réduction fatigue oculaire

    Meilleure visibilité alertes

    Navigation :

    BottomNavigationBar

    Routes nommées GetX

    Destruction pile inutile via offAllNamed()

    Optimisation mémoire mobile respectée.


#### 8. Défis Techniques Résolus


- Synchronisation temps réel
Utilisation Timer contrôlé + Rx.

- Simulation réaliste
Passage d’aléatoire brut à modèle pseudo-physique.

-Performance graphique
Limitation données + adaptation dynamique axes.



#### 9. Conclusion



Le projet ne se limite pas à une interface graphique.

    Il propose :

    Une architecture modulaire

    Une simulation cohérente

    Une séparation propre backend/frontend

    Une gestion d’état robuste

    Une base extensible vers l’IA réelle

    Les choix techniques privilégient :

    Rapidité de prototypage

    Clarté architecturale

    Performance mobile

    Évolutivité

    Ce système constitue un prototype fonctionnel solide de maintenance prédictive industrielle.

---
---

# FONCTIONNALITÉS MISES EN PLACE
## 1. Surveillance Temps Réel des Machines
### 1.1 Dashboard Principal (Home)
Ce que fait cette page

Affiche toutes les machines du parc industriel

Montre leur statut en temps réel :

Active

Warning

En panne

Maintenance

Met à jour automatiquement les données toutes les 5 secondes

Permet le filtrage par statut

Affiche des compteurs globaux (actives, en panne, maintenance)

Comment ça fonctionne techniquement

Appel périodique API /api/machines

Rafraîchissement via Timer côté Flutter

Variables observables GetX (.obs)

Mise à jour réactive de l’UI sans rechargement complet

Pourquoi c’est important

Un opérateur doit pouvoir comprendre l’état global en moins de 3 secondes.
Cette page joue le rôle de centre de contrôle.

## 2. Détail d’une Machine
### 2.1 Monitoring Capteurs Temps Réel

Affichage en direct des indicateurs :

Température moyenne

Vibrations

Courant

RPM

Énergie acoustique

Particules d’huile

Âge maintenance

Visualisation

Jauges radiales (lecture instantanée)

Graphique linéaire des 20 derniers points

Logique backend associée

Génération dynamique des données

Simulation pseudo-physique

Conservation d’un historique court (20 points)

Fonction supplémentaire

Bouton “Maintenance” :

Envoie une requête POST au backend

Force les valeurs à état maintenance

Permet test comportement système

Objectif

Permettre un diagnostic précis machine par machine.

## 3. Système de Prédiction Simplifié

Champ calculé : failure_next_24h

Logique utilisée

Basée sur des seuils :

Température critique

Vibrations anormales

Surconsommation électrique

Ce n’est pas une IA entraînée, mais :

Une démonstration fonctionnelle

Une architecture prête à accueillir un vrai modèle ML

Utilité

Afficher une alerte proactive avant panne réelle.

## 4. Module Alertes
### 4.1 Détection Automatique

Le système :

Analyse les statuts reçus

Classe les machines en :

Critical

Warning

Info

### 4.2 Interface dédiée

Liste triable par gravité

Code couleur (rouge, orange)

Rafraîchissement automatique

### 4.3 Animation Visuelle

Icône pulsante

Signal visuel permanent tant qu’une alerte critique existe

Objectif

Ne jamais laisser passer une panne silencieuse.

## 5. Time Machine (Analyse Historique)

Probablement la fonctionnalité la plus avancée.

### 5.1 Consultation par Date

Sélecteur Date

Chargement données CSV via API

Filtrage côté backend

Limitation à 200 lignes :

Évite surcharge mémoire

Maintient fluidité graphique

### 5.2 Sélection Multi-Capteurs

L’utilisateur peut choisir :

temp_mean

vib_mean

rpm_mean

etc.

### 5.3 Visualisation Graphique

Graphique fl_chart

Axe Y adaptatif (min/max dynamique)

Courbe lissée

### 5.4 Calcul d’Indicateurs (KPI)

Pour la période sélectionnée :

Moyenne

Pic maximum

Minimum

Objectif

Permettre analyse rétrospective et compréhension des tendances.

## 6. Gestion du Parc Machine
### 6.1 Modélisation

Chaque machine possède :

ID unique

Type

Marque

Profil de comportement

### 6.2 Profils différenciés

Les robots ne se comportent pas comme les presses.
La simulation varie selon le type.

Résultat :

Données cohérentes

Pas de bruit aléatoire absurde

## 7. Simulation de Panne

Route spécifique :

Forçage d’état panne

Utilisée pour tests

Permet de vérifier :

Réaction UI

Apparition alertes

Comportement dashboard

## 8. Mise à Jour Automatique

Toutes les 5 secondes :

Rafraîchissement Home

Rafraîchissement détails machine

Mise à jour alertes

Avantage :

Pas besoin de recharger manuellement

Expérience fluide

## 9. Architecture Extensible

Fonctionnalités déjà prêtes pour :

Intégration IA réelle

Base de données persistante

WebSocket temps réel

Authentification

Déploiement cloud

## 10. Expérience Utilisateur
Thème industriel sombre

Fond sombre

Cyan pour indicateurs

Rouge pour critique

Navigation

BottomNavigationBar

Routes nommées

Navigation fluide

Feedback utilisateur

Indicateurs de chargement

Snackbar erreurs réseau

États vides gérés

Résumé Global des Fonctionnalités

Le système permet :

Surveillance en temps réel

Analyse machine individuelle

Simulation maintenance

Détection proactive pannes

Consultation archives historiques

Visualisation graphique dynamique

Gestion intelligente des alertes

Rafraîchissement automatique

Interface industrielle optimisée







# 👥 Contributions de chaque membre

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

### Symelle(videdannonsymelle-lang) — Pages History, Navigation et Structure Frontend

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

### Ursule() — HomePage initiale et Début Equipment

Ursule a :

Développé une première version de la HomePage

Commencé l’implémentation de la page Equipment

Ces éléments ont permis :

De définir l’organisation visuelle initiale

De structurer l’affichage de base des machines

Ces pages ont ensuite été modifiées et connectées au backend et au système de monitoring lors des phases ultérieures.

---

### Trinité(Sylvio41) — Page Alerts

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

---

# Lien drive pour la capture video simple du projet compilé sur un émulateur
  <!-- met le lien ver le drive ici et supprime le commentaire, -->