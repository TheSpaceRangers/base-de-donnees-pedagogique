# 🧾 Rapport d'Audit — Base de données `entreprise_audit`

**Auteur :** Charles  
**Date :** 2025-10-15  
**Projet :** Module 01 — Audit structurel et qualité des données  
**Entreprise étudiée :** DataConsult SARL  

---

## 🔍 1. Analyse et constats

L’audit de la base de données `entreprise_audit` a permis d’identifier plusieurs anomalies dans la structure et la qualité des données.  
Ces incohérences concernent aussi bien la conception du schéma (types, contraintes) que les enregistrements eux-mêmes.

### Principales anomalies détectées :

- **Colonnes non contraintes (NULL injustifié)** : plusieurs colonnes critiques comme `clients.email` ou `employes.email` sont facultatives.  
- **Doublons** : des clients apparaissent plusieurs fois avec les mêmes informations.  
- **Types inadaptés** : la colonne `date_inscription` est au format `VARCHAR` au lieu de `DATE`.  
- **Valeurs incohérentes** : certains produits ont un **prix négatif**.  
- **Contraintes manquantes** : aucune clé étrangère n’existe entre `factures`, `lignes_facture` et leurs tables parentes.  
- **Données orphelines** : une facture référence un `id_client` inexistant.  
- **Emails manquants ou invalides** : certains enregistrements clients et employés n’ont pas d’adresse email renseignée.

---

## 🧱 2. Recommandations de correction

| Table | Colonne | Type d’anomalie | Recommandation |
|--------|----------|-----------------|----------------|
| `clients` | `email` | Nullable, doublons | Ajouter contraintes `NOT NULL` et `UNIQUE`, supprimer doublons |
| `clients` | `date_inscription` | Type inadapté | Modifier le type → `DATE` |
| `produits` | `prix` | Valeurs négatives | Corriger les valeurs < 0 et ajouter contrainte `CHECK (prix >= 0)` |
| `factures` | `id_client` | Clé étrangère manquante | Ajouter `FOREIGN KEY (id_client)` vers `clients(id_client)` |
| `lignes_facture` | `id_facture`, `id_produit` | Clés étrangères manquantes | Ajouter contraintes FK correspondantes |
| `factures` | `id_client` | Donnée orpheline | Supprimer ou corriger les factures sans client valide |
| `employes` | `email` | Nullable | Ajouter contrainte `NOT NULL` |
| `clients` | `email` | Format invalide | Mettre en place une vérification via REGEXP ou script de validation |

---

## ⚙️ 3. Correctifs SQL suggérés

### Contraintes et corrections de structure

```sql
ALTER TABLE clients 
    MODIFY email VARCHAR(150) NOT NULL UNIQUE,
    MODIFY date_inscription DATE;

ALTER TABLE produits 
    ADD CONSTRAINT chk_prix_positif CHECK (prix >= 0);

ALTER TABLE factures 
    ADD CONSTRAINT fk_factures_clients 
    FOREIGN KEY (id_client) REFERENCES clients(id_client);

ALTER TABLE lignes_facture 
    ADD CONSTRAINT fk_lignes_facture_factures FOREIGN KEY (id_facture) REFERENCES factures(id_facture),
    ADD CONSTRAINT fk_lignes_facture_produits FOREIGN KEY (id_produit) REFERENCES produits(id_produit);
```

---

## 🧹 4. Actions de nettoyage de données

Supprimer les doublons dans la table clients :

```sql
DELETE c1
FROM clients c1
JOIN clients c2
  ON c1.id_client > c2.id_client
 AND c1.nom = c2.nom
 AND c1.prenom = c2.prenom
 AND c1.email = c2.email;
```

Mettre à jour les prix négatifs :

```sql
UPDATE produits
SET prix = ABS(prix)
WHERE prix < 0;
```

Supprimer les factures orphelines :

```sql
DELETE FROM factures
WHERE id_client NOT IN (SELECT id_client FROM clients);
```

---

## 📈 5. Conclusion

La base entreprise_audit présente plusieurs failles classiques :
- absence de contraintes d’intégrité référentielle, 
- incohérences de types, 
- données en doublon ou manquantes.

Après application des correctifs proposés :
- la structure sera plus robuste, 
- les relations entre tables seront cohérentes, 
- et la qualité globale des données sera améliorée pour la suite du module (cartographie et gouvernance).
