USE urban_air_quality;

CREATE TABLE IF NOT EXISTS dictionnaire_donnees (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    column_name VARCHAR(100),
    data_type VARCHAR(50),
    is_nullable VARCHAR(3),
    constraint_type VARCHAR(50),
    classification VARCHAR(50),
    commentaire TEXT
);

INSERT INTO dictionnaire_donnees (table_name, column_name, data_type, is_nullable)
SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'urban_air_quality';