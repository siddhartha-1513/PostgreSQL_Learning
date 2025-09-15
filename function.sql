create or replace function divides(a numeric, b numeric)
 returns numeric 
 as 
 $$ 
 begin
 	return a/b;
   exception 
    when division_by_zero then  
    raise notice 'Cannot divide by zero';
    return null;
   
 end;
$$
 language plpgsql;

select divides(5,0);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE
);

create or replace function unique_constraints (email varchar(500))
 returns void as 
 $$
 begin 
	insert into users(email) values ('pseudo_shame@gmail.com');
 	insert into users(email) values (email);
  exception 
  when unique_violation then
    raise warning 'Email already exists';
 end;
 $$
 language plpgsql;

select unique_constraints('Siddhartha.sharma@snapon.com');
-- Message email already exists 


select * from users;

-- Show all messages to the client
SET client_min_messages = DEBUG1;

-- Or to see more detail in logs:
SET log_min_messages = DEBUG1;


DO $$
BEGIN
    RAISE NOTICE 'This is a NOTICE: employee insert process starting';
    RAISE INFO 'This is an INFO: running step 1';
    RAISE WARNING 'This is a WARNING: potential issue detected';
    RAISE DEBUG 'This is a DEBUG message with details';
    RAISE EXCEPTION 'This is an ERROR and will stop execution';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION demo_debug_levels(val integer)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    RAISE DEBUG 'This is a DEBUG message: val= %', val;
    RAISE INFO 'This is an INFO message: val= %', val;
    RAISE NOTICE 'This is a NOTICE: val= %', val;

    IF val < 0 THEN
        RAISE WARNING 'Value is negative: %', val;
    ELSIF val = 0 THEN
        RAISE EXCEPTION 'Value cannot be zero!';
    END IF;
END;
$$;

select demo_debug_levels(-8);

create table public.PRODUCT(
   id serial primary key,
   name varchar(100) unique not  null,
   price numeric not null
);

select * from information_Schema.columns 
 where "columns".table_name = 'product';

alter table product 
alter column price type numeric(10,2);

select * from PRODUCT;

create table if not exists 
  error_log (error_message text, error_hint text, error_details text, error_context text,  error_reported timestamp);

create or replace function add_product(p_name varchar(100), p_price numeric )
returns integer 
as $$
declare 
   error_message text;
   error_details text;
   error_hint text;
   error_context text;
   new_id integer;
begin 
	 insert into product(name, price)
	 values (p_name, p_price)
	 returning id into new_id;
	
	 
    return new_id;
   exception 
     --when unique_violation then 
     	--raise notice 'product name already exists for name %, Insertion canceled.', p_name;
     	--return null;
    -- when NOT_NULL_violation then 
     --	raise notice 'A value required (name or price) is null.';
      --  return null;
     when numeric_value_out_of_range then
        raise notice 'A invalid value % is passed for price.', p_price;
        return null;
     when others then 
        --raise notice 'An unexpected error occured message: %', sqlerrm;
        --return null;
        get STACKED DIAGNOSTICS 
        error_message = MESSAGE_TEXT,
        error_hint = PG_EXCEPTION_HINT,
        error_details = PG_EXCEPTION_DETAIL,
        error_context = PG_EXCEPTION_CONTEXT;
       
       raise notice 'Product added sucessfully for id:';
       insert into error_log (error_message, error_hint, error_details, error_context,  error_reported)
       values (error_message, error_hint, error_details, error_context, now());
      
      raise;

end;
$$ language plpgsql;

select add_product('siddhartha', 106.88);
-- Product added sucessfully for id: 3


select add_product(null, 106.88);
-- A value required (name or price) is null.

select * from product;

select add_product('sidd', 166.99);
-- product name already exists for name sidd, Insertion canceled.

select add_product('pseudo', 166.99888);

select add_product('payal', 199999488366.99888);
-- A invalid value 199999488366.99888 is passed for price.

select add_product('null', null);

select * from error_log;

select * from pg_attrdef;

create or replace function not_returns_fun(var inout int)
-- returns void 
 -- function result type must be integer because of OUT parameters
as 
$$
 begin 
 	select 1 into var;
    raise notice ' function returns % value', var;
    --return var;   -- ❌ NOT ALLOWED (because you already have INOUT)

 	return; -- ✅ just RETURN
 end;  
$$ language plpgsql;

select * from orders;

alter table orders 
add column total numeric; 

insert into orders(id, customer_id, total)
values (1, 5, 55.89), (2, 6, 99.77);

