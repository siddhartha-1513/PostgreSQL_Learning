select Array['1', '2'] as int_array;

select '{"1","2"}' as int_array;

create table  tbl_array(id serial, state varchar(3), city_list varchar[2]);

select * from tbl_array;

select * from information_schema.columns 
where table_name = 'tbl_array';

insert into tbl_array(state, city_list) values ('abc', ARRAY['sarai khan', 'hauz khas']);

insert into tbl_array(state, city_list) values ('xz', ARRAY['meerut', 'saharanpur', 'agra']);

insert into tbl_array(state, city_list) values ('xyz', '{"abc", "mno"}');

select id, state, unnest(city_list) as city from tbl_array;

select * from tbl_array 
where 'agra' = any(city_list);

select id, state, city_list[1:2] as city from tbl_array ;

select id, state, cardinality(city_list) as no_city from tbl_array ;

select id, state, array_length(city_list,1) as no_city from tbl_array ;

-- Update the array in table 

update tbl_array 
set city_list = Array['a', 'b', 'c']
where id = 3;


select * from tbl_array ;

update tbl_array 
set city_list[2] = Array['abc']
where id = 3;

update tbl_array 
set city_list[3] =  'po'
where id = 3;

select id, state, array_append(city_list, 'c3') as color_list from tbl_array 
where id = 3;

with cte as (select '090813' as date_column
            UNION all
            select '130930' as date_column)
SELECT 
  date_column,
  TO_CHAR(
    TO_DATE(
      CASE 
        WHEN substr(date_column, 1, 2)::INT <= 50 THEN '20' 
        ELSE '19' 
      END || substr(date_column, 1, 2) || '-' ||
      substr(date_column, 3, 2) || '-' ||
      substr(date_column, 5, 2),
      'YYYY-MM-DD'
    ), 
    'YYYYDDD'
  ) AS date_in_yyyyddd
FROM cte;


select array[1,2,3];
-- Array in postgres are 1 based positional

select '{1,2,3}';

select '{"1","2","3"}';

select array[['1', '2','3'], [1,3]] as res;
-- SQL Error [42846]: ERROR: ARRAY could not convert type integer[] to text[]

select 'test' as res;


with cte as (
	select 'siddhartha' as name
	union all 
	select 'sony' as name
	union all 
	select 'abc' as name
	union all 
	select 'sanjay' as name
	union all 
	select 'vicky' as name)
select array_agg(name order by name) filter (where name like 's%') as res
from cte;
-- {sanjay,siddhartha,sony}

-- slicing 
with cte as (
	select 'siddhartha' as name
	union all 
	select 'sony' as name
	union all 
	select 'abc' as name
	union all 
	select 'sanjay' as name
	union all 
	select 'vicky' as name),
array_src as (select array_agg(name order by name) filter (where name like 's%') as res
from cte)
select res[1:1] from array_src;

-- indexing 
with cte as (
	select 'siddhartha' as name
	union all 
	select 'sony' as name
	union all 
	select 'abc' as name
	union all 
	select 'sanjay' as name
	union all 
	select 'vicky' as name),
array_src as (select array_agg(name order by name) filter (where name like 's%') as res
from cte)
select res[1] from array_src;



create table array_tbl (
	emp_id int primary key, 
	employee_name varchar(200), 
	health_ins bool, 
	member_of_insurnace text[]);

insert into array_tbl(emp_id, employee_name,health_ins, member_of_insurnace)
values(1, 'shubham', true, array['mother', 'father', 'wife']);

insert into array_tbl(emp_id, employee_name,health_ins, member_of_insurnace)
values(2, 'shivam', true, array[ 'father', 'wife']);

insert into array_tbl(emp_id, employee_name,health_ins, member_of_insurnace)
values(3, 'ravi', true, array[ 'father', 'wife', 'son']);

insert into array_tbl(emp_id, employee_name,health_ins, member_of_insurnace)
values(4, 'mohit', true, array[ 'father', 'wife', 'son','mother', 'daughter']);

insert into array_tbl(emp_id, employee_name,health_ins, member_of_insurnace)
values(5, 'manoj', true, array['mother', 'daughter']);


select * from array_tbl;

select 
	array_agg(employee_name order by employee_name) filter(where length(employee_name) > 4) as res
from array_tbl;

