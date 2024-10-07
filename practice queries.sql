create database food;
use food;
create table info (name char(30),phone double,address varchar(255),country char(25),gender char(25));
show databases;
select * from food.info;
insert into food.info (name,phone,address,country,gender)
values("nikhil",8261929813,"boisar","india","male");
insert into food.info (name,phone,address,country,gender)
values("varad",9822334455,"umroli","sweden","male"),
("priti",8261929813,"palghar","usa","female"),
("juee",8712123344,"kelwa","nepal","female"),
("suraj",7689123241,"vangaon","bhutan","male");
select * from food.info;
alter table food.info rename column phone to contact;
alter table food.info rename column contact to phone;
alter table food.info add column city char(25);
insert into food.info (city) values("mumbai"),("delhi"),("pune"),("navi mumbai"),("raipur");
alter table food.info drop column city;
alter table food.info add column city char(25);
set SQL_SAFE_UPDATES=0;
update food.info set city="mumbai" where name="nikhil";
update food.info
set
city=case
when name="varad" then "delhi"
when name="priti" then "pune"
when name="juee" then "navi mumbai"
when name="suraj" then "raipur"
else null
end
where name in ("varad","priti","juee","suraj");
------- copy table-----------
select * from food.info;
select * from food.student;
create table student select * from food.info;
alter table food.info change phone  contact double;
update food.info set contact=1111111111 where name = "priti";
select gender,count(city) from food.info group by gender;
select curdate(),current_date(),current_time(),current_timestamp(),curtime() from food.info;
select * from food.info join food.student on info.name=student.name;
show tables;

select * from info;

update info set address="virai" where name="varad";

alter table info rename column contact to phone;

select * from info join student on info.name=student.name;

select *,
-- row_number() over()as id,
rank() over(partition by gender order by name) from info;
create table product(order_date date,sales int);
insert into product (order_date,sales) values('2021-01-01',20),
('2021-01-02',32),('2021-02-08',45),('2021-02-04',31);
select * from product;

select 
extract(year from order_date) as years,
month(order_date) as months,
sum(sales) as total_sales
from product
group by 1,2
order by 3 desc;

create table application(candidate_id int,skills char(25));
insert into application(candidate_id, skills) values(101,'power bi'),(101,"python"),
(101,"sql"),(102,"tableau"),(102,"sql"),(108,'python'),(108,'sql'),(108,'power bi');
select * from application;

select candidate_id,
count(skills) as count_skills
from application
where skills in ("sql","python","power bi")
group by 1
having count(skills)=3
order by 1 desc;


create table employee(salary int);
insert into employee(salary) values (8000),(7000),(7000),(6000),(5000),(5000),(4000);

select * from employee;
(select salary,
rank() over(order by salary desc) as sal
from employee);

alter table employee add column department char(25);
truncate employee;
insert into employee (salary,department) values (1000,'hr'),(2000,'hr'),
(3000,'hr'),(4000,'hr'),(5000,'it'),(6000,'it'),(7000,'it'),(8000,'it');

with cte as (select salary,department,
dense_rank() over(partition by department order by salary) as sal from employee)
select * from cte where sal=3;

create table gender(sex char(25));
insert into gender(sex) values('f'),('m'),('f'),('m');
select * from gender;
update food.gender set sex=case
when sex='f' then 'm'
when sex='m' then 'f'
else sex
end
where sex in ('f','m');

with cte as (
select salary,
 dense_rank() over(order by salary desc) as rank_salary
 from table_name)
 select salary from cte where rank_salary=2;
 
 create table duplicates(id int);
 insert into duplicates(id) values(2),(2),(4),(4);
 select * from duplicates;
 
select id,dense_rank() over(order by id)as sal from duplicates ;
 delete from duplicates where id in
 (select id,count(id) from duplicates group by id having count(id)>1);
 
 WITH RankedRows AS (
    SELECT *,
           ROW_NUMBER() OVER ( PARTITION BY id ORDER BY id) AS rn
    FROM duplicates
)
DELETE FROM duplicates
WHERE id IN (
    SELECT id
    FROM RankedRows
    WHERE rn > 1
);
 select * from duplicates; 
 truncate table duplicates;
  insert into duplicates(id) values(8),(8),(6),(6),(1),(2),(5),(9);
  
 select max(id)as max_nuumber from duplicates
 where id in (select id from duplicates group by id having count(*)=1);
 