create table orders (id int, customer_id int not null,
                    foreign key (customer_id) references customers (id));
                   
select process_order(1);


CREATE OR REPLACE FUNCTION process_order(p_order_id INT)
RETURNS void AS $$
DECLARE
    order_amount NUMERIC;
    customer_name TEXT;
BEGIN
    -- 1. LOG/DEBUG: Function started (goes to server logs for auditing)
    RAISE LOG 'Function process_order() started for order_id: %', p_order_id;

    -- 2. INFO: Let the client know what's happening
    RAISE INFO 'Fetching order details...';

    -- Get order details
    SELECT total, name INTO order_amount, customer_name
    FROM orders o
    JOIN customers c ON o.customer_id = c.id
    WHERE o.id = p_order_id;

    -- 3. DEBUG: Check the retrieved values (useful for devs)
    RAISE DEBUG 'Order Amount: %, Customer: %', order_amount, customer_name;

    IF order_amount > 1000 THEN
        -- 4. NOTICE: Inform about a special case
        RAISE NOTICE 'Large order (%) detected for customer %', order_amount, customer_name;
    END IF;

    -- Simulate a validation failure
    IF customer_name IS NULL THEN
        -- 5. WARNING: Something is wrong but we can proceed
        RAISE WARNING 'Customer name for order % is NULL. Proceeding anyway.', p_order_id;
    END IF;

    -- ... more processing logic ...

    -- 6. INFO: Function completed successfully
    RAISE INFO 'Order % processed successfully.', p_order_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- 7. This is an error, so we raise an EXCEPTION
        RAISE EXCEPTION 'Order ID % was not found!', p_order_id;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Unexpected error processing order %: %', p_order_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;

drop function immu_func(int);

create or replace function immu_func(val int)
returns time
stable  
as 
$$
 begin 
 	return current_time::time ;
 end; 
$$ language plpgsql;

select current_time::time;
select immu_func(4);

SELECT pg_typeof(current_time);

select * from orders;

select * from customers;

create or replace function testing_func() --p_name varchar(100))
returns int volatile 
as 
$$
  declare 
     out_var customers.id%TYPE;
     x RECORD;
  begin 
	 /* insert into customers(name)
	  values(p_name)
	 returning id into out_var; */
  	 /*select 
  	    id into out_var 
  	   from customers
  	   where name = p_name; 
	return out_var; */ 
	  for x in select 
  	    id , name  
  	   from customers loop
  	  	raise notice 'id is % and name is %', x.id, x.name; 
  	  end loop;
  	return 1;
	exception 
	when no_data_found then 
	 raise notice 'Please provide the valid value of p_name';
	 --raise ;
	 return  null;
	when others then 
	raise info 'the error is % and message is %', sqlcode, sqlerrm;
    return null;

-- return out_var; do not return here 
   	   
  end;
$$ language plpgsql;

select testing_func();

select testing_func('raju');
-- 191966

select * from customers;
-- Yes, even if your function errors out with “control reached end of function without RETURN”,
-- the id was already generated using nextval('customers_id_seq'). That’s why you see gaps.

SELECT last_value FROM customers_id_seq;
-- last_value only updates after at least one successful nextval() call in the session.

SELECT * FROM pg_sequences WHERE schemaname = 'public' AND sequencename = 'customers_id_seq';

select currval('customers_id_seq');
-- 12 
-- ⚠️ This works only after your session has already called nextval() at least once.

select nextval('customers_id_seq');


DO $$
DECLARE
    r RECORD;
    c customers%ROWTYPE;
BEGIN
    -- record: can select any columns
    SELECT id, name INTO r FROM customers LIMIT 1;
    RAISE NOTICE 'rec -> id=%, name=%', r.id, r.name;

    -- %ROWTYPE: must select * (all columns) or exactly match the row type
    SELECT * INTO c FROM customers LIMIT 1;
    RAISE NOTICE 'rowtype -> id=%, name=%', c.id, c.name;
END;
$$;

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN EXECUTE 'SELECT id, name FROM customers WHERE id < 5' LOOP
        RAISE NOTICE 'row: id=%, name=%', rec.id, rec.name;
    END LOOP;

    FOR rec IN EXECUTE 'SELECT id, total FROM orders WHERE total > 100' LOOP
        RAISE NOTICE 'row: order_id=%, amount=%', rec.id, rec.total;
    END LOOP;
END;
$$;
-- 👉 Same rec works for both queries, even though columns differ (id,name vs order_id,amount).