select 
	emp_id ,member_of_insurnace[2:2]
from array_tbl;

select 
	emp_id ,member_of_insurnace, array_length(member_of_insurnace) as res
from array_tbl;
-- SQL Error [42883]: ERROR: function array_length(text[]) does not exist
  /* 
   Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 39 
  */

SELECT array_length(ARRAY[[1, 2, 3], [4, 5, 6]], 1); -- Length of the first dimension (rows): 2
SELECT array_length(ARRAY[[1, 2, 3], [4, 5, 6]], 2); -- Length of the second dimension (columns): 3

select 
	emp_id ,member_of_insurnace, array_length(member_of_insurnace,1) as res
from array_tbl;

select 
	emp_id ,member_of_insurnace, array_length(member_of_insurnace,2) as res
from array_tbl;

select 
	emp_id ,member_of_insurnace,  member_of_insurnace[0] as res
from array_tbl;

select 
	emp_id ,member_of_insurnace,  member_of_insurnace[5] as res
from array_tbl;

update  array_tbl
set member_of_insurnace[2] = '{son}'
where emp_id = 2;

update  array_tbl
set member_of_insurnace[1] = 'wife'
where emp_id = 5;

update  array_tbl
set member_of_insurnace[1:1] = '{wife}'
where emp_id = 2;


with recursive alphabet as(
	select 'a' as res
	union all 
	select CONCAT(res, chr(ascii(right(res,1))+1)) as res
	from alphabet
	where length(res) <= 25)
select res 
from alphabet 
where length(res) = 26;


    

select ceil(random()*10);



create table big_table (
    id serial primary key,
    name text,
    age int,
    department text
);


select count(*) from big_table;
-- 10,000,000

select * from big_table;


create index name_idx on big_table (name);

drop index name_idx;

explain analyze select name from big_table
 where id = 1848332;
-- Execution Time: 0.066 ms

explain analyze select name from big_table
 where name = 'Employee-19999';
-- Execution Time: 459.341 ms

explain analyze select name from big_table
 where name like 'Employee-4959505%';
-- Execution Time: 551.964 ms

select pg_size_pretty(pg_total_relation_size('public.big_table'));
-- 818 MB

create index name_idx on big_table (name);
-- CREATE INDEX name_idx ON public.big_table USING btree (name)

select * from pg_indexes
 where tablename = 'big_table' ;

explain analyze select * from big_table
 where name like 'Employee-4959505%';
-- Execution Time: 542.407 ms
-- it expect literal value not the expression value 
-- that why index doesn't use or come into picture.
--   ->  Parallel Seq Scan on big_table  (cost=0.00..129334.33 rows=417 width=28) (actual time=422.968..509.513 rows=0 loops=3)

explain analyze select * from big_table
 where name = 'Employee-4959505';
-- Index Scan using name_idx on big_table  (cost=0.56..8.58 rows=1 width=28) (actual time=0.119..0.121 rows=1 loops=1)
-- executin time: Execution Time: 0.144 ms

explain analyze select * from big_table
 where name = 'Employee-4959505' or age = 78;
-- Execution Time: 559.668 ms

drop table if exists orders;
CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT,
    order_date   DATE,
    amount       NUMERIC(10,2)
);

INSERT INTO orders (customer_id, order_date, amount) values
(101, '2025-12-01', 300.00)
(101, '2024-01-15', 500.00),
(102, '2024-02-10', 150.00),
(103, '2024-02-11', 1200.00),
(101, '2024-03-05', 700.00),
(104, '2024-03-07', 300.00),
(102, '2024-04-10', 450.00),
(103, '2024-05-20', 250.00),
(101, '2024-06-01', 900.00),
(105, '2024-07-14', 1100.00),
(102, '2024-08-22', 200.00),
(104, '2024-09-10', 700.00),
(103, '2024-10-30', 400.00),
(105, '2024-11-11', 950.00),
(101, '2024-12-01', 300.00);

select 
  customer_id
 from (select distinct customer_id,
   sum(amount) over (partition by customer_id ) amount
   from orders
  where to_char(order_date,'YYYY') = '2024') t1
 order by amount desc limit 3;
 
drop table if exists customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL
);

-- Orders table
drop table if exists Orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL
);

