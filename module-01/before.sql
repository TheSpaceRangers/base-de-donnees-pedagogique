CREATE TABLE clients (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(150), -- manque contrainte UNIQUE et NOT NULL (à corriger)
    telephone VARCHAR(20),
    adresse TEXT,
    ville VARCHAR(100),
    code_postal VARCHAR(10),
    pays VARCHAR(50),
    date_inscription VARCHAR(20) -- devrait être de type DATE
);

CREATE TABLE produits (
    id_produit INT AUTO_INCREMENT PRIMARY KEY,
    nom_produit VARCHAR(150),
    categorie VARCHAR(100),
    prix DECIMAL(10,2),
    stock INT,
    date_creation DATE
);

CREATE TABLE factures (
    id_facture INT AUTO_INCREMENT PRIMARY KEY,
    id_client INT, -- clé étrangère manquante volontairement
    date_facture DATE,
    montant_total DECIMAL(10,2),
    statut VARCHAR(50),
    commentaire TEXT
);

CREATE TABLE lignes_facture (
    id_ligne INT AUTO_INCREMENT PRIMARY KEY,
    id_facture INT,
    id_produit INT,
    quantite INT,
    prix_unitaire DECIMAL(10,2)
);

CREATE TABLE employes (
    id_employe INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(150),
    poste VARCHAR(100),
    salaire DECIMAL(10,2),
    departement VARCHAR(100),
    date_embauche DATE,
    manager_id INT
);

CREATE TABLE departements (
    id_departement INT AUTO_INCREMENT PRIMARY KEY,
    nom_departement VARCHAR(100),
    localisation VARCHAR(100)
);

INSERT INTO clients (nom, prenom, email, telephone, adresse, ville, code_postal, pays, date_inscription)
VALUES
('Durand', 'Paul', 'paul.durand@gmail.com', '0612345678', '10 rue de Paris', 'Paris', '75001', 'France', '2022-01-05'),
('Dupont', 'Marie', 'marie.dupont@gmail.com', '0622334455', '5 avenue Victor Hugo', 'Lyon', '69003', 'France', '2021-11-20'),
('Dupont', 'Marie', 'marie.dupont@gmail.com', '0622334455', '5 avenue Victor Hugo', 'Lyon', '69003', 'France', '2021-11-20'), -- doublon volontaire
('Smith', 'John', NULL, '0700000000', 'Unknown', 'Londres', 'N/A', 'UK', '01/03/2021'); -- email NULL et format de date incohérent

INSERT INTO produits (nom_produit, categorie, prix, stock, date_creation)
VALUES
('Ordinateur portable', 'Informatique', 850.00, 12, '2022-04-10'),
('Clavier mécanique', 'Informatique', 120.00, 45, '2023-01-02'),
('Ecran 27 pouces', 'Informatique', -320.00, 20, '2021-12-30'), -- prix négatif volontaire
('Bureau bois', 'Mobilier', 250.00, 5, '2023-03-15');

INSERT INTO lignes_facture (id_facture, id_produit, quantite, prix_unitaire)
VALUES
(1, 1, 1, 850.00),
(1, 2, 1, 120.00),
(2, 4, 1, 250.00),
(3, 3, 1, 300.00);

INSERT INTO employes (nom, prenom, email, poste, salaire, departement, date_embauche, manager_id)
VALUES
('Martin', 'Sophie', 'sophie.martin@data.fr', 'Comptable', 2800.00, 'Finance', '2020-03-15', NULL),
('Leclerc', 'Pierre', 'pierre.leclerc@data.fr', 'Commercial', 3200.00, 'Ventes', '2021-05-01', 1),
('Bernard', 'Luc', 'luc.bernard@data.fr', 'IT Support', 2900.00, 'Informatique', '2019-07-12', 1),
('Lambert', 'Anne', NULL, 'RH', 3100.00, 'Ressources Humaines', '2022-01-10', NULL); -- email manquant

INSERT INTO departements (nom_departement, localisation)
VALUES
('Finance', 'Paris'),
('Ventes', 'Lyon'),
('Informatique', 'Marseille'),
('Ressources Humaines', 'Paris');

