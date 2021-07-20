6.  More on JOIN
----------------

6.1  INNER JOIN
***************

In an inner join of two tables, 
each row of the first table is combined (joined) with every row of second table. 
Suppose that there are n1 rows in the first table and n2 rows in the second table, 
INNER JOIN produces all combinations of n1×n2 rows - it is known as Cartesian Product or Cross Product.

Example
-------

DROP TABLE IF EXISTS t1, t2;
CREATE TABLE t1 (
          id      INT PRIMARY KEY,
          `desc`  VARCHAR(30)
       );
-- `desc` is a reserved word - must be back-quoted
CREATE TABLE t2 (
          id      INT PRIMARY KEY,
          `desc`  VARCHAR(30)
       );

INSERT INTO t1 VALUES
         (1, 'ID 1 in t1'),
         (2, 'ID 2 in t1'),
         (3, 'ID 3 in t1');
INSERT INTO t2 VALUES
         (2, 'ID 2 in t2'),
         (3, 'ID 3 in t2'),
         (4, 'ID 4 in t2');

SELECT * FROM t1;
SELECT * FROM t2;

SELECT * 
       FROM t1 INNER JOIN t2;
-- SELECT all columns in t1 and t2 (*)
-- INNER JOIN produces ALL combinations of rows in t1 and t2

You can impose constrain by using the ON clause, for example,

SELECT *
       FROM t1 INNER JOIN t2 ON t1.id = t2.id;

Take note that the following are equivalent:

SELECT *
       FROM t1 INNER JOIN t2 ON t1.id = t2.id;

SELECT *
       FROM t1 JOIN t2 ON t1.id = t2.id;        -- default JOIN is INNER JOIN

SELECT *
       FROM t1 CROSS JOIN t2 ON t1.id = t2.id;  -- Also called CROSS JOIN

-- You can use USING clause if the join-columns have the same name

SELECT *
       FROM t1 INNER JOIN t2 USING (id);
   -- Only 3 columns in the result set, instead of 4 columns with ON clause

SELECT *
       FROM t1 INNER JOIN t2 WHERE t1.id = t2.id;  -- Use WHERE instead of ON

SELECT *
       FROM t1, t2 WHERE t1.id = t2.id;            -- Use "commas" operator to join

*******************************************
6.2  OUTER JOIN - LEFT JOIN and RIGHT JOIN
*******************************************

INNER JOIN with constrain (ON or USING) produces rows that are found in both tables. 
On the other hand, OUTER JOIN can produce rows that are in one table, but not in another table. 
There are two kinds of OUTER JOINs: 
	LEFT JOIN produces rows that are in the left table, but may not in the right table; 
	whereas 
	RIGHT JOIN produces rows that are in the right table but may not in the left table.

In a LEFT JOIN, 
	when a row in the left table does not match with the right table, it is still selected 
	but by combining with a "fake" record of all NULLs for the right table.

SELECT *
       FROM t1 LEFT JOIN t2 ON t1.id = t2.id;

SELECT *
       FROM t1 LEFT JOIN t2 USING (id);

SELECT *
       FROM t1 RIGHT JOIN t2 ON t1.id = t2.id;

SELECT *
       FROM t1 RIGHT JOIN t2 USING (id);

As the result, LEFT JOIN ensures that the result set contains every row on the left table.
This is important, as in some queries, you are interested to have result on every row on the left table, 
with no match in the right table, e.g., searching for items without supplier. 

For example,

SELECT t1.id, t1.desc
       FROM t1 LEFT JOIN t2 USING (id)
       WHERE t2.id IS NULL;

Take note that the followings are equivalent:

SELECT *
       FROM t1 LEFT JOIN t2 ON t1.id = t2.id;

SELECT *
       FROM t1 LEFT OUTER JOIN t2 ON t1.id = t2.id;

SELECT *
       FROM t1 LEFT JOIN t2 USING (id);  -- join-columns have same name

-- WHERE clause CANNOT be used on OUTER JOIN

SELECT *
       FROM t1 LEFT JOIN t2 WHERE t1.id = t2.id;