INSERT INTO customers (customer_id, name, city) VALUES
(101, 'Siddhartha', 'Delhi'),
(102, 'Rajesh', 'Mumbai'),
(103, 'Mohan', 'Bangalore'),
(104, 'Ramesh', 'Chennai'),
(105, 'Anita', 'Delhi'),
(106, 'Pooja', 'Mumbai');

-- Insert orders
INSERT INTO orders (order_id, customer_id, order_date, amount) VALUES
(1, 101, '2024-01-15', 500),
(2, 102, '2024-01-18', 150),
(3, 101, '2024-02-10', 700),
(4, 103, '2024-02-12', 1200),
(5, 101, '2024-03-05', 900),
(6, 102, '2024-03-08', 450),
(7, 104, '2024-03-09', 300),
(8, 105, '2024-03-10', 200),
(9, 106, '2024-03-11', 600),
(10, 105, '2024-04-01', 1000);

select * from customers;

select * from orders;

CREATE TABLE employee_attendance (
    emp_id INT,
    attendance_date DATE,
    status VARCHAR(10)
);

INSERT INTO employee_attendance (emp_id, attendance_date, status) VALUES
-- Employee 1
(1, '2025-08-01', 'Present'),
(1, '2025-08-02', 'Absent'),
(1, '2025-08-03', 'Absent'),
(1, '2025-08-04', 'Present'),
(1, '2025-08-05', 'Absent'),
(1, '2025-08-06', 'Absent'),
(1, '2025-08-07', 'Absent'),
(1, '2025-08-08', 'Present'),

-- Employee 2
(2, '2025-08-01', 'Absent'),
(2, '2025-08-02', 'Absent'),
(2, '2025-08-03', 'Absent'),
(2, '2025-08-04', 'Present'),
(2, '2025-08-05', 'Absent'),
(2, '2025-08-06', 'Present'),

-- Employee 3
(3, '2025-08-01', 'Present'),
(3, '2025-08-02', 'Present'),
(3, '2025-08-03', 'Absent'),
(3, '2025-08-04', 'Absent'),
(3, '2025-08-05', 'Present');

select 
 * 
 from (select emp_id,  attendance_date, status,
  lead(status) over(partition by emp_id order by attendance_date) as next_day_status,
  lag(status) over(partition by emp_id order by attendance_date) as previous_day_status
 from employee_attendance) t1
where status = 'Absent'
  and 1 = 
       case when status = next_day_status or status = previous_day_status
        then 1 else 0
       end;

 with cte as (
  select emp_id, attendance_date, status,
         row_number() over (partition by emp_id order by attendance_date) as rn
  from employee_attendance
  where status = 'Absent'
)
select emp_id,
       min(attendance_date) as streak_start,
       max(attendance_date) as streak_end,
       count(*) as streak_length
from cte
group by emp_id, (attendance_date::date - rn::int)
having count(*) > 1
order by emp_id, streak_start;

select now()::date - interval '3 months'; -- 2025-06-03 00:00:00.000

select now()::date - interval '1 year'; -- 2024-09-03 00:00:00.000

select current_date - date '2025-08-01'as no_of_dayd_pass; -- 33

create table students (
    student_id int primary key,
    student_name text
);

insert into students values
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- Courses table
create table courses (
    course_id int primary key,
    course_name text
);

insert into courses values (104, 'AI');
(101, 'Math'),
(102, 'Science'),
(103, 'History');

-- Enrollments table
create table enrollments (
    student_id int references students(student_id),
    course_id int references courses(course_id),
    grade char(1)
);

insert into enrollments values
(1, 101, 'A'), (1, 102, 'B'), (1, 103, 'A'),  -- Alice in all 3
(2, 101, 'B'), (2, 103, 'C'),                 -- Bob missing Science
(3, 101, 'A'), (3, 102, 'A');                 -- Charlie missing History

select * from students;

select * from courses;

select * from enrollments;

delete from courses where course_id = 104;


select distinct
  s.student_id, 
  count(s.student_id) as student_count,
  count(c.course_id) as course_count
  from students s
  join enrollments e 
    on e.student_id = s.student_id
  join courses c 
    on c.course_id = e.course_id
  group by s.student_id
  order by count(c.course_id) desc
  limit 1;

select s.student_id, s.student_name,
  count(distinct e.course_id)
from students s
join enrollments e on s.student_id = e.student_id
group by s.student_id, s.student_name
having count(distinct e.course_id) = (select count(*) from courses);