select * from application;
select * from application where skills like "_o%";

create table app(name char(25));
insert into app (name) values ("name"),("name"),("nik"),("varad"),("varad");

select * from app;

with cte as 
(select name,
row_number() over(partition by name) as dup
from app)
delete from cte where dup>1;

select * from app;


delete from app where name in (select name,count(name) as dup
from app group by name having dup>1);

WITH ranked_app AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY name) AS rn
    FROM 
        app
)
DELETE FROM app
WHERE name IN (
    SELECT name
    FROM ranked_app
    WHERE rn > 1
);
select * from app;

create table deff(name char(25));
insert into deff (namess) values ("nik"),("var"),("juee");

with cte as (
select *,row_number() over(partition by name) as n
from deff)
delete from deff
where name in (select name from cte where n>1);
select * from deff;

alter table deff rename column name to namess;


DELETE FROM deff
WHERE namess in (
    SELECT namess
    FROM deff
    GROUP BY namess
    HAVING COUNT(namess) > 1);
    
 with cte as (
 select namess,
 row_number() over(partition by namess) as cut
 from deff)
 delete from deff
 where namess in (select namess from cte where cut>1);
 
 DELETE FROM deff
WHERE namess NOT IN (
    SELECT MIN(namess)
    FROM deff
    GROUP BY namess
);

DELETE FROM deff
WHERE namess IN (
    SELECT * FROM (
        SELECT namess
        FROM deff
        GROUP BY namess
        having count(namess)>1
    ) AS temp
);

 select * from deff;
 
 select department,avg(salary)
 from emplyoee group by department;
 
 SELECT department, AVG(salary) AS avg_salary
FROM emplyoee
GROUP BY department;

 select * from emplyoee;
 
 CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department char(25),
    manager_id INT);
 
 INSERT INTO employees VALUES
(1, 'John', 60000,"account", 1),
(2, 'Alice', 80000,"account", 1),
(3, 'Bob', 70000,"account", 1),
(4, 'Charlie', 95000,"it", 2),
(5, 'David', 75000,"it", 2),
(6, 'Eva', 90000,"it", 2),
(7, 'Frank', 82000,"hr", 3),
 (8, 'ben', 82000,"hr", 3),
 (9, 'ben', 82000,"hr", 3);
 set sql_mode=only_full_group_by;
 select * from employees;
 select distinct department from employees;
 
 select distinct e.department,
 lead(e.employee_name,2) over(partition by m.department) as 3rd
 from employees e
 join employees m
 on e.employee_id=m.employee_id;
 
 create table s (name char(25),hired_date date);
 insert into s (name,hired_date) values("nik","2024-01-01"),
 ("varad","2024-01-02"),("kartik","2024-01-03");
 alter table s add column department char(25);
 update s set department="it" where name="nik";
 update s set department="it" where name="varad";
 update s set department="it" where name="kartik";
 select * from s;
 
 select name,hired_date,department
 from  (select name,hired_date,
 lead(hired_date) over(partition by department) as 3rd
 from s) as subquery
 where 3rd is null;
 
 SELECT name, department, hired_date
FROM (
    SELECT 
        name,
        department,
        hired_date,
        LEAD(hired_date) OVER (PARTITION BY department ORDER BY hired_date ASC) AS next_joindate
    FROM 
        s
) AS subquery
WHERE next_joindate IS NULL;

update s set hired_date='2021-08-01' where name="kartik";

-- newest joining for everydepartment(solved using lead,lag)--
select name, department,hired_date 
from (select name,department,hired_date,
lead(hired_date) over (partition by department order by hired_date asc) as next_date
from s) as subquery 
where next_date is null;

-- age range--
create table age(age int);
 insert into age(age) values(5),(11),(17),(31);
 select * from age;
 select * ,
 case
 when age<=10 then "0-10"
 when age<=20 then "11-20"
 when age<=30 then "21-30"
 when age<=40 then "31-40"
 end as age_range
 from age;
 
 select * from employees;
 
 select * from employees where salary>(select max(salary) from employees where 
 department ="it");
 
 create table queue(id int,name char(25),weight int,turn int);
 insert into queue(id,name,weight,turn) values (1,"alice",250,1),(2,"bob",175,5),
 (3,"alex",350,2),(4,"john ceha",450,3);
 select * from queue;
 
