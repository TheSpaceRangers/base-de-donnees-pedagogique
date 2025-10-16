import sqlite3

# Connexion à la base
conn = sqlite3.connect("Airline_Delay_Cause.sqlite")
cur = conn.cursor()

# Création de la table dictionnaire_donnees si elle n'existe pas
cur.execute("""
CREATE TABLE IF NOT EXISTS dictionnaire_donnees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT,
    column_name TEXT,
    data_type TEXT,
    is_nullable TEXT,
    constraint_type TEXT,
    classification TEXT,
    commentaire TEXT
)
""")

# Récupération de la liste des tables
cur.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")
tables = cur.fetchall()

# Pour chaque table, on récupère les infos colonnes
for (table_name,) in tables:
    cur.execute(f"PRAGMA table_info({table_name})")
    columns = cur.fetchall()
    for col in columns:
        col_name = col[1]
        data_type = col[2]
        notnull = col[3]  # 1 = NOT NULL, 0 = NULL autorisé
        is_nullable = 'NO' if notnull else 'YES'
        cur.execute("""
            INSERT INTO dictionnaire_donnees (table_name, column_name, data_type, is_nullable)
            VALUES (?, ?, ?, ?)
        """, (table_name, col_name, data_type, is_nullable))

conn.commit()
conn.close()
print("✅ Dictionnaire de données généré avec succès.")