select s.student_id, s.student_name
from students s
where not exists (
    select 1
    from courses c
    where not exists (
        select 1
        from enrollments e
        where e.student_id = s.student_id
          and e.course_id = c.course_id
    )
);


select sum(null::int) as result;

select null;


with sum_test as (
select null::int as val 
union all 
select null as val
union all 
select null as val
union all 
select null as val)
select sum(val) from sum_test;
-- NULL 
-- NULLs are ignored (they don’t contribute).
-- INT sum → returns BIGINT (to avoid overflow).

with sum_test as (
select 1100 as val 
union all 
select 100 as val
union all 
select 6 as val
union all 
select 7 as val)
select sum(val) from sum_test;
-- int8 or bigint data type 

with sum_test as (
select 1100 as val 
union all 
select 100.00 as val
union all 
select 6 as val
union all 
select 7 as val)
select sum(val) from sum_test;
-- value is of numeric type 
-- Watch for overflow risk in other DBs; PostgreSQL is safer because of type promotion.

SELECT SUM(x) FROM (VALUES (null::int), (null::int)) t(x);  -- NULL
SELECT SUM(x) FROM (VALUES (2147483647), (1)) t(x);  -- 2147483648 (promoted to bigint)

select avg(x) from  (values (5345), (45679)) t(x);
-- Integer inputs → result is numeric, not integer (to avoid truncation).
--25,512

SELECT COUNT(*) FROM (VALUES (NULL), (NULL)) t(x);   -- 2
SELECT COUNT(x) FROM (VALUES (NULL), (NULL)) t(x);   -- 0
SELECT COUNT(*) FROM (SELECT * FROM (select 9 as x) demo WHERE false) t; -- 0, not null

drop table t1;

CREATE TABLE t1 (
    c1 int UNIQUE
);

CREATE INDEX idx_c1 ON t1(c1);

 
select count(*) from salary;
select count(sal) from salary;

SELECT *
FROM orders
WHERE customer_id + 0 = 123;

drop table if exists employees;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary NUMERIC
);

INSERT INTO employees (emp_id, emp_name, dept_id, salary) VALUES
(1, 'Alice',   10, 90000),   -- Dept 10: 3 employees
(2, 'Bob',     10, 80000),
(3, 'Charlie', 10, 95000),
(4, 'David',   20, 50000),   -- Dept 20: 2 employees
(5, 'Eva',     20, 70000),
(6, 'Frank',   30, 60000),   -- Dept 30: 1 employee only
(7, 'Grace',   40, 75000),   -- Dept 40: 4 employees, with duplicate salaries
(8, 'Hank',    40, 75000),
(9, 'Ivy',     40, 85000),
(10,'Jack',    40, 95000);

with emp_sal as (
select emp_id, emp_name, dept_id, salary,
  count(*) over(partition by dept_id ) sal,
  row_number() over(partition by dept_id order by salary desc) as sal_des
 from employees)
select 
   emp_1.dept_id, emp_2.salary
 from (SELECT DISTINCT dept_id FROM employees) as emp_1
 left join emp_sal emp_2
 	on emp_1.dept_id = emp_2.dept_id
 and  emp_2.sal_des =2;

CREATE TABLE attendance (
    emp_id INT,
    attend_date DATE
);

-- Employee 1 has missing dates (2025-01-04, 2025-01-07)
INSERT INTO attendance (emp_id, attend_date) VALUES
(1, '2025-01-01'),
(1, '2025-01-02'),
(1, '2025-01-03'),
-- gap here (01-04 missing)
(1, '2025-01-05'),
(1, '2025-01-06'),
-- gap here (01-07 missing)
(1, '2025-01-08'),

-- Employee 2 continuous no gaps (2025-01-01 to 2025-01-05)
(2, '2025-01-01'),
(2, '2025-01-02'),
(2, '2025-01-03'),
(2, '2025-01-04'),
(2, '2025-01-05');

select * from attendance;

drop table if exists sales;
CREATE TABLE sales (
    order_id INT,
    customer_id INT,
    order_date DATE,
    amount NUMERIC(10,2)
);

