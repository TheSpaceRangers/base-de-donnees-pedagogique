import os
import pandas as pd
from sqlalchemy import create_engine, text

# === CONFIGURATION ===
DB_USER = "root"
DB_PASSWORD = "root_password"
DB_HOST = "localhost"
DB_PORT = 3306
DB_NAME = "urban_air_quality"
CSV_DIR = "urban_air_quality_dataset"

engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

for file in os.listdir(CSV_DIR):
    if not file.endswith(".csv"):
        continue

    table_name = os.path.splitext(file)[0].lower()
    file_path = os.path.join(CSV_DIR, file)
    print(f"📥 Importation de {file} → table `{table_name}`")

    # Lire le CSV avec pandas
    df = pd.read_csv(file_path)

    # Nettoyer les noms de colonnes
    df.columns = (
        df.columns.str.strip()
        .str.lower()
        .str.replace(" ", "_")
        .str.replace("-", "_")
    )

    # Envoi vers MySQL
    df.to_sql(
        name=table_name,
        con=engine,
        if_exists="replace",  # remplace la table si elle existe
        index=False,
        chunksize=1000,
        method="multi"
    )

    print(f"✅ Table `{table_name}` créée ({len(df)} lignes).")

print("🚀 Import terminé avec succès !")