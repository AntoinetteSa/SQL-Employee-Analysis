SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT *
FROM parks_departments;

--Знаходжу всіх жінок (Female) у таблиці демографії. Виведи всі колонки, але відсортуй результат за прізвищем у алфавітному порядку.
SELECT *
FROM employee_demographics
WHERE gender = 'Female'
ORDER BY last_name;

--Виводжу імена (first_name), прізвища (last_name) та вік усіх співробітників, яким більше 40 років.
SELECT first_name
      ,last_name
	  ,age
FROM employee_demographics
WHERE age > 40;

--Рахую середню зарплату (salary) усіх співробітників у таблиці employee_salary.
SELECT AVG(salary)
FROM employee_salary;

--Виводжу список усіх унікальних посад (occupation) з таблиці employee_salary
SELECT DISTINCT(occupation)
FROM employee_salary;

--Виводжу імена (first_name), прізвища (last_name) та зарплату (salary) тих співробітників, чия зарплата становить від 50 000 до 70 000 включно.
SELECT first_name
       ,last_name
	   ,salary
FROM employee_salary
WHERE salary BETWEEN 50000 AND 70000
ORDER BY salary DESC;

--Виводжу імена (first_name) та прізвища (last_name) тих співробітників, які НЕ працюють у департаменті з ID 1, і при цьому їхня зарплата більша за 55 000.
SELECT first_name
       ,last_name
	   ,salary
	   ,dept_id
FROM employee_salary
WHERE salary > 55000
     AND dept_id != 1;

--Виводжу ім'я (first_name), вік (age) та зарплату (salary).
SELECT dem.first_name
     , dem.age
     , sal.salary
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
ORDER BY sal.salary;

--Виводжу дані по працівнику, зарплату та назву департаменту.
SELECT dem.first_name
     , sal.salary
	 , dep.department_name
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS dep
  ON dep.department_id = sal.dept_id;

--Шукаю "найбагатший"департамент. Виводжу назву департаменту  та суму всіх зарплат у цьому департаменті.
SELECT dep.department_name
     , SUM(sal.salary)
FROM employee_salary AS sal
INNER JOIN parks_departments AS dep
  ON dep.department_id = sal.dept_id
 GROUP BY dep.department_name 
 ORDER BY SUM(sal.salary) DESC;

 --Виводжуназву департаменту та кількість жінок, які в ньому працюють.
SELECT COUNT(dem.gender)
	 , dep.department_name
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS dep
  ON dep.department_id = sal.dept_id
WHERE gender = 'Female'
GROUP BY department_name;

--Пошук менеджерів та їхніх доходів. Керівництво хоче побачити звіт по всіх співробітниках, які займають посади менеджерів (Manager), але тільки тих, хто працює в департаментах. Виведи повне ім'я (однією колонкою: ім'я та прізвище через пробіл), посаду (occupation) та зарплату.
SELECT first_name || '' || last_name AS full_name
	  ,salary
	  ,occupation
FROM employee_salary AS sal
INNER JOIN parks_departments AS dep
  ON dep.department_id = sal.dept_id
WHERE occupation LIKE '%Manager%'
     AND department_name IS NOT NULL
ORDER BY salary DESC;

--Бонусна система. Керівництво вирішило нарахувати бонуси залежно від віку працівників. Тобі потрібно вивести список усіх людей і розрахувати їхній потенційний бонус.Виведи ім'я, прізвище, вік та нову колонку bonus_percentage за такими правилами: Якщо працівнику понад 50 років — бонус 20%. Якщо працівнику від 35 до 50 років — бонус 10%.Всім іншим (молодшим 35) — бонус 5%.
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

--Виводжу ім'я, прізвище та фактичну суму бонусу в грошах.Бонус рахується від зарплати (salary з таблиці employee_salary).Відсотки ті самі: (50+ років — 20%, 35-50 років — 10%, інші — 5%).Назви колонку з грошима bonus_amount.
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

--Формування списку для корпоративу.Ми хочемо запросити на сцену дві групи людей:Всіх, кому понад 60 років (як почесних ветеранів).Всіх, хто заробляє понад 70 000 (як топ-перформерів).Напиши два запити та об'єднай їх за допомогою UNION.Запит 1: Виведи ім'я, прізвище та мітку 'Veteran' (як окрему текстову колонку) для працівників 60+ років.Запит 2:Виведи ім'я, прізвище та мітку 'High Earner'для працівників із зарплатою > 70 000.
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

--Знаходжу всіх співробітників, чия зарплата вище середньої по всій компанії.
SELECT first_name
       , last_name
	   , salary
FROM employee_salary
WHERE salary > (SELECT AVG(salary) FROM employee_salary)
ORDER BY salary DESC;

--Виводжу ім'я, зарплату та середню зарплату по всьому департаменту поруч із кожним працівником.
SELECT first_name
     , salary
     ,ROUND( AVG(salary) OVER(PARTITION BY dept_id) )as avg_dept_salary
	 ,ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC)
FROM employee_salary;

--Використовую CTE, щоб знайти працівників, які заробляють більше, ніж середня зарплата в їхньому департаменті.
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

--Виводжу топ-3 найбільш високооплачуваних співробітників у кожному департаменті. 
WITH Top_3_salary_of_each_depart AS   
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

--Додаю нового співробітника в таблицю employee_demographics.
INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date  )
VALUES (101, 'Taras', 'Shevchenko', 30, 'Male','1994-03-09'  );

--Змінюю вік Тараса (співробітник з ID 101) з 30 на 31 рік.
UPDATE employee_demographics
SET age = 31
WHERE employee_id = 101;

--Масове оновлення.Підвищую зарплату на 10% усім, хто працює в департаменті №1 (dept_id = 1).
UPDATE employee_salary
SET salary = salary * 1.1
WHERE dept_id = 1;

--Видаляю Тараса Шевченка з бази employee_demographics, оскільки він звільнився.
DELETE FROM employee_demographics
WHERE employee_id = 101;