INSERT INTO sales (order_id, customer_id, order_date, amount) VALUES
-- Customer 1 orders
(101, 1, '2025-01-01', 200.00),
(102, 1, '2025-01-03', 150.00),
(103, 1, '2025-01-05', 400.00),
(104, 1, '2025-01-06', 250.00),
(201, 2, '2025-01-02', 300.00),
(202, 2, '2025-01-03', 100.00),
(203, 2, '2025-01-07', 500.00);

select 
 order_id, customer_id, order_date, amount,
 sum(amount) over(partition by customer_id order by order_date) running_order_amount
 from sales;

select 
 order_id, customer_id, order_date, amount,
 sum(amount) over(partition by customer_id order by order_date
 rows between unbounded preceding and current row) running_order_amount
 from sales;

select 
 order_id, customer_id, order_date, amount,
 sum(amount) over(partition by customer_id order by order_date
 rows between unbounded preceding and unbounded following) running_order_amount
 from sales;

select 
 order_id, customer_id, order_date, amount,
 sum(amount) over(partition by customer_id order by order_date
 rows between 0 preceding and 1 following) running_order_amount
 from sales;

drop table if exists employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name TEXT,
    department TEXT,
    salary NUMERIC,
    manager_id INT,
    hire_date DATE
);

INSERT INTO employees (emp_name, department, salary, manager_id, hire_date) VALUES
('Alice', 'HR', 50000, NULL, '2015-01-10'),
('Bob', 'IT', 75000, 1, '2016-03-15'),
('Charlie', 'Finance', 60000, 1, '2017-07-22'),
('David', 'IT', 90000, 2, '2018-09-30'),
('Eve', 'Finance', 80000, 3, '2019-02-12'),
('Frank', 'IT', 70000, 2, '2020-06-05'),
('Grace', 'HR', 65000, 1, '2021-11-01');

INSERT INTO employees (emp_name, department, salary, manager_id, hire_date) VALUES
('Pseudo', 'Finance', 65000, 3, '2015-02-10');

update employees 
set hire_date = current_date - interval '2 months'
 where emp_id = 8;

drop table if exists orders;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    amount NUMERIC,
    order_date DATE
);

INSERT INTO orders (customer_id, amount, order_date) VALUES
(101, 250, '2023-01-01'),
(102, 450, '2023-01-05'),
(101, 250, '2023-01-05'),
(103, 1200, '2023-02-10'),
(101, 250, '2023-02-10'),
(104, 300, '2023-02-11'),
(102, 450, '2023-02-11');

INSERT INTO orders (customer_id, amount, order_date) VALUES
(101, 300, '2023-01-02');

select * from employees;

select * from orders;

-- Second Highest Salary 
select 
  max(salary)
 from employees
  where salary < (
  select max(salary) 
    from employees); 
    
-- Third highest salary 
 select 
  max(salary) from employees
 where salary < (select 
  max(salary)
 from employees
  where salary < (
  select max(salary) 
    from employees)); 
    
select
  * 
 from (select emp_name, salary, 
  dense_Rank() over(order by salary desc) as salary_rnk 
 from employees) t1 
  where salary_rnk =2;
 
-- List of employees whose salary is more than manager 
select 
  -- e1.emp_id, e1.emp_name, e1.salary, e2.emp_id, e2.emp_name, e2.salary
  e1.emp_id, e1.emp_name 
 from employees e1 
 join employees e2 
   on e1.manager_id = e2.emp_id
   and e1.salary > e2.salary ;
   
-- Show departments where the average salary is greater than 70,000.
select 
  department, avg_salary
 from (select 
  distinct Department,
  round(AVG(Salary) over(partition by department)) as avg_salary
 from employees ) t1
 where t1.avg_salary > 70000;

select current_date;
 
-- Find employees who joined in the last 2 years.
select 
  emp_id, emp_name
  hire_date,
  hire_date
 from employees 
  where 365 - (current_Date - hire_Date) >= 0  ; 
  
-- Show employees with no manager (top-level managers).
select 
  *
 from employees
 where manager_id is null;
 
-- Write a query to find the hierarchy (manager → employee) in a recursive way.
with recursive emp_mng_connect as ( 
  select 
   emp_id, null as manager, emp_name as employee, 1 as lvl
 from employees
 where manager_id is null 
 union all 
  select 
    e1.emp_id, emc.employee as manager,  e1.emp_name as employee, emc.lvl + 1 as lvl 
  from employees eselect * from orders;1 
  join emp_mng_connect emc 
  	on emc.emp_id = e1.manager_id )
 select 
   manager, employee
  from emp_mng_connect; 
  
