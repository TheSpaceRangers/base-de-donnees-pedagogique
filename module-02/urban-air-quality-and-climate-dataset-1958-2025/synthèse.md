# 🧾 Rapport TP-02 — Cartographie et Gouvernance des Données

## 1. Objectif

L’objectif de ce travail est de concevoir un dictionnaire de données automatisé à partir d’un jeu de données environnementales.  
Ce dictionnaire permet d’assurer la **traçabilité, la classification et la gouvernance** des informations dans une logique de conformité et de qualité (RGPD, ISO 27001).

Il s’agit de documenter la structure des tables, de comprendre les relations entre les entités, d’identifier les données sensibles, et de définir un cadre pour la documentation continue.

---

## 2. Méthodologie

1. **Extraction automatique** des métadonnées à partir du schéma MySQL.  
2. **Création d’une table de dictionnaire** centralisant les informations sur chaque colonne (type, contrainte, sensibilité, commentaire).  
3. **Classification automatique** des données selon leur nature : publique, interne, restreinte ou confidentielle.  
4. **Ajout manuel de commentaires** décrivant le rôle métier de chaque champ.  
5. **Cartographie des tables** pour repérer d’éventuelles dépendances ou liens logiques.  
6. **Vérification de la couverture documentaire** afin de s’assurer que chaque colonne a bien été classifiée et commentée.

---

## 3. Résultats de la cartographie

### Tables analysées

| Table | Nombre de colonnes | Description |
|-------|--------------------|--------------|
| air_quality_global | 11 | Données sur la qualité de l’air par ville (NO₂, PM2.5, coordonnées, source, méthode). |
| co2_emissions | 6 | Données d’émissions globales de CO₂ atmosphérique (ppm, date, source). |
| ice_core_co2 | 8 | Données historiques issues de carottes de glace (CO₂, âge, qualité, méthode). |
| urban_climate | 12 | Données climatiques urbaines (température, humidité, vent, précipitations, intensité urbaine). |

---

## 4. Classification des données

| Niveau de classification | Type de données | Exemples de colonnes | Mesures de protection |
|---------------------------|-----------------|----------------------|-----------------------|
| **Publique** | Métadonnées, sources, méthodes | `data_source`, `data_quality`, `measurement_method` | Aucune restriction |
| **Interne** | Données environnementales et scientifiques | `temperature_celsius`, `humidity_percent`, `co2_ppm` | Contrôle d’accès interne |
| **Restreinte** | Données géographiques ou identifiantes | `city`, `country`, `latitude`, `longitude` | Pseudonymisation ou agrégation |
| **Confidentielle** | Non applicable dans ce jeu de données | - | - |

La majorité des informations sont **publiques** ou **internes**, destinées à l’analyse scientifique.  
Les seules données **restreintes** concernent la localisation géographique (ville, pays, coordonnées).

---

## 5. Analyse de la gouvernance

| Élément analysé | Observation | Risque | Recommandation |
|------------------|-------------|--------|----------------|
| Données de localisation (`city`, `country`) | Permettent d’identifier la zone précise de mesure | Risque de ré-identification | Agréger au niveau régional ou anonymiser |
| Champ `data_source` | Valeurs hétérogènes selon les jeux de données | Difficulté de normalisation | Harmoniser les sources via référentiel |
| Valeurs de mesures (`temperature`, `humidity`, `co2_ppm`) | Données quantitatives continues | Valeurs aberrantes possibles | Ajouter des contrôles de cohérence |
| Champ `data_quality` | Parfois manquant ou NULL | Perte d’indication sur la fiabilité | Définir une valeur par défaut |
| Données temporelles (`year`, `month`) | Cohérentes entre tables | Aucun risque majeur | Conserver le format standardisé |

---

## 6. Cartographie des relations

Les quatre tables sont **indépendantes** : elles ne possèdent pas de clés étrangères explicites.  
Elles peuvent cependant être reliées de manière logique via des champs communs (`year`, `month`, `city`, `country`) afin de réaliser des analyses croisées.  
Une **vue de cartographie** pourrait illustrer ces liens analytiques pour des tableaux de bord climatiques.

---

## 7. Synthèse et recommandations

### Constats
- 4 tables documentées et analysées.  
- 37 colonnes classifiées.  
- 100 % des colonnes ont une classification.  
- Données majoritairement publiques et internes.  
- Quelques champs restreints liés à la géolocalisation.

### Recommandations
1. **Automatiser** la mise à jour du dictionnaire à chaque modification du schéma MySQL.  
2. **Normaliser** les champs de source et de qualité pour garantir la cohérence.  
3. **Contrôler** les valeurs aberrantes sur les indicateurs environnementaux.  
4. **Documenter** dans le dictionnaire les plages de validité attendues (unités, seuils).  
5. **Intégrer** le dictionnaire dans les livrables de conformité et les audits de données.  
6. **Créer une cartographie visuelle** (ex. Power BI, Metabase, DBeaver ERD) reliant les entités par les champs temporels et géographiques.

---

## 8. Conclusion

Le dictionnaire de données mis en place constitue une base solide de gouvernance :  
il permet de suivre la structure, la sensibilité et la provenance des informations environnementales.  
Ce travail améliore la **traçabilité**, facilite la **conformité réglementaire** et prépare les futures étapes d’**audit de qualité des données**.

---

### ✍️ Auteur
**Charles [Nom]**  
Alternant Chef de Projet IT  
Module 02 — *Cartographie et Gouvernance des Données*  
Date : *(à compléter)*
