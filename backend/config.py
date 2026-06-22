"""
Employee Database Management System
------------------------------------
A full-stack web application built with Flask, MySQL, HTML, CSS & JS.

Author : [Your Name]
Course : BCA - Final Year Project
Tech   : Python (Flask) | MySQL | HTML5 | CSS3 | JavaScript | Chart.js

Run:
    1. pip install -r requirements.txt
    2. Import database/schema.sql into MySQL
    3. Update DB credentials in config.py
    4. python app.py
    5. Open http://127.0.0.1:5000
"""

import os

class Config:
    # Flask
    SECRET_KEY = os.environ.get("SECRET_KEY", "change-this-secret-key-in-production")

    # MySQL Database credentials
    MYSQL_HOST = os.environ.get("MYSQL_HOST", "localhost")
    MYSQL_USER = os.environ.get("MYSQL_USER", "root")
    MYSQL_PASSWORD = os.environ.get("MYSQL_PASSWORD", "")          # <-- set your MySQL password
    MYSQL_DB = os.environ.get("MYSQL_DB", "employee_db_system")
    MYSQL_PORT = int(os.environ.get("MYSQL_PORT", 3306))

    # Uploads
    UPLOAD_FOLDER = os.path.join("static", "uploads")
    ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "gif"}
    MAX_CONTENT_LENGTH = 5 * 1024 * 1024  # 5 MB

    # Pagination
    EMPLOYEES_PER_PAGE = 8