-- Rank employees within each department by salary using window functions.
 select 
    emp_name, department, salary, 
    dense_rank() over(partition by department order by salary desc) as rnk 
  from employees;
  
-- Find employees who are in the same department as “David”.
select 
   *
 from employees e1
  where  exists  (select * 
                  from employees e2 
                  where e1.department = e2.department 
                   and e2.emp_name = 'David');
                   
-- Orders 
-- Find customers who made duplicate transactions (same amount, same date).  
select 
    customer_id, amount, order_date,
   row_number() over(partition by  amount, order_date) as rn
 from orders;
 -- no such data 

-- Find the customer with the highest total spending.
with amt_invst as(select distinct 
    customer_id, 
   sum(amount) over(partition by customer_id) as amount_invest
 from orders )
select 
  * from 
  amt_invst where amount_invest in (
  select 
	max(amount_invest) 
 from amt_invst);

SELECT customer_id, SUM(amount) AS total_spent
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;


--Find customers who placed orders on consecutive days.
-- no such data 
-- I inser tone dummy record 

select 
 customer_id, order_date
 from (select 
  customer_id, order_date,
  order_Date - lag(order_date,1) over(partition by customer_id order by order_Date) as rn1,
  lead(order_date,1) over(partition by customer_id order by order_Date) - order_date as rn2
from orders) t1
 where rn1= 1 or rn2 = 1;
 
-- Show the cumulative sum of amount per customer by date.
select 
  customer_id, order_date, 
  sum(amount) over(partition by customer_id order by order_Date) as cum_sum_amt 
 from orders;

-- Find customers who have never placed an order above 500.
select 
  customer_id
  from orders 
 group by customer_id 
 having max(amount) < 500;

-- Write a query to find the most frequent order amount (mode).
select 
  amount,
  count(*) as cnt
  from orders 
 group by amount  
 order by cnt desc limit 1;
 
SELECT amount, freq
FROM (
    SELECT amount,
           COUNT(*) AS freq,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM orders
    GROUP BY amount
) t
WHERE rnk = 1;

-- For each month, show the customer with the maximum total amount.

select 
* from (select    
 customer_id, 
 --EXTRACT(MONTH FROM order_date) as month,
 to_Char(order_Date, 'YYYY-MM') as month,
 sum(amount) as amt,
 row_number() over(partition by to_Char(order_Date, 'YYYY-MM') order by sum(amount) desc) as rn
from orders 
group by customer_id, to_Char(order_Date, 'YYYY-MM')) t1 where rn= 1; 
-- order by to_Char(order_Date, 'YYYY-MM'), amt desc;


SELECT * FROM (values (NULL), ('New York'), ('Delhi')) as customers(city) WHERE city <> 'New York';
-- delhi fechtes only as NULL cannot be comapred 

drop table if exists users;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name TEXT,
    segment TEXT
);

INSERT INTO users (user_id, user_name, segment) VALUES
(1, 'Alice',   'Gold'),
(2, 'Bob',     'Gold'),
(3, 'Charlie', 'Silver'),
(4, 'Diana',   'Silver'),
(5, 'Eve',     'Bronze'),
(6, 'Frank',   'Bronze');
 
select * from users;

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    booking_type TEXT,  -- 'flight' or 'hotel'
    booking_date DATE
);

INSERT INTO bookings (booking_id, user_id, booking_type, booking_date) VALUES
-- User 1 (Alice)
(101, 1, 'flight', '2022-01-10'),
(102, 1, 'hotel',  '2022-03-05'),
(103, 1, 'flight', '2022-04-12'),
(104, 1, 'hotel',  '2022-04-25'),
(105, 1, 'flight', '2022-06-18'),
(106, 2, 'hotel',  '2022-02-15'),
(107, 2, 'flight', '2022-04-05'),
(108, 2, 'flight', '2022-04-20'),
(109, 3, 'hotel',  '2022-01-20'),
(110, 3, 'hotel',  '2022-04-10'),
(111, 3, 'flight', '2022-05-01'),
(112, 4, 'flight', '2022-04-02'),
(113, 4, 'hotel',  '2022-04-18'),
(114, 5, 'hotel',  '2022-03-01'),
(115, 5, 'hotel',  '2022-04-07'),
(116, 6, 'flight', '2022-04-15'),
(117, 6, 'flight', '2022-04-28'),
(118, 6, 'hotel',  '2022-07-03');

