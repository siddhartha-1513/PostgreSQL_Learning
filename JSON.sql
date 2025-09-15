--JSON 
select '1'::jsonb;
select '"1"'::jsonb;

select '"hello"'::jsonb;

select '{"a":1, "2": "hello", "a":1}'::json;
-- {"a":1, "2": "hello", "a":1}
-- order is maintained in json object
select '{"a":1, "2": "hello", "a":1}'::jsonb;
--{"2": "hello", "a": 1}

drop table if exists json_table;
create table json_table(object_id serial primary key,
                      json_object jsonb);
                      
insert into json_table(json_object)
values ('{"object_id": {"1": {"Employee": ["Siddhartha","mohan", "ramesh", "prateek"], "age": [31, 25, 26, 28],
"department": ["IT", "Teacher", "Doctor", "Architect"]}, "2": {"Student": ["rahul", "jyoti"], "Marks": [25, 35]}}}');


insert into json_table(json_object)
values ('{"object_id": {"3": {"Employee_name": ["pseudo","sidd", "sony", "gayendra"], "age": [32, 26, 27, 68],
"department": ["non-it", "politican", "mechanic", "Architect"]}, "4": {"Student": ["raj", "jai"], "Marks": [23, 33]}}}');

select json_object->"object_id" from json_table;
-- NULL 

select json_object->>"object_id" from json_table;
-- NULL

select json_object->>'object_id' from json_table;
-- {"1": {"Employee": ["Siddhartha","mohan", "ramesh", "prateek"], "age": [31, 25, 26, 28], "department": ["IT", "Teacher", "Doctor", "Architect"]}, "2": {"Student": ["rahul", "jyoti"], "Marks": [25, 35]}}

select * from json_table;
select json_object->'object_id'->'3'->>'department' from json_table;


delete from json_table 
where object_id = 1;


insert into json_table(json_object)
values ('{"Employee": ["Siddhartha","mohan", "ramesh", "prateek"], "age": [31, 25, 26, 28],
"department": ["IT", "Teacher", "Doctor", "Architect"]}');

insert into json_table(json_object)
values ('{"Employee": ["pseudo","mayank", "raj", "rakesh"], "age": [35, 65, 56, 58],
"department": ["IT", "Technician", "carpenter", "Sale Deed"]}');

select string_to_array(json_object->>'department', ',') from json_table;

select ((json_object->>'department'):: text[])[2] from json_table;
/*
 * Error: SQL Error [22P02]: ERROR: malformed array literal: "["IT", "Teacher", "Doctor", "Architect"]"
  Detail: "[" must introduce explicitly-specified array dimensions
  */


select json_object->'department' department_json,
  json_object->'department'->>1 as department_val 
 from json_table;

-- 🔄 Convert JSON array to SQL array
select array(
  select json_array_elements_text(json_object->'department'))
  from json_table;
 
 drop table if exists json_employee;
 create table json_employee (
 employee_id serial primary key,
 json_employee json);

insert into json_employee(json_employee)
values ('{"EmployeeName": "Siddhartha", "EmployeeDetails": {"Department": "IT", "Designation": "Manager", "Salary": 150000.00}}');
 
insert into json_employee(json_employee)
values ('{"EmployeeName": "Pseudo", "EmployeeDetails": {"Department": "AI", "Designation": "Lead", "Salary": 1500000.00}}'),
 ('{"EmployeeName": "Rajiv", "EmployeeDetails": {"Department": "AI", "Designation": "Trainee", "Salary": 1300000.00}}'),
 ('{"EmployeeName": "Rohan", "EmployeeDetails": {"Department": "AI", "Designation": "QA", "Salary": 100000.00}}');

select * from json_employee;

select json_employee->>'EmployeeName' as emp_name,
       cast(cast(json_employee->'EmployeeDetails'->>'Salary' as numeric) as int) as emp_sal,
       json_employee->'EmployeeDetails'->>'Designation' as emp_desg,
       json_employee->'EmployeeDetails'->>'Department' as emp_dep
      from json_employee;
/*
    Siddhartha	150000.00	Manager	IT
	Pseudo		1500000.00	Lead	AI
	Rajiv		1300000.00	Trainee	AI
	Rohan		100000.00	QA		AI
*/
     
select 
   sum((json_employee->'EmployeeDetails'->>'Salary')::numeric::int) as sum_salary,
   avg((json_employee->'EmployeeDetails'->>'Salary')::numeric::int) as avg_salary,
   max((json_employee->'EmployeeDetails'->>'Salary')::numeric::int) as max_salary,
   min((json_employee->'EmployeeDetails'->>'Salary')::numeric::int) as min_salary
 from json_employee;

-- JSON_EACH: It expands the outermost JSON object into a set of key-value pairs.
select 
     json_each(json_employee->'EmployeeDetails') as key_val_pair
 from json_employee;
-- Distinct : Error
  -- SQL Error [42883]: ERROR: could not identify a comparison function for type json
select 
   json_each_text(json_employee) as key_val_pair
 from json_employee;
    
-- json_object_keys: It provides a set of keys in the outermost JSON object.
select 
   distinct json_object_keys(json_employee) as key_val_pair
 from json_employee;
  
select 
   distinct json_object_keys(json_employee->'EmployeeDetails') as key_val_pair
 from json_employee;

