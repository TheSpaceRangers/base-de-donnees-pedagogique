USE entreprise_audit;

SELECT nom, prenom, email, COUNT(*) AS nb
FROM clients
GROUP BY nom, prenom, email
HAVING COUNT(*) > 1;

DELETE FROM clients
WHERE id_client NOT IN (
    SELECT id_client FROM (
        SELECT MIN(id_client) AS id_client
        FROM clients
        GROUP BY nom, prenom, email
    ) AS c_valides
);

UPDATE produits
SET prix = ABS(prix)
WHERE prix < 0;

DELETE FROM factures
WHERE id_client NOT IN (SELECT id_client FROM clients);

DELETE FROM clients
WHERE email IS NULL;

ALTER TABLE clients
    MODIFY email VARCHAR(150) NOT NULL UNIQUE,
    MODIFY date_inscription DATE;

ALTER TABLE produits
    ADD CONSTRAINT chk_prix_positif CHECK (prix >= 0);

ALTER TABLE factures
    ADD CONSTRAINT fk_factures_clients
    FOREIGN KEY (id_client) REFERENCES clients(id_client);

DELETE FROM lignes_facture
WHERE id_facture NOT IN (SELECT id_facture FROM factures);

ALTER TABLE lignes_facture
    ADD CONSTRAINT fk_lignes_facture_factures FOREIGN KEY (id_facture) REFERENCES factures(id_facture),
    ADD CONSTRAINT fk_lignes_facture_produits FOREIGN KEY (id_produit) REFERENCES produits(id_produit);