select  distinct last_value(name) over() from
(select name ,weight,sum(weight) over( order by id) as w from queue) as s where s.w <1300;

 SELECT empname, department, joindate
FROM (
    SELECT 
        empname,
        department,
        joindate,
        LEAD(joindate) OVER (PARTITION BY department ORDER BY joindate ASC) AS next_joindate
    FROM 
        employee
) AS subquery
WHERE next_joindate IS NULL;

create table number(num int);
insert into number(num) values(8),(8),(6),(6),(1),(2),(3);

select max(num) as max_number
 from (select *
		from number group by num having count(num)=1) as sub;

select num from (select num ,
dense_rank() over(order by num desc) as max
from number) as sub where max=2;

select num from (select num ,
dense_rank() over(order by num desc) as max
from number) as sub where max= 3;

create table sex (sex char(3));
insert into sex(sex) values('f'),('m');
select * from sex;

update sex 
set sex=case
when sex='f' then 'm'
when sex='m' then 'f'
else sex
end 
 where sex in ('f','m');
  
 select * from number;

delete from number where num in (select num from (select num
from number
group by num
having count(num)>1) as sub);

insert into number(num) values(9),(8),(10);
select * from number;

with cte as ( select *,
row_number() over() as rn
from number)
select * from cte where rn%2=1;


CREATE TABLE Employee (
EmpID int NOT NULL,
EmpName Varchar(25),
Gender Char,
Salary int,
City Char(20) );
--- first run the above code then below code
INSERT INTO Employee
VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura');

CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar(25),
EmpPosition Char(20),
DOJ date );

--- first run the above code then below code
INSERT INTO EmployeeDetail
VALUES (1, 'P1', 'Executive', '2019-01-26'),
(2, 'P2', 'Executive', '2020-05-04'),
(3, 'P1', 'Lead', '2021-10-21'),
(4, 'P3', 'Manager', '2019-11-29'),
(5, 'P2', 'Manager', '2020-08-01');

select * from employeedetail;
select * from employee;

select EmpName
from employee
where Salary between 200000 and 300000;
-- find the name belong to same city-- 
select *
from employee e1,employee e2
where e1.city=e2.city and e1.empid!=e2.empid;
-- find the null values-- 
select * from employee
where empid is null;

-- cumulative sum of employee salary--;
select empname , salary , sum(salary) over( order by empid) as cumulative_salary from employee;
-- male  female ratio in percentage---
SELECT 
    Gender,
    concat(round(count(gender) * 100.0 / (SELECT COUNT(*) FROM Employee),2),"%") AS Percentage
FROM 
    Employee
GROUP BY 
    Gender;

-- fetch half record from table--
select * from employee where empid<=( select count(*)/2 from employee);

select * from 
(select *,row_number() over(order by empname) as rownumber from employee) as emp
where emp.rownumber<=
(select count(*)/2 from employee);

-- Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
-- i.e 12345 will be 123XX
SELECT 
    EmpID,
    EmpName,
    Salary,
    CONCAT(SUBSTRING(Salary, 1,  length(salary)-2), 'XX') AS ModifiedSalary
FROM 
    Employee;

select empid,empname,salary,
concat(left(salary,length(salary)-2),"xx") as salary
from employee;

-- find even and odd records-- 
select * from 
(select *,row_number() over(order by empid) as row_num
from employee) as emp 
where emp.row_num%2=0;

select * from employee where mod(empid,2)=0;

-- find record where name start from A --
select * from employee where empname like "a%";

-- Find Nth highest salary from employee table with and without using the
-- TOP/LIMIT keywords.
select * from  (select *
,dense_rank() over ( partition by gender order by salary desc) as rr
from employee) as emp
where emp.rr=2;

select * from employee;
-- Write a query to find and remove duplicate records from a table.
select empid,count(*) as count_row 
from employee 
group by 1 
having count(*) >1;

delete from employee
where empid in (select * from (select empid from employee group by empid having count(*)>1) as s);

WITH CTE AS (
    SELECT e.EmpID, e.EmpName, ed.Project
    FROM Employee AS e
    INNER JOIN EmployeeDetail AS ed
    ON e.EmpID = ed.EmpID
)

SELECT c1.EmpName AS Employee1, c2.EmpName AS Employee2, c1.Project
FROM CTE c1, CTE c2
WHERE c1.Project = c2.Project 
  AND c1.EmpID != c2.EmpID 
  AND c1.EmpID < c2.EmpID;