select distinct json_typeof(json_employee->'EmployeeDetails'->'Salary') as val_type
  from json_employee;
 -- Deparment: stirng 
 -- Salary: number
 
select '120e-5'::jsonb;

select '{"reading": 120e-6}'::json as json_val, '{"reading": 120e-6}'::jsonb as jsonb_val;
-- {"reading": 120e-6}	{"reading": 0.000120}
-- jsonb will preserve trailing fractional zeroes

select '"foo"'::jsonb @> '"foo"'::jsonb;
-- true 

-- checking array on right side is contained within the one on the left side.
select '[1,3,4]'::jsonb @> '[1,3]'::jsonb;
-- true 

--duplicate and order is not matter, so it is ignore 
select '[1,3,4]'::jsonb @> '[3,1,3]'::jsonb;
-- true 

--select '[1,3,4]'::json @> '[3,1,3]'::json;
-- ERROR: operator does not exist: json @> json
-- No operator matches the given name and argument types. You might need to add explicit

-- The object with a single pair on the right side is contained
-- within the object on the left side
select '{"foo": {"bar": "baz"}, "version": "postgres 9.4"}'::jsonb @> '{"version" : "postgres 9.4"}'::jsonb;
-- true 

-- Similarly, containment is not reported here:
select '{"foo": {"bar": "baz"}, "version": "postgres 9.4"}'::jsonb @> '{"bar": "baz"}'::jsonb;
-- false 
-- It requires same nesting level, as object {"bar": "baz"} is under foo in the containing object but it is top level key 
-- in the contained object.


select '{"foo": {"bar": "baz"}, "version": "postgres 9.4"}'::jsonb @> '{"foo": {}}'::jsonb;
-- true 
-- { "foo": { "bar": "baz" } } @> { "foo": {} } is true (superset match).
-- The left side has "foo": {"bar":"baz"}, which is a superset of {}.
-- So containment succeeds.

SELECT '["foo", "bar"]'::jsonb @> '"bar"'::jsonb;
-- true 

-- This array contains the primitive string value:
select '["foo", "bar","baz"]'::jsonb @> '"bar"'::jsonb;
--true 

-- This exception is not reciprocal -- non-containment is reported here:
select '"bar"'::jsonb @>  '["foo", "bar","baz"]'::jsonb ;
-- false 

-- Existence operator (?)

-- String exists as array element:
select '["foo", "bar", "baz"]'::jsonb ? 'bar';
-- true 

-- String exists as object key:
select '{"foo": {"bar": "baz"}, "version": "postgres 9.4"}'::jsonb ? 'foo';
-- true 

-- object value are not consider 
select '{"foo": {"bar": "baz"}, "version": "postgres 9.4"}'::jsonb ? 'postgres 9.4';
-- false 

-- As with containment, existence must match at the top level:
select '{"foo": {"bar": "baz"}, "version": "postgres 9.4"}'::jsonb ? 'bar';
-- false 

-- A string is considered to exist if it matches a primitive JSON string:
SELECT '"foo"'::jsonb ? 'foo';

-- Extract array element by index
select ('[1,2,3,4,6,1,2]'::jsonb)[5];
-- 1 as result 

select ('[1,2,3,4,6,1,2]'::json)[5];
-- Error:SQL Error [42804]: ERROR: cannot subscript type json because it does not support subscripting

-- Extract object value by key
select ('{"a": 5}'::jsonb)['a'];
-- 5 

select ('{"a": {"b": {"c": 5}}}'::jsonb)['a'];
-- {"b": {"c": 5}}

-- Extract nested object value by key path
select ('{"a": {"b": {"c": 5}}}'::jsonb)['a']['b']['c'];
-- 5 value

select  * , json_object['Employee'][2]    from json_table;

-- Update object value by key. Note the assigned
-- value must be of the jsonb type as well
update json_table 
set json_object['Employee'][2] = '"ravikant"'
where object_id = 2;

-- Filter records using a WHERE clause with subscripting. Since the result of
-- subscripting is jsonb, the value we compare it against must also be jsonb.
-- The double quotes make "value" also a valid jsonb string.
select  *  from json_table
where json_object['Employee'][2] = '"ravikant"';

SELECT '{"name": "Siddhartha", "age": 31}'::jsonb->>'name';



with json_type as (
select 
'{"employee": {"name": "Siddhartha", "age": 31, "department": {"name": "IT", "location": "Delhi"}}}'::jsonb as json_val
) 
select 
  json_val #>> '{employee, department, location}'
from json_type;
-- json_val #> '{employee, department, location}' --> "Delhi"
-- json_val #>> '{employee, department, location}' --> Delhi

-- jsonb_array_elements function
SELECT jsonb_array_elements('[1,2,3,4]'::jsonb);
-- jsonb elements

-- remove a key value using key 
select '{"a":1, "b":2}'::jsonb - 'a';

select '[{"a": "1"}, {"b": "2"}, {"c": "5"}]'::json->1;

with json_cte as 
(select 
 '{"user": "siddhartha", "action": "login", "device": {"type": "mobile", "os": "android"}}'::json as json_val
 union all
 select  '{"user": "siddhartha", "action": "login", "device": {"type": "mobile", "os": "window"}}'::json as json_val) 
 select * from json_cte
  where json_val->'device'->>'os' = 'android';








