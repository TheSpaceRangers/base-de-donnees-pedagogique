USE urban_air_quality;

DROP TABLE IF EXISTS dictionnaire_donnees;

CREATE TABLE dictionnaire_donnees (
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
WHERE table_schema = 'urban_air_quality' AND table_name IN ('air_quality_global', 'co2_emissions', 'ice_core_co2', 'urban_climate');


UPDATE dictionnaire_donnees
SET classification = IF(column_name LIKE '%latitude%'
                            OR column_name LIKE '%longitude%'
                            OR column_name LIKE '%data_quality%'
                            OR column_name LIKE '%data_source%'
                            OR column_name LIKE '%measurement_method%'
                            OR column_name LIKE '%measurement_type%', 'Interne', 'Publique')
WHERE table_name IN ('air_quality_global', 'co2_emissions', 'ice_core_co2', 'urban_climate');

UPDATE dictionnaire_donnees
SET commentaire = 'Nom de la ville concernée par la mesure de qualité de l’air'
WHERE table_name = 'air_quality_global' AND column_name = 'city';

UPDATE dictionnaire_donnees
SET commentaire = 'Pays associé à la ville mesurée'
WHERE table_name = 'air_quality_global' AND column_name = 'country';

UPDATE dictionnaire_donnees
SET commentaire = 'Concentration moyenne de dioxyde d’azote (NO₂) en µg/m³'
WHERE table_name = 'air_quality_global' AND column_name = 'no2_ugm3';

UPDATE dictionnaire_donnees
SET commentaire = 'Concentration moyenne de particules fines (PM2.5) en µg/m³'
WHERE table_name = 'air_quality_global' AND column_name = 'pm25_ugm3';

UPDATE dictionnaire_donnees
SET commentaire = 'Source de la donnée environnementale (API, organisme officiel, etc.)'
WHERE table_name = 'air_quality_global' AND column_name = 'data_source';

-- Table : co2_emissions
UPDATE dictionnaire_donnees
SET commentaire = 'Teneur moyenne en CO₂ dans l’atmosphère (ppm)'
WHERE table_name = 'co2_emissions' AND column_name = 'co2_ppm';

UPDATE dictionnaire_donnees
SET commentaire = 'Type de mesure (ex. observation directe, reconstitution)'
WHERE table_name = 'co2_emissions' AND column_name = 'measurement_type';

UPDATE dictionnaire_donnees
SET commentaire = 'Année calendaire correspondant à la carotte de glace analysée'
WHERE table_name = 'ice_core_co2' AND column_name = 'calendar_year';

UPDATE dictionnaire_donnees
SET commentaire = 'Quantité de CO₂ mesurée dans les bulles d’air de la glace (ppm)'
WHERE table_name = 'ice_core_co2' AND column_name = 'co2_ppm';

UPDATE dictionnaire_donnees
SET commentaire = 'Nom du site glaciaire d’extraction de la carotte'
WHERE table_name = 'ice_core_co2' AND column_name = 'ice_core_site';

-- Table : urban_climate
UPDATE dictionnaire_donnees
SET commentaire = 'Température moyenne de la zone urbaine (°C)'
WHERE table_name = 'urban_climate' AND column_name = 'temperature_celsius';

UPDATE dictionnaire_donnees
SET commentaire = 'Intensité de l’îlot de chaleur urbain (écart avec zone rurale)'
WHERE table_name = 'urban_climate' AND column_name = 'urban_heat_island_intensity';

UPDATE dictionnaire_donnees
SET commentaire = 'Vitesse moyenne du vent en m/s'
WHERE table_name = 'urban_climate' AND column_name = 'wind_speed_ms';

UPDATE dictionnaire_donnees
SET commentaire = 'Taux d’humidité moyen (%)'
WHERE table_name = 'urban_climate' AND column_name = 'humidity_percent';

CREATE OR REPLACE VIEW vw_carte_donnees AS
SELECT
    kcu.TABLE_NAME AS table_source,
    kcu.COLUMN_NAME AS colonne_source,
    kcu.REFERENCED_TABLE_NAME AS table_cible,
    kcu.REFERENCED_COLUMN_NAME AS colonne_cible
FROM information_schema.KEY_COLUMN_USAGE kcu
WHERE kcu.REFERENCED_TABLE_NAME IS NOT NULL
  AND kcu.TABLE_SCHEMA = 'nom_de_ton_schema'
ORDER BY table_source;

SELECT
    table_name,
    COUNT(column_name) AS nb_colonnes,
    SUM(CASE WHEN classification IS NOT NULL THEN 1 ELSE 0 END) AS nb_classes_remplies
FROM dictionnaire_donnees
GROUP BY table_name
ORDER BY table_name;
