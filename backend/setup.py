"""
setup.py - One-time setup script for EDMS

What it does:
  1. Connects to MySQL using credentials from config.py
  2. Creates the database & tables (runs database/schema.sql)
  3. Creates a working default admin account with a PROPER hashed password
     (the schema.sql placeholder hash is not a real password - this script fixes that)

Run this ONCE before starting app.py:
    python setup.py
"""

import os
import sys
import pymysql
from werkzeug.security import generate_password_hash
from config import Config

SCHEMA_PATH = os.path.join(os.path.dirname(__file__), "..", "database", "schema.sql")


def run_schema(connection, cfg):
    print("→ Reading schema.sql ...")
    with open(SCHEMA_PATH, "r", encoding="utf-8") as f:
        sql_script = f.read()

    # Split on semicolons but keep it simple/safe for this script-based schema
    statements = [s.strip() for s in sql_script.split(";") if s.strip()]

    with connection.cursor() as cursor:
        for stmt in statements:
            try:
                cursor.execute(stmt)
            except pymysql.err.Error as e:
                # Ignore duplicate entry / already exists errors so setup.py is re-runnable
                if e.args[0] in (1062, 1050, 1007):  # duplicate key, table exists, db exists
                    continue
                print(f"  ! Warning on statement: {e}")
    connection.commit()
    print("✓ Schema applied successfully.")


def fix_admin_password(connection, cfg):
    print("→ Setting a working password for the default admin account ...")
    new_hash = generate_password_hash("admin123")
    with connection.cursor() as cursor:
        cursor.execute(
            "UPDATE users SET password_hash = %s WHERE username = 'admin'",
            (new_hash,)
        )
    connection.commit()
    print("✓ Admin password set. Login with username: admin / password: admin123")


def main():
    cfg = Config()
    print("=" * 60)
    print(" EMPLOYEE DATABASE MANAGEMENT SYSTEM — Setup")
    print("=" * 60)

    try:
        # Step 1: connect WITHOUT specifying a database (so we can create it)
        conn = pymysql.connect(
            host=cfg.MYSQL_HOST,
            user=cfg.MYSQL_USER,
            password=cfg.MYSQL_PASSWORD,
            port=cfg.MYSQL_PORT,
            charset="utf8mb4",
        )
    except pymysql.err.OperationalError as e:
        print(f"\n✗ Could not connect to MySQL: {e}")
        print("  Check MYSQL_HOST / MYSQL_USER / MYSQL_PASSWORD in config.py")
        sys.exit(1)

    run_schema(conn, cfg)
    conn.close()

    # Step 2: reconnect to the actual database to fix the admin password
    conn2 = pymysql.connect(
        host=cfg.MYSQL_HOST, user=cfg.MYSQL_USER, password=cfg.MYSQL_PASSWORD,
        db=cfg.MYSQL_DB, port=cfg.MYSQL_PORT, charset="utf8mb4",
    )
    fix_admin_password(conn2, cfg)
    conn2.close()

    print("\n✓ Setup complete! Now run:  python app.py")
    print("  Then open http://127.0.0.1:5000 in your browser.")
    print("  Login -> username: admin | password: admin123\n")


if __name__ == "__main__":
    main()
