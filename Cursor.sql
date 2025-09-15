select * from customers;

Do $$ 
  declare
  emp_cur cursor for select name from customers;
  v_name customers.name%type;
 begin 
    open emp_cur;
    loop 
	    fetch emp_cur into v_name;
    	exit when not found;
         raise notice 'Employee name is: %', v_name;
    end loop;
    close emp_cur;
 end;
$$ ;

SET client_min_messages = debug1;
SET client_min_messages = notice;
DO $$
DECLARE
  emp_cur CURSOR FOR SELECT name FROM customers; 
  v_name customers.name%TYPE;
BEGIN
  OPEN emp_cur;
  LOOP
    FETCH emp_cur INTO  v_name;
    EXIT WHEN NOT FOUND; 
    RAISE NOTICE '%', v_name;
       EXECUTE format('SELECT %L as name', v_name);
  END LOOP;
  CLOSE emp_cur;
END $$;


create or replace function ref_cursor_fnc ()
returns refcursor as 
$$
 declare 
   cur refcursor;
   begin
   	open cur for select id, name from customers;
    return cur;
   end;
$$ language plpgsql;

begin; 
	select ref_cursor_fnc() as cur;
   fetch 2 from cur;
commit;

create or replace function ref_cursor_fnc(out cur refcursor)
as
$$
begin
   open cur for select id, name from customers;
end;
$$ language plpgsql;
 
begin;
  select ref_cursor_fnc();   
  fetch 2 from ref_cursor_fnc; 
commit;

create or replace function ref_cursor_fnc()
returns refcursor as
$$
declare 
   cur refcursor := 'my_cur';  
begin
   open cur for select id, name from customers;
   return cur;
end;
$$ language plpgsql; 

 
begin;
  select ref_cursor_fnc();   -- opens "my_cur"
  fetch all from my_cur;       -- now it works
commit;


select * from customers;

begin;
declare emp cursor for select * from customers;
fetch 2 from emp;
fetch next from emp;
close emp;
commit;

CREATE TEMP TABLE demo_emps (
    id INT,
    name TEXT
);

INSERT INTO demo_emps VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

select * from demo_emps;

-- Behavior of default cursor 
begin;
declare emp_cur cursor for select * from demo_emps;
fetch 2 from  emp_cur;
close emp_cur;
commit;

fetch 2 from emp_cur; -- : ERROR: cursor "emp_cur" does not exist

-- Behavior of cursor with hold 
begin;
-- Declare holdable cursor
declare emp_cur_hold cursor with hold for select * from demo_emps;
fetch next from  emp_cur_hold;
close emp_cur_hold;
commit;

fetch next from emp_cur_hold;  

-- Savepoint and cursors
begin;
-- Declare holdable cursor
declare emp_cur_1 cursor for select * from customers;
 savepoint f1;
declare emp_cur_2 cursor for select * from demo_emps;
 
rollback to f1;

fetch 1 from emp_cur_1; -- Works (cursor created before savepoint survives)

-- fetch 1 from emp_cur_2;
-- SQL Error [34000]: ERROR: cursor "emp_cur_2" does not exist
commit;
-- Rolling back to a savepoint only removes cursors created after that savepoint.