select * from bookings
where booking_type = 'flight'
 and DATE_TRUNC('month', booking_date) = DATE '2022-04-01' ;

select * from pg_constraint;

--show, for each segment, the total number of users and the number of users who booked a flight in April 2022.
with user_segment as (
select 
 us.user_id,
 segment, 
 count(*) over(partition by segment) as seg_cnt 
from users us )
select distinct 
  segment, 
   seg_cnt, 
   count( us.user_id) over(partition by segment) as user_book_cnt 
 from user_Segment us 
 join bookings bk 
 	on bk.user_id = us.user_id 
  where to_char(booking_date, 'YYYY-MM') = '2022-04'
   and booking_type = 'flight';
   
SELECT 
    u.segment,
    COUNT(DISTINCT u.user_id) AS total_users,   -- total users in segment
    COUNT(DISTINCT CASE 
                      WHEN b.booking_type = 'flight' 
                       AND DATE_TRUNC('month', b.booking_date) = DATE '2022-04-01' 
                    THEN u.user_id END) AS users_with_flight_in_april
FROM users u
left JOIN bookings b 
       ON u.user_id = b.user_id
GROUP BY u.segment
ORDER BY u.segment;

select 
  user_id, user_name
 from (SELECT 
    u.user_id,
    user_name,
    booking_type,
    row_number() over(partition by u.user_id order by booking_Date) as rn_book
FROM users u
JOIN bookings b 
       ON u.user_id = b.user_id) t1 
     where rn_book = 1 and  booking_type = 'hotel';
    
    
SELECT user_id, user_name
FROM (
    SELECT DISTINCT ON (u.user_id) 
           u.user_id, 
           u.user_name, 
           b.booking_type, 
           b.booking_date
    FROM users u
    JOIN bookings b 
          ON u.user_id = b.user_id
    ORDER BY u.user_id, b.booking_date
) t
WHERE booking_type = 'hotel';

select * from bookings where user_id = 1 order by booking_date;
-- 
select 21+ 18 + 28 + 31+30+31;
SELECT  max(booking_date) - min(booking_date) as days_bwt_booking  
    FROM users u
    JOIN bookings b 
          ON u.user_id = b.user_id 
    where u.user_id = 1;
   
   
SELECT 
     segment, 
     count(case when to_char(booking_Date, 'YYYY')= '2022' and booking_type = 'flight'
           then b.user_id end) as flight_bkg_ech_segment,
     count(case when to_char(booking_Date, 'YYYY')= '2022' and booking_type = 'hotel'
           then b.user_id end) as hotel_bkg_ech_segment
FROM users u
left JOIN bookings b 
       ON u.user_id = b.user_id
GROUP BY u.segment
ORDER BY u.segment;

SELECT 
     segment, 
     sum(case when EXTRACT(YEAR FROM b.booking_date) = 2022  and booking_type = 'flight'
           then 1 else 0 end) as flight_bkg_ech_segment,
     sum(case when EXTRACT(YEAR FROM b.booking_date) = 2022  and booking_type = 'hotel'
           then 1 else 0 end) as hotel_bkg_ech_segment
FROM users u
left JOIN bookings b 
       ON u.user_id = b.user_id
GROUP BY u.segment ;

select distinct EXTRACT(MONth FROM booking_date)  from bookings;

-- For each segment, find the user who made the earliest booking in April 2022 and how many total bookings they made in that month.
select 
  segment, user_id, total_user as total_booking
 from (select 
  segment, 
  bk.user_id,
  booking_type, booking_Date, 
  count(*) over(partition by segment, us.user_id) as total_user,
  row_number() over(partition by segment order by booking_date) as earliest_booking
 from users us 
 join bookings bk 
  on bk.user_id = us.user_id 
 where EXTRACT(YEAR FROM booking_date)::text || '-' ||
    LPAD(EXTRACT(MONTH FROM booking_date)::text, 2, '0') = '2022-04') t1 
 where t1.earliest_booking = 1;

