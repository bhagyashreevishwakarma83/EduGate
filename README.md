\# EduGate 🎓



A full-stack web application that streamlines educational content delivery 

through a secure, role-based access system for Admins, Faculty, and Students.



\## 👥 Roles



\- \*\*Admin\*\* — Approves or blocks faculty, sends email notifications

\- \*\*Faculty\*\* — Uploads videos and PDFs after admin approval

\- \*\*Student\*\* — Accesses study materials by subject



\## ⚙️ Technologies Used



\- Java Servlets \& JSP

\- MySQL \& JDBC

\- JavaMail API (Gmail SMTP)

\- Apache Tomcat

\- HTML \& CSS



\## ✨ Features



\- Role-based access control

\- Admin approval system with email notifications

\- Faculty can upload videos and PDFs

\- Students can access materials by subject

\- Duplicate email detection on registration

\- Blocked faculty cannot login

\- Unapproved faculty cannot login



\## 🛠️ How to Run



\### 1. Database Setup

\- Open MySQL

\- Run the `database.sql` file included in this project

\- This will create the `education\_hub` database with all tables



\### 2. Config Setup

Create a file `src/java/config.properties` with your credentials:

```

mail.from=your@gmail.com

mail.password=your\_app\_password

db.url=jdbc:mysql://localhost:3306/education\_hub

db.user=root

db.password=your\_db\_password

admin.email=your@gmail.com

admin.password=your\_admin\_password

```



\### 3. Run

\- Open project in NetBeans

\- Deploy on Apache Tomcat

\- Open browser and go to `http://localhost:8080/EDUCATION\_HUB`

