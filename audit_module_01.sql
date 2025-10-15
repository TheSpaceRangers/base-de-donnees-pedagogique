USE entreprise_audit;

CREATE TABLE audit_structure (
    id_audit INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100),
    colonne VARCHAR(100),
    anomalie VARCHAR(200),
    commentaire TEXT,
    date_audit TIMESTAMP DEFAULT NOW()
);

INSERT INTO audit_structure (table_name, colonne, anomalie, commentaire)
SELECT table_name, column_name, 'Nullable injustifié', 'Ajouter contrainte NOT NULL'
FROM information_schema.columns
WHERE table_schema = 'entreprise_audit'
  AND is_nullable = 'YES'
  AND table_name IN ('clients','produits','factures','lignes_facture','employes');

INSERT INTO audit_structure (table_name, colonne, anomalie, commentaire)
SELECT 'clients', 'date_inscription', 'Type inadapté', 'Doit être DATE au lieu de VARCHAR(20)';

INSERT INTO audit_structure (table_name, colonne, anomalie, commentaire)
VALUES
('factures', 'id_client', 'Clé étrangère manquante', 'Doit référencer clients(id_client)'),
('lignes_facture', 'id_facture', 'Clé étrangère manquante', 'Doit référencer factures(id_facture)'),
('lignes_facture', 'id_produit', 'Clé étrangère manquante', 'Doit référencer produits(id_produit)');

INSERT INTO audit_structure (table_name, colonne, anomalie, commentaire)
SELECT 'clients', 'email', 'Doublons détectés', CONCAT('Doublon sur ', email)
FROM clients
GROUP BY nom, prenom, email
HAVING COUNT(*) > 1;

INSERT INTO audit_structure (table_name, colonne, anomalie, commentaire)
SELECT 'produits', 'prix', 'Valeur incohérente', CONCAT('Prix négatif : ', prix)
FROM produits
WHERE prix < 0;

INSERT INTO audit_structure (table_name, colonne, anomalie, commentaire)
SELECT 'clients', 'email', 'Email manquant', 'Email NULL ou vide'
FROM clients
WHERE email IS NULL OR email = '';

INSERT INTO audit_structure (table_name, colonne, anomalie, commentaire)
SELECT 'factures', 'id_client', 'Client inexistant',
       CONCAT('id_client = ', f.id_client)
FROM factures f
LEFT JOIN clients c ON f.id_client = c.id_client
WHERE c.id_client IS NULL;

CREATE VIEW v_audit_resume AS
SELECT table_name,
       COUNT(*) AS nb_anomalies,
       GROUP_CONCAT(DISTINCT anomalie SEPARATOR ', ') AS types_anomalies
FROM audit_structure
GROUP BY table_name;

