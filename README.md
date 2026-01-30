# 📊 Employee & Salaries Data Analysis Project

[English version](#english-version) | [Українська версія](#українська-версія)

---

<a name="english-version"></a>
## 🌍 English Version

### 📌 Project Overview
This project focuses on analyzing employee data, salary structures, and department hierarchies within a parks system. The main goal is to demonstrate SQL proficiency, ranging from basic filtering to advanced analytical queries.

### 🛠 Tech Stack
* **SQL (PostgreSQL/MySQL):** Data querying and manipulation.
* **Advanced SQL Techniques:** CTE (Common Table Expressions), Window Functions, Case Statements, Complex Joins.

### 📂 Database Structure
* **`employee_demographics`**: Personal information, including age and gender.
* **`employee_salary`**: Job titles, salary details, and department assignments.
* **`parks_departments`**: A reference table for department names.

### 📊 Key Queries & Solutions
The `analysis.sql` file contains queries that solve the following business tasks:
1. **Top 3 Salaries:** Identifying the top 3 highest earners in each department using `DENSE_RANK()`.
2. **Salary Benchmarking:** Identifying employees earning above the company average using CTEs and subqueries.
3. **Bonus Calculation System:** Implementing a logic for bonuses based on age categories using `CASE` statements.
4. **Corporate Event Planning:** Merging employee lists for corporate events using `UNION`.

---

<a name="українська-версія"></a>
## 🇺🇦 Українська версія

### 📌 Опис проєкту
Цей проєкт присвячений аналізу даних співробітників, їхніх зарплат та структури департаментів у системі парків. Основна мета — продемонструвати навички роботи з SQL: від простої фільтрації до складних аналітичних запитів.

### 🛠️ Використані технології
* **SQL (PostgreSQL/MySQL):** Написання та оптимізація запитів.
* **Просунутий SQL:** CTE (Common Table Expressions), віконні функції (Window Functions), оператори CASE, складні об'єднання (Joins).

### 📂 Структура бази даних
* **`employee_demographics`**: Дані про вік, стать та особисту інформацію.
* **`employee_salary`**: Дані про посади, зарплати та приналежність до департаментів.
* **`parks_departments`**: Довідник назв департаментів.

### 📊 Ключові запити
У файлі `analysis.sql` представлені запити, що вирішують такі бізнес-задачі:
1. **Топ-3 зарплат:** Визначення трьох найбільших зарплат у кожному департаменті (використання `DENSE_RANK`).
2. **Аналіз вище середнього:** Виявлення співробітників із зарплатою вищою за середню по компанії (використання CTE та підзапитів).
3. **Розрахунок бонусів:** Система нарахування бонусів залежно від вікової категорії співробітника (оператор `CASE`).
4. **Об'єднання списків:** Формування єдиних списків для корпоративних подій за допомогою `UNION`.

