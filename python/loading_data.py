import pandas as pd
import sqlite3
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

conn = sqlite3.connect("data/raw/database.sqlite")

query = """
SELECT name
FROM sqlite_master
WHERE type='table';
"""

tables = pd.read_sql(query, conn)
table_names = tables["name"].tolist()

print(tables)
print("Tables found:", table_names)


df_match = pd.read_sql("SELECT * FROM Match LIMIT 5", conn)

print(df_match)

load_dotenv()

user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
database = os.getenv("DB_NAME")

connection = f"postgresql://{user}:{password}@{host}:{port}/{database}"


engine = create_engine(connection)



for table in table_names:
    print(f"Loading table: {table}")

    df = pd.read_sql(f'SELECT * FROM "{table}"', conn)

    df.to_sql(
        name=table.lower(),
        con=engine,
        if_exists="replace",
        index=False
    )

    print(f"Loaded: {table} -> {table.lower()}")

print("All tables loaded successfully.")