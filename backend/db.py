"""
db.py - MySQL connection handler using PyMySQL
Provides a simple get_db() / query helper pattern used across the app.
"""

import pymysql
import pymysql.cursors
from flask import g, current_app


def get_db():
    """Open a new database connection if there is none yet for the
    current application context, and return it as g.db."""
    if "db" not in g:
        cfg = current_app.config
        g.db = pymysql.connect(
            host=cfg["MYSQL_HOST"],
            user=cfg["MYSQL_USER"],
            password=cfg["MYSQL_PASSWORD"],
            db=cfg["MYSQL_DB"],
            port=cfg["MYSQL_PORT"],
            charset="utf8mb4",
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=False,
        )
    return g.db


def close_db(e=None):
    db = g.pop("db", None)
    if db is not None:
        db.close()


def init_app(app):
    """Register database teardown with the Flask app."""
    app.teardown_appcontext(close_db)


def execute_query(query, params=None, fetchone=False, fetchall=False, commit=False):
    """
    Generic helper to run SQL queries safely with parameterized inputs.

    Args:
        query (str): SQL query with %s placeholders
        params (tuple): values to bind
        fetchone (bool): return a single row
        fetchall (bool): return all rows
        commit (bool): commit transaction (for INSERT/UPDATE/DELETE)

    Returns:
        dict | list[dict] | int (lastrowid) | None
    """
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute(query, params or ())
        result = None
        if fetchone:
            result = cursor.fetchone()
        elif fetchall:
            result = cursor.fetchall()
        if commit:
            db.commit()
            result = cursor.lastrowid
        return result
    except Exception:
        db.rollback()
        raise
    finally:
        cursor.close()