-- foreach in array
do 
$$
declare 
   fruits text[] := ARRAY['banana', 'apple', 'mango'];
   f text;
  begin
  	--for f in array fruits
  	--: ERROR: syntax error at or near "array"
	foreach f in array fruits
  	  loop
  	  	 raise notice 'fruit: %',f;
  	  end loop;
  end;
$$ language plpgsql;


do 
$$
 declare 
   num int[] := Array[10, 11, 15];
    n int;
    total int :=0;
    begin
    	 foreach n in array num loop
    	 	total := total + n;
    	 end loop;
     raise notice 'sum value for total is: %', total;
    end;
$$ language plpgsql;

-- multidimensional array 
do 
$$
declare
  matrix int[][] := '{{1,2,3}, {3,4,5}, {4,5,6}}';
  -- elem int;
 -- That means "scalar integer". But PostgreSQL is trying to assign {1,2,3} (an array) into it → type mismatch 
 -- → hence the error "SLICE loop variable must be of an array type"
 elem int[];
 begin
 	foreach elem SLICE 1 in array matrix 
 	loop
 		raise notice 'elem = %', elem;
 	end loop;
 	
 end;
$$ language plpgsql;
-- Your error came because you declared elem int, but with SLICE 1, PostgreSQL delivers int[]. 
-- So you must declare elem int[] when using SLICE 1.

 
create table if not exists post_tag(
 id serial primary key,
 post_id int,
 post_tag text
);

create or replace function post_tag_insert( p_post_id int, post_tag text)
 returns int volatile
 as   
 $$
   declare 
   tag_text text[];
   tag text;
   post_tag_id int;
  begin
  	
	  tag_text := string_to_array(post_tag, ',');
	  foreach tag in array tag_text loop
	  	 insert into post_tag(post_id,post_tag)
	  	 values (p_post_id, trim(tag))
	  	 returning id into post_tag_id;
	  	raise notice 'post tag id= %', post_tag_id;
	  end loop;
	  return null;
  end;
 $$ language plpgsql;
 -- ERROR: type post_id does not exist
 -- ERROR: syntax error at or near "tag" Position: 244

select post_tag_insert(101, 'postgres,plpgsql, array,foreach,slice');
-- drop table if exists post_tag;
select * from post_tag;

-- RETURN QUERY 
create or replace function return_query_fnc ()
returns setof int 
as 
$$
 begin 
 	return query select generate_series(1,5);
    return query select generate_series(5,10);
 end;
$$ language plpgsql;

select return_query_fnc();

create or replace function query_next()
returns setof int
as 
$$
 begin 
 	for i in 1..5 loop
 		return next i;
 	end loop;
 end;
$$ language plpgsql;

select query_next();

create or replace function return_next_table()
returns table(id int, val text) 
as 
$$
  declare 
    i int;
   begin
	   for i in 1..5 loop
		   id := i;
		   val := 'value is ' || i;
	   	 return next ;
	   	--return next (i, 'value is: ' || i);
	   	-- ERROR: RETURN NEXT cannot have a parameter in function with OUT parameters
	   end loop;
   end; 
$$ language plpgsql;

select return_next_table();

create type my_type as (id int, val text);

create or replace function return_next_record()
returns setof my_type 
as 
$$
   declare i int;
  begin
	  for i in 1..8 loop
	  	return next(i, 'value is '|| i);
	  end loop;
  end;
  
$$ language plpgsql;


select return_next_record();

create or replace function my_void_func()
returns void 
as 
$$
 declare i int;
begin 
	select 1 into i;
end;
$$ language plpgsql;

select my_void_func(); 
-- return nothing 

select * from orders;


drop function if exists dynamic_func(int, text, text);
create or replace function dynamic_func(p_id int, p_table text, p_column text)
returns int 
as 
$$
 declare
  out_id int;
 begin 
 	execute format('select %I from %I where id = %L', p_column, p_table, p_id) into out_id;
   return out_id;
 end;
$$ language plpgsql;

select dynamic_func(1, 'orders', 'customer_id');

select * from customers;

create or replace function return_tbl_fnc(in p_id int)
returns table (id int, name text)
as 
$$
 declare out_id int;
   p_name text;
  begin
	  execute format('select id, name  from customers where id = %s', p_id) into out_id, p_name;
	 id := out_id;
	 name := p_name;
	  return next;
  end;
  
$$ language plpgsql;

select return_tbl_fnc(9);





