SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT *
FROM parks_departments;

-- [UA] Знаходжу всіх жінок (Female) у таблиці демографії. Виведи всі колонки, але відсортуй результат за прізвищем у алфавітному порядку. 
-- [EN] Retrieve all female employees from the demographics table. Select all columns and sort the results by last name in alphabetical order.
SELECT *
FROM employee_demographics
WHERE gender = 'Female'
ORDER BY last_name;

-- [UA] Виводжу імена (first_name), прізвища (last_name) та вік усіх співробітників, яким більше 40 років. 
-- [EN] Select the first names, last names, and ages of all employees older than 40.
SELECT first_name
      ,last_name
	  ,age
FROM employee_demographics
WHERE age > 40;

-- [UA] Рахую середню зарплату (salary) усіх співробітників у таблиці employee_salary. 
-- [EN] Calculate the average salary of all employees in the employee_salary table.
SELECT AVG(salary)
FROM employee_salary;

-- [UA] Виводжу список усіх унікальних посад з таблиці employee_salary. 
-- [EN] Select a list of all unique occupations from the employee_salary table.
SELECT DISTINCT(occupation)
FROM employee_salary;

-- [UA] Виводжу імена, прізвища та зарплату тих співробітників, чия зарплата становить від 50 000 до 70 000 включно. 
-- [EN] Select the first names, last names, and salaries of employees whose salary is between 50,000 and 70,000 inclusive.
SELECT first_name
       ,last_name
	   ,salary
FROM employee_salary
WHERE salary BETWEEN 50000 AND 70000
ORDER BY salary DESC;

-- [UA] Виводжу імена та прізвища тих співробітників, які НЕ працюють у департаменті з ID 1, і при цьому їхня зарплата більша за 55 000. 
-- [EN] Select the first names and last names of employees who do NOT work in the department with ID 1 and have a salary greater than 55,000.
SELECT first_name
       ,last_name
	   ,salary
	   ,dept_id
FROM employee_salary
WHERE salary > 55000
     AND dept_id != 1;

-- [UA] Виводжу ім'я, вік та зарплату. 
-- [EN] Select the first name, age, and salary of employees.
SELECT dem.first_name
     , dem.age
     , sal.salary
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
ORDER BY sal.salary;

-- [UA] Виводжу дані по працівнику, зарплату та назву департаменту. 
-- [EN] Select employee details, salary, and department name.
SELECT dem.first_name
     , sal.salary
	 , dep.department_name
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS dep
  ON dep.department_id = sal.dept_id;

-- [UA] Шукаю "найбагатший" департамент. Виводжу назву департаменту та суму всіх зарплат у цьому департаменті. 
-- [EN] Identify the "wealthiest" department. Select the department name and the total sum of all salaries within that department.
SELECT dep.department_name
     , SUM(sal.salary)
FROM employee_salary AS sal
INNER JOIN parks_departments AS dep
  ON dep.department_id = sal.dept_id
 GROUP BY dep.department_name 
 ORDER BY SUM(sal.salary) DESC;

-- [UA] Виводжу назву департаменту та кількість жінок, які в ньому працюють. 
-- [EN] Select the department name and the total number of female employees working in it.
SELECT COUNT(dem.gender)
	 , dep.department_name
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS dep
  ON dep.department_id = sal.dept_id
WHERE gender = 'Female'
GROUP BY department_name;

-- [UA] Пошук менеджерів та їхніх доходів. Керівництво хоче побачити звіт по всіх співробітниках, які займають посади менеджерів, але тільки тих, хто працює в департаментах. Виводжу повне ім'я (однією колонкою: ім'я та прізвище через пробіл), посаду та зарплату. 
-- [EN] Search for managers and their earnings. Management wants a report on all employees in Manager positions who work within departments. Select the full name (as a single column: first and last name separated by a space), occupation, and salary.
SELECT first_name || ' ' || last_name AS full_name
	  ,salary
	  ,occupation
FROM employee_salary AS sal
INNER JOIN parks_departments AS dep
  ON dep.department_id = sal.dept_id
WHERE occupation LIKE '%Manager%'
     AND department_name IS NOT NULL
ORDER BY salary DESC;


-- [UA] Бонусна система. Керівництво вирішило нарахувати бонуси залежно від віку працівників. Тобі потрібно вивести список усіх людей і розрахувати їхній потенційний бонус. Виводжу ім'я, прізвище, вік та нову колонку bonus_percentage за такими правилами: Якщо працівнику понад 50 років — бонус 20%. Якщо працівнику від 35 до 50 років — бонус 10%. Всім іншим (молодшим 35) — бонус 5%. 
-- [EN] Bonus system. Management has decided to award bonuses based on employee age. You need to list all individuals and calculate their potential bonus. Select the first name, last name, age, and a new column "bonus_percentage" based on the following rules: If an employee is over 50 years old, the bonus is 20%. If an employee is between 35 and 50 years old, the bonus is 10%. For all others (under 35), the bonus is 5%.
SELECT first_name
	  , last_name
	  , age
      , CASE 
          WHEN age > 50 THEN '20%'
          WHEN age BETWEEN 35 AND 50 THEN '10%'
          ELSE '5%'
          END AS bonus_percentage 
FROM employee_demographics
ORDER BY age DESC;