with partition_src as (
 select 1 as id, 'ram' as name union all
 select 1 as id, 'ramu' as name union all
 select 1 as id, 'ram' as name union all
 select 1 as id, 'rajiv' as name union all
 select 2 as id, 'rekha' as name union all
 select 3 as id, 'rakesh' as name union all
 select 2 as id, 'rrk' as name union all
 select 3 as id, 'rui' as name union all
 select 2 as id, 'rrk' as name union all
 select 3 as id, 'roms' as name union all
 select 2 as id, 'ritu' as name)
select 
  id, name,
  row_number() over(partition by id order by name) as row_num,
  rank() over(partition by id order by name) as rnk,
  dense_rank() over(partition by id order by name) as dns_rnk
 from partition_src;

drop table if exists users cascade;
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  user_name TEXT,
  segment TEXT
);
drop table if exists bookings;
CREATE TABLE bookings (
  booking_id INT PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  booking_type TEXT CHECK (booking_type IN ('flight','hotel')),
  booking_date DATE,
  amount INT
);

INSERT INTO users (user_id, user_name, segment) VALUES
(1, 'Alice', 'A'),
(2, 'Bob', 'A'),
(3, 'Charlie', 'B'),
(4, 'David', 'B'),
(5, 'Eve', 'C');

INSERT INTO bookings (booking_id, user_id, booking_type, booking_date, amount) VALUES
(101, 1, 'flight', '2022-04-01', 5000),
(102, 1, 'hotel',  '2022-04-05', 2000),
(103, 1, 'flight', '2022-05-10', 6000),
(104, 2, 'hotel',  '2022-04-02', 1500),
(105, 2, 'flight', '2022-04-07', 7000),
(106, 3, 'hotel',  '2022-03-25', 3000),
(107, 3, 'hotel',  '2022-04-01', 3500),
(108, 4, 'flight', '2022-04-15', 8000),
(109, 4, 'flight', '2022-04-20', 8200),
(110, 5, 'hotel',  '2022-04-03', 2500);

select * from users;

select * from bookings;
-- Find each user’s earliest and latest booking date using ROW_NUMBER().
select
 user_id , booking_Date 
 from (select 
 users.user_id,
 booking_date,
 row_number() over(partition by users.user_id order by booking_date) as erl_book_dt,
 row_number() over(partition by users.user_id order by booking_date desc) as lst_book_dt
from users 
 join bookings 
  on users.user_id = bookings.user_id ) t1 
 where erl_book_dt = 1 or lst_book_dt =1;

--Show the top 2 spenders (by amount) in each segment using RANK().
select * from (select 
 users.user_id ,
 rank() over(partition by segment order by amount desc) rnk
from users 
 join bookings 
  on users.user_id = bookings.user_id ) t1 
 where rnk <= 2;

SELECT *
FROM (
    SELECT 
        u.user_id,
        u.user_name,
        u.segment,
        SUM(b.amount) AS total_spent,
        RANK() OVER (PARTITION BY u.segment ORDER BY SUM(b.amount) DESC) AS rnk
    FROM users u
    JOIN bookings b
        ON u.user_id = b.user_id
    GROUP BY u.user_id, u.user_name, u.segment
) t
WHERE rnk <= 2
ORDER BY segment, rnk;

CREATE TABLE championships (
    tournament TEXT,
    year INT,
    winner TEXT
);

INSERT INTO championships (tournament, year, winner) VALUES
('Wimbledon', 2021, 'Novak Djokovic'),
('Wimbledon', 2022, 'Novak Djokovic'),
('French Open', 2021, 'Novak Djokovic'),
('French Open', 2022, 'Rafael Nadal'),
('US Open', 2021, 'Daniil Medvedev'),
('US Open', 2022, 'Carlos Alcaraz'),
('Australian Open', 2021, 'Novak Djokovic'),
('Australian Open', 2022, 'Rafael Nadal');

select * from championships;

CREATE TABLE players (
    player_name TEXT
);

INSERT INTO players (player_name) VALUES
('Novak Djokovic'),
('Rafael Nadal'),
('Daniil Medvedev'),
('Carlos Alcaraz'),
('Roger Federer')
returning player_name;  -- hasn’t won any in this dataset

select player_name, 
  count(winner) from players ply
 left join championships chms 
   on ply.player_name = chms.winner
 group by player_name;


