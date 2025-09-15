select * from employee;

alter table employee 
  drop column salary;

Alter table employee 
 add column salary numeric not null default 100000.00;
 
select * from employee;

create table salary_audit(
   emp_id int, 
   old_sal numeric, 
   new_sal numeric, 
  changed_at timestamp);

create or replace function tri_sal_upd()
 returns trigger as 
$$ 
  begin
    insert into salary_audit(emp_id, old_sal, new_sal, changed_at)
    values (old.employee_id, old.salary, new.salary, now());
   return new;
  end;
$$ language plpgsql;

create trigger salary_update
after update of salary on employee
for each row execute function tri_sal_upd();

update employee 
set salary = 150000.00
where employee_id = 7;

create or replace function tri_sal_reduction_hr()
returns trigger as 
$$
 begin 
 	 if new.salary < old.salary then 
 	  if new.approved_by_hr is distinct from true then 
 	    raise exception 'New Salary is less than old salary and HR does not approved. No UPDATE.';
 	   end if;
 	  end if;
 	 RETURN NEW;
 end;
 
$$ language plpgsql;

create trigger hr_approved_Reduction
before update of salary on employee 
for each row  
execute function tri_sal_reduction_hr() ;

Alter table employee 
 add column approved_by_hr boolean not null default false;

update employee 
set salary = 130000.00, approved_by_hr = false
where employee_id = 7;
/*
 * SQL Error [P0001]: ERROR: New Salary is less than old salary and HR does not approved. No UPDATE.
  Where: PL/pgSQL function tri_sal_reduction_hr() line 5 at RAISE
 */

update employee 
set salary = 130000.00, 
where employee_id = 3;
-- succesfully update as new sal is higher than old sal

update employee 
set salary = 70000.00, approved_by_hr = TRUE
where employee_id = 1;

select * from salary_audit;

select * from pg_trigger;


