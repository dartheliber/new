--Use subquery to delete duplicate rows

--Here we see an example of using SQL to delete duplicate table rows using an SQL subquery to identify duplicate rows, 
--manually specifying the join columns:

DELETE FROM 
   table_name A
WHERE 
  a.rowid > 
   ANY (
     SELECT 
        B.rowid
     FROM 
        table_name B
     WHERE 
        A.col1 = B.col1
     AND 
        A.col2 = B.col2
        );

--Use RANK to delete duplicate rows

--This is an example of the RANK function to identify and remove duplicate rows from Oracle tables, 
--which deletes all duplicate rows while leaving the initial instance of the duplicate row:

delete from $table_name where rowid in
  (
  select "rowid" from
     (select "rowid", rank_n from
         (select rank() over (partition by $primary_key order by rowid) rank_n, rowid as "rowid"
             from $table_name
             where $primary_key in
                (select $primary_key from $table_name
                  group by $all_columns
                  having count(*) > 1
                )
             )
         )
     where rank_n > 1
  )
/*One of the most important features of Oracle is the ability to detect and remove duplicate rows from a table. 
While many Oracle DBA place primary key referential integrity constraints on a table, 
many shops do not use RI because they need the flexibility
Use self-join to delete duplicate rows

The most effective way to detect duplicate rows is to join the table against itself as shown below.*/

select 
   book_unique_id, 
   page_seq_nbr, 
   image_key 
from 
   page_image a 
where 
   rowid > 
     (select min(rowid) from page_image b 
      where 
         b.key1 = a.key1 
      and 
         b.key2 = a.key2 
      and 
         b.key3 = a.key3 
      );



--Please note that you must specify all of the columns that make the row a duplicate in the SQL where clause. 
--Once you have detected the duplicate rows, you may modify the SQL statement to remove the duplicates as shown below:

delete from 
   table_name a
where 
   a.rowid > 
   any (select b.rowid
   from 
      table_name b
   where 
      a.col1 = b.col1
   and 
      a.col2 = b.col2
   )
;

--Use analytics to delete duplicate rows

--You can also detect and delete duplicate rows using Oracle analytic functions:



delete from 
   customer
where rowid in
 (select rowid from 
   (select 
     rowid,
     row_number()
    over 
     (partition by custnbr order by custnbr) dup
    from customer)
  where dup > 1);



--As we see, there are several ways to detect and delete duplicate rows from Oracle tables


/*Reader Comments:

Removing duplicate table rows where rows have NULL values
Rob Arden states:  The tip on this page helped with removing duplicate rows from Oracle tables. 
I thought this might be useful so I'm passing it on: I needed to add a null check because this fails 
to remove dupe rows where the fields match on a null value.  So instead of the given:*/

delete from 
   table_name a
where 
   a.rowid > 
   any (select b.rowid
   from 
      table_name b
   where 
      a.col1 = b.col1
   and 
      a.col2 = b.col2
   )
;



--I needed to do the following to remove all of the duplicate table rows: 



delete from 
   table_name a
where 
   a.rowid > 
   any (select b.rowid
   from 
      table_name b
   where 
      (a.col1 = b.col1 or (a.col1 is null and b.col1 is null))
   and 
      (a.col2 = b.col2 or (a.col2 is null and b.col2 is null))
   )
;	  