# 🧑‍💼 Employee Database Management System (EDMS)

A full-stack, production-style web application for managing employee records, built with **Python (Flask)**, **MySQL**, **HTML5**, **CSS3**, and **JavaScript**. Designed as a BCA final-year project but built to professional standards — secure auth, role-based access, charts, PDF/Excel exports, and a polished custom UI.

---

## ✨ Features

| Category | Details |
|---|---|
| 🔐 **Authentication** | Secure login with hashed passwords (Werkzeug), session management, role-based access (Admin / HR / Viewer) |
| 👥 **Employee Management** | Full CRUD — add, view, edit, delete employees with photo upload |
| 🔍 **Search & Filter** | Live search by name/code/email, filter by department & status, pagination |
| 🏢 **Department Management** | Add/remove departments, auto-computed stats (headcount, avg salary, payroll) |
| 📅 **Attendance Tracking** | Mark daily attendance (Present / Absent / Leave / Half-Day) |
| 📊 **Dashboard & Analytics** | Live charts (Chart.js) — headcount by department, gender distribution, salary bands |
| 💰 **Salary Slip Generator** | One-click PDF payslip generation per employee, auto-saved to salary history |
| 📁 **Reports & Export** | Export full employee master list to **Excel (.xlsx)** and **PDF** |
| 🧾 **Activity Log** | Audit trail of every login, add, edit, and delete action |
| 🎨 **Custom UI** | Hand-built responsive design (no Bootstrap) — sidebar navigation, stat cards, data tables |

---

## 🛠️ Tech Stack

- **Backend:** Python 3, Flask
- **Database:** MySQL (via PyMySQL)
- **Frontend:** HTML5, CSS3 (custom, no framework), Vanilla JS, Chart.js
- **PDF Generation:** ReportLab
- **Excel Export:** openpyxl
- **Security:** Werkzeug password hashing, parameterized SQL queries (SQL-injection safe)
- **IDE:** Built and tested for **PyCharm**

---

## 📂 Project Structure

```
EmployeeDB/
│
├── database/
│   └── schema.sql              # MySQL tables, views, seed data
│
├── backend/
│   ├── app.py                  # Main Flask application (all routes)
│   ├── config.py                # DB credentials & app settings
│   ├── db.py                    # MySQL connection helper
│   ├── setup.py                 # One-time DB setup script
│   ├── requirements.txt         # Python dependencies
│   ├── templates/               # Jinja2 HTML templates
│   │   ├── base.html
│   │   ├── login.html
│   │   ├── register.html
│   │   ├── dashboard.html
│   │   ├── employees.html
│   │   ├── employee_form.html
│   │   ├── employee_view.html
│   │   ├── departments.html
│   │   ├── attendance.html
│   │   ├── reports.html
│   │   └── 404.html
│   └── static/
│       ├── css/style.css        # Full custom stylesheet
│       ├── js/main.js
│       └── uploads/             # Employee photos
│
└── README.md
```

---

## 🚀 Setup Instructions (PyCharm)

### 1. Install MySQL
Make sure MySQL Server is installed and running on your machine. (MySQL Workbench / XAMPP / WAMP all work fine.)

### 2. Open the project in PyCharm
`File → Open` → select the `EmployeeDB` folder.

### 3. Create a virtual environment
PyCharm will usually prompt you automatically. If not:
```bash
python -m venv venv
venv\Scripts\activate        # Windows
source venv/bin/activate     # macOS/Linux
```

### 4. Install dependencies
```bash
cd backend
pip install -r requirements.txt
```

### 5. Configure your database credentials
Open `backend/config.py` and update:
```python
MYSQL_USER = "root"
MYSQL_PASSWORD = "your_mysql_password"   # <-- set this
MYSQL_DB = "employee_db_system"
```

### 6. Run the setup script (creates DB + tables + admin login)
```bash
python setup.py
```
This creates the database, all tables, sample data, and a working admin account.

### 7. Run the application
```bash
python app.py
```

### 8. Open in browser
```
http://127.0.0.1:5000
```

**Default login:**
- Username: `admin`
- Password: `admin123`

> ⚠️ Change this password after first login in a real deployment, or register a new account from the Register page.

---

## 🖥️ Key Screens

1. **Login / Register** — secure entry point
2. **Dashboard** — live stats, department & gender charts, recent activity
3. **Employees** — searchable, filterable, paginated table with quick actions
4. **Add / Edit Employee** — full form with photo upload
5. **Employee Profile** — detailed view + attendance + salary history
6. **Departments** — manage business units
7. **Attendance** — daily tracking
8. **Reports** — payroll & salary-band charts, Excel/PDF export

---

## 🎓 For Your Resume

> **Employee Database Management System** — A full-stack web application built with Python (Flask), MySQL, HTML5, CSS3, and JavaScript implementing secure role-based authentication, complete CRUD operations, real-time analytics dashboards (Chart.js), automated PDF salary-slip generation (ReportLab), and Excel/PDF report exports (openpyxl). Designed a normalized relational schema with foreign keys, SQL views, and an audit-log table to track all user actions.

**Key talking points for interviews:**
- Used parameterized queries throughout to prevent SQL injection
- Implemented role-based access control (Admin/HR/Viewer) with decorator-based route protection
- Built a normalized MySQL schema with foreign keys and SQL VIEWs for derived statistics
- Generated dynamic PDF documents (reports + payslips) server-side with ReportLab
- Designed and coded the entire UI from scratch (no CSS framework) — sidebar layout, responsive grid, custom design tokens

---

## 🔮 Possible Future Enhancements

- Email notifications (e.g. payslip auto-emailed monthly)
- Leave request & approval workflow
- REST API layer for a mobile app
- Two-factor authentication
- Docker containerization for deployment

---

## 👤 Author

**[Your Name]**
BCA Final Year Project