-- [UA] Виводжу ім'я, прізвище та фактичну суму бонусу в грошах. Бонус рахується від зарплати (salary з таблиці employee_salary). Відсотки ті самі: (50+ років — 20%, 35-50 років — 10%, інші — 5%). Називаю колонку з грошима bonus_amount. 
-- [EN] Select the first name, last name, and the actual bonus amount. The bonus is calculated based on salary (from the employee_salary table). The percentage rates are as follows: (50+ years old — 20%, 35-50 years old — 10%, others — 5%). Name the column bonus_amount.
SELECT dem.first_name
	  , dem.last_name
	  , sal.salary
	  , ROUND(CASE 
          WHEN age > 50 THEN salary * 0.2
          WHEN age BETWEEN 35 AND 50 THEN salary * 0.1
          ELSE salary * 0.05
          END) AS bonus_amount
FROM employee_demographics as dem
INNER JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id;

-- [UA] Формування списку для корпоративу. Ми хочемо запросити на сцену дві групи людей: всіх, кому понад 60 років (як почесних ветеранів), та всіх, хто заробляє понад 70 000 (як топ-перформерів). Пишу два запити та об'єдную їх за допомогою UNION. Запит 1: Виводжу ім'я, прізвище та мітку 'Veteran' для працівників 60+ років. Запит 2: Виводжу ім'я, прізвище та мітку 'High Earner' для працівників із зарплатою > 70 000. 
-- [EN] Creating a guest list for the corporate event. We want to invite two groups of people to the stage: everyone over 60 years old (as honored veterans) and everyone earning over 70,000 (as top performers). Write two queries and combine them using UNION. Query 1: Select the first name, last name, and the label 'Veteran' (as a separate text column) for employees aged 60+. Query 2: Select the first name, last name, and the label 'High Earner' for employees with a salary > 70,000.
SELECT first_name
      , last_name
	  , 'Veteran' AS category
FROM employee_demographics
WHERE age > 60
UNION
SELECT first_name
      , last_name
	  , 'High Earner' AS category
FROM employee_salary
WHERE salary> 70000;

-- [UA] Знаходжу всіх співробітників, чия зарплата вище середньої по всій компанії. 
-- [EN] Retrieve all employees whose salary is above the average salary of the entire company.
SELECT first_name
       , last_name
	   , salary
FROM employee_salary
WHERE salary > (SELECT AVG(salary) FROM employee_salary)
ORDER BY salary DESC;

-- [UA] Виводжу ім'я, зарплату та середню зарплату по всьому департаменту поруч із кожним працівником. 
-- [EN] Select the first name, salary, and the average salary of the entire department alongside each employee.
SELECT first_name
     , salary
     ,ROUND( AVG(salary) OVER(PARTITION BY dept_id) )as avg_dept_salary
	 ,ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC)
FROM employee_salary;

-- [UA] Використовую CTE, щоб знайти працівників, які заробляють більше, ніж середня зарплата в їхньому департаменті. 
-- [EN] Use a CTE to identify employees who earn more than the average salary within their respective departments.
WITH DeptAvg AS (
    SELECT sal.employee_id
	      , sal.salary
	      , AVG(sal.salary) OVER(PARTITION BY dept_id) as avg_salary
	      , dem.first_name || ' ' || dem.last_name AS full_name
    FROM employee_salary as sal
	JOIN employee_demographics AS dem 
	ON dem.employee_id = sal.employee_id
)
SELECT full_name
       , salary
       , ROUND(avg_salary, 0)
FROM DeptAvg
WHERE salary > avg_salary;

-- [UA] Виводжу топ-3 найбільш високооплачуваних співробітників у кожному департаменті. 
-- [EN] Select the top 3 highest-paid employees in each department.
WITH Top_3_salary_of_each_depart AS  (
SELECT sal.employee_id
	      , sal.salary
	      , dem.first_name || ' ' || dem.last_name AS full_name
	      , dep.department_name
	      , DENSE_RANK() OVER(
		  PARTITION BY sal.dept_id 
		  ORDER BY sal.salary DESC
		  ) AS rang_salary  
    FROM employee_salary AS sal
LEFT JOIN employee_demographics AS dem
   ON dem.employee_id = sal.employee_id
JOIN parks_departments AS dep 
	ON dep.department_id = sal.dept_id
)
SELECT full_name
       , salary
	   , rang_salary 
	   , department_name
FROM Top_3_salary_of_each_depart
WHERE rang_salary <= 3;

-- [UA] Додаю нового співробітника в таблицю employee_demographics. 
-- [EN] Insert a new employee into the employee_demographics table.
INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date  )
VALUES (101, 'Taras', 'Shevchenko', 30, 'Male','1994-03-09'  );

-- [UA] Змінюю вік Тараса (співробітник з ID 101) з 30 на 31 рік. 
-- [EN] Update the age of Taras (employee with ID 101) from 30 to 31.
UPDATE employee_demographics
SET age = 31
WHERE employee_id = 101;

-- [UA] Масове оновлення. Підвищую зарплату на 10% усім, хто працює в департаменті №1 (dept_id = 1). 
-- [EN] Bulk update. Increase the salary by 10% for everyone working in department #1 (dept_id = 1).
UPDATE employee_salary
SET salary = salary * 1.1
WHERE dept_id = 1;

-- [UA] Видаляю Тараса Шевченка з бази employee_demographics, оскільки він звільнився. 
-- [EN] Delete Taras Shevchenko from the employee_demographics table as he has resigned.
DELETE FROM employee_demographics
WHERE employee_id = 101;


