-- Database-Level
DROP DATABASE databaseName                 -- Delete the database (irrecoverable!)
DROP DATABASE IF EXISTS databaseName       -- Delete if it exists
CREATE DATABASE databaseName               -- Create a new database
CREATE DATABASE IF NOT EXISTS databaseName -- Create only if it does not exists
SHOW DATABASES                             -- Show all the databases in this server
USE databaseName                           -- Set the default (current) database
SELECT DATABASE()                          -- Show the default database
SHOW CREATE DATABASE databaseName          -- Show the CREATE DATABASE statement

-- Table-Level
DROP TABLE [IF EXISTS] tableName, ...
CREATE TABLE [IF NOT EXISTS] tableName (
   columnName columnType columnAttribute, ...
   PRIMARY KEY(columnName),
   FOREIGN KEY (columnName) REFERENCES tableName (columnName)
)

SHOW TABLES                -- Show all the tables in the default database
DESCRIBE|DESC tableName    -- Describe the details for a table
ALTER TABLE tableName ...  -- Modify a table, e.g., ADD COLUMN and DROP COLUMN
ALTER TABLE tableName ADD columnDefinition
ALTER TABLE tableName DROP columnName
ALTER TABLE tableName ADD FOREIGN KEY (columnName) REFERENCES tableName (columnName)
ALTER TABLE tableName DROP FOREIGN KEY constraintName
SHOW CREATE TABLE tableName        -- Show the CREATE TABLE statement for this tableName


-- Row-Level
INSERT INTO tableName 
   VALUES (column1Value, column2Value,...)               -- Insert on all Columns
INSERT INTO tableName 
   VALUES (column1Value, column2Value,...), ...          -- Insert multiple rows
INSERT INTO tableName (column1Name, ..., columnNName)
   VALUES (column1Value, ..., columnNValue)              -- Insert on selected Columns
DELETE FROM tableName WHERE criteria
UPDATE tableName SET columnName = expr, ... WHERE criteria
SELECT * | column1Name AS alias1, ..., columnNName AS aliasN 
   FROM tableName
   WHERE criteria
   GROUP BY columnName
   ORDER BY columnName ASC|DESC, ...
   HAVING groupConstraints
   LIMIT count | offset count

-- Others
SHOW WARNINGS;   -- Show the warnings of the previous statement
/*
2.  An Example for the Beginners (But NOT for the dummies)

A MySQL database server contains many databases (or schemas). Each database consists of one or more tables. A table is made up of columns (or fields) and rows (records).
The SQL keywords and commands are NOT case-sensitive.
For clarity, they are shown in uppercase. 
The names or identifiers (database names, table names, column names, etc.) are case-sensitive in some systems, but not in other systems. Hence, it is best to treat identifiers as case-sensitive.
*/
SHOW DATABASES

--You can use SHOW DATABASES to list all the existing databases in the server.

SHOW DATABASES;
/*
The databases "mysql", "information_schema" and "performance_schema" are system databases used internally by MySQL. A "test" database is provided during installation for your testing.

Let us begin with a simple example - a product sales database.
A product sales database typically consists of many tables, e.g., products, customers, suppliers, orders, payments, employees, among others.
Let's call our database "southwind"'


We shall begin with the first table called "products" with the following columns (having data types as indicated) and rows:
*/

/*
2.1  Creating and Deleting a Database - CREATE DATABASE and DROP DATABASE
----------------------------------------------------------------------------
You can create a new database using SQL command "CREATE DATABASE databaseName"; 
and delete a database using "DROP DATABASE databaseName". 
You could optionally apply condition "IF EXISTS" or "IF NOT EXISTS" to these commands. For example,
*/
CREATE DATABASE southwind;
DROP DATABASE southwind;
CREATE DATABASE IF NOT EXISTS southwind;
DROP DATABASE IF EXISTS southwind;

/*
IMPORTANT: Use SQL DROP (and DELETE) commands with extreme care, as the deleted entities are irrecoverable. THERE IS NO UNDO!!!
*/
SHOW CREATE DATABASE
/*
The CREATE DATABASE commands uses some defaults. 
You can issue a "SHOW CREATE DATABASE databaseName" to display the full command and check these default values. 
We use \G (instead of ';') to display the results vertically. (Try comparing the outputs produced by ';' and \G.)
*/
CREATE DATABASE IF NOT EXISTS southwind;
SHOW CREATE DATABASE southwind \G

/**
2.2  Setting the Default Database - USE
*/

--The command "USE databaseName" sets a particular database as the default (or current) database.
/*
You can reference a table in the default database using tableName directly. 
But you need to use the fully-qualified databaseName.tableName to reference a table NOT in the default database.
In our example, we have a database named "southwind" with a table named "products". 

If we issue "USE southwind" to set southwind as the default database,
we can simply call the table as "products". Otherwise, we need to reference the table as "southwind.products".
To display the current default database, issue command "SELECT DATABASE()".
*/

-- 2.3  Creating and Deleting a Table - CREATE TABLE and DROP TABLE

/*
You can create a new table in the default database using command 
"CREATE TABLE tableName" 
and "DROP TABLE tableName". You can also apply condition "IF EXISTS" or "IF NOT EXISTS". 
To create a table, you need to define all its columns, by providing the columns' name, type, and attributes.
*/

-- Let's create a table "products" in our database "southwind".

-- Remove the database "southwind", if it exists.
-- Beware that DROP (and DELETE) actions are irreversible and not recoverable!
DROP DATABASE IF EXISTS southwind;
-- Create the database "southwind"
CREATE DATABASE southwind;
-- Show all the databases in the server
--   to confirm that "southwind" database has been created.
SHOW DATABASES;
-- Set "southwind" as the default database so as to reference its table directly.
USE southwind;
-- Show the current (default) database
SELECT DATABASE();

-- Show all the tables in the current database.
-- "southwind" has no table (empty set).
SHOW TABLES;
-- Create the table "products". Read "explanations" below for the column defintions
CREATE TABLE IF NOT EXISTS products (
	        productID    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
	        productCode  CHAR(3)       NOT NULL DEFAULT '',
	        name         VARCHAR(30)   NOT NULL DEFAULT '',
	        quantity     INT UNSIGNED  NOT NULL DEFAULT 0,
	        price        DECIMAL(7,2)  NOT NULL DEFAULT 99999.99,
	        PRIMARY KEY  (productID)
);

-- Show all the tables to confirm that the "products" table has been created
SHOW TABLES;

-- Describe the fields (columns) of the "products" table
DESCRIBE products;
-- Show the complete CREATE TABLE statement used by MySQL to create this table
SHOW CREATE TABLE products \G

/**
Explanations

We define 5 columns in the table products: productID, productCode, name, quantity and price. The types are:

productID is INT UNSIGNED - non-negative integers.
productCode is CHAR(3) - a fixed-length alphanumeric string of 3 characters.
name is VARCHAR(30) - a variable-length string of up to 30 characters.
	We use fixed-length string for productCode, as we assume that the productCode contains exactly 3 characters. On the other hand, we use variable-length string for name, as its length varies - VARCHAR is more efficient than CHAR.
quantity is also INT UNSIGNED (non-negative integers).
price is DECIMAL(10,2) - a decimal number with 2 decimal places.
DECIMAL is precise (represented as integer with a fix decimal point). On the other hand, FLOAT and DOUBLE (real numbers) are not precise and are approximated. DECIMAL type is recommended for currency.

The attribute "NOT NULL" specifies that the column cannot contain the NULL value.
NULL is a special value indicating "no value", "unknown value" or "missing value".
In our case, these columns shall have a proper value. We also set the default value of the columns. 
The column will take on its default value, if no value is specified during the record creation.

We set the column productID as the so-called primary key.
Values of the primary-key column must be unique. 
Every table shall contain a primary key. 
This ensures that every row can be distinguished from other rows. 
You can specify a single column or a set of columns (e.g., firstName and lastName) as the primary key.
An index is build automatically on the primary-key column to facilitate fast search. 
Primary key is also used as reference by other tables.

We set the column productID to AUTO_INCREMENT. with default starting value of 1. 
When you insert a row with NULL (recommended) (or 0, or a missing value) for the AUTO_INCREMENT column, the maximum value of that column plus 1 would be inserted. 
You can also insert a valid value to an AUTO_INCREMENT column, bypassing the auto-increment.
*/

--2.4  Inserting Rows - INSERT INTO

/**
 Let's fill up our "products" table with rows.
 We set the productID of the first record to 1001, and use AUTO_INCREMENT for the rest of records by inserting a NULL,
 or with a missing column value.
 Take note that strings must be enclosed with a pair of single quotes (or double quotes).
*/

-- Insert a row with all the column values
INSERT INTO products VALUES (1001, 'PEN', 'Pen Red', 5000, 1.23);

-- Insert multiple rows in one command
-- Inserting NULL to the auto_increment column results in max_value + 1
INSERT INTO products VALUES
	(NULL, 'PEN', 'Pen Blue',  8000, 1.25),
	(NULL, 'PEN', 'Pen Black', 2000, 1.25);

-- Insert value to selected columns
-- Missing value for the auto_increment column also results in max_value + 1
INSERT INTO products (productCode, name, quantity, price) VALUES
	('PEC', 'Pencil 2B', 10000, 0.48),
	('PEC', 'Pencil 2H', 8000, 0.49);

-- Missing columns get their default values
INSERT INTO products (productCode, name) VALUES ('PEC', 'Pencil HB');

-- 2nd column (productCode) is defined to be NOT NULL
INSERT INTO products values (NULL, NULL, NULL, NULL, NULL);
-- ERROR 1048 (23000): Column 'productCode' cannot be null

-- Query the table
SELECT * FROM products;

-- Remove the last row
DELETE FROM products WHERE productID = 1006;


-- INSERT INTO Syntax
-- **********************
/*
We can use the INSERT INTO statement to insert a new row with all the column values, using the following syntax:
INSERT INTO tableName VALUES (firstColumnValue, ..., lastColumnValue)  -- All columns
You need to list the values in the same order in which the columns are defined in the CREATE TABLE
separated by commas.

For columns of string data type (CHAR, VARCHAR), enclosed the value with a pair of single quotes (or double quotes).
For columns of numeric data type (INT, DECIMAL, FLOAT, DOUBLE), simply place the number.

You can also insert multiple rows in one INSERT INTO statement:

INSERT INTO tableName VALUES 
	   (row1FirstColumnValue, ..., row1lastColumnValue),
	   (row2FirstColumnValue, ..., row2lastColumnValue), 
		...
		);
To insert a row with values on selected columns only, use:
-- Insert single record with selected columns
INSERT INTO tableName (column1Name, ..., columnNName) VALUES (column1Value, ..., columnNValue)
-- Alternately, use SET to set the values
INSERT INTO tableName SET column1=value1, column2=value2, ...

-- Insert multiple records
INSERT INTO tableName 
   (column1Name, ..., columnNName)
VALUES
   (row1column1Value, ..., row2ColumnNValue),
   (row2column1Value, ..., row2ColumnNValue),
	....

The remaining columns will receive their default value, such as AUTO_INCREMENT, default, or NULL.
*/

-- 2.5  Querying the Database - SELECT

/**
The most common, important and complex task is to query a database for a subset of data that meets your needs - with the SELECT command. 
The SELECT command has the following syntax:
*/
-- List all the rows of the specified columns
SELECT column1Name, column2Name, ... FROM tableName

-- List all the rows of ALL columns, * is a wildcard denoting all columns
SELECT * FROM tableName

-- List rows that meet the specified criteria in WHERE clause
SELECT column1Name, column2Name,... FROM tableName WHERE criteria
SELECT * FROM tableName WHERE criteria


-- For examples,
-- List all rows for the specified columns
SELECT name, price FROM products;

-- List all rows of ALL the columns. The wildcard * denotes ALL columns
SELECT * FROM products;

SELECT without Table
-- You can also issue SELECT without a table. For example, you can SELECT an expression or evaluate a built-in function.
SELECT 1+1;
SELECT NOW();
SELECT 1+1, NOW();

-- Comparison Operators

/*
For numbers (INT, DECIMAL, FLOAT), 
you could use comparison operators: '=' (equal to), '<>' or '!=' (not equal to), '>' (greater than), '<' (less than), '>=' (greater than or equal to), '<=' (less than or equal to),
to compare two numbers. For example, price > 1.0, quantity <= 500.

*/
SELECT name, price FROM products WHERE price < 1.0;
SELECT name, quantity FROM products WHERE quantity <= 2000;

-- Do not compare FLOATs (real numbers) for equality ('=' or '<>'), as they are not precise. On the other hand, DECIMAL are precise.

/**
For strings, you could also use '=', '<>', '>', '<', '>=', '<=' 
to compare two strings (e.g., productCode = 'PEC'). 
The ordering of string depends on the so-called collation chosen. For example,
*/
SELECT name, price FROM products WHERE productCode = 'PEN'; -- String values are quoted

-- String Pattern Matching - LIKE and NOT LIKE

/*
For strings, in addition to full matching using operators like '=' and '<>', 
we can perform pattern matching using operator LIKE (or NOT LIKE) with wildcard characters.

The wildcard '_' matches any single character;
'%' matches any number of characters (including zero).
For Examples,

'abc%' matches strings beginning with 'abc'; startingWith
'%xyz' matches strings ending with 'xyz'; endingWith
'%aaa%' matches strings containing 'aaa'; contains
'___' matches strings containing exactly three characters; and
'a_b%' matches strings beginning with 'a', followed by any single character, followed by 'b', followed by zero or more characters.
*/

-- "name" begins with 'PENCIL'
SELECT name, price FROM products WHERE name LIKE 'PENCIL%';
-- "name" begins with 'P', followed by any two characters, 
--   followed by space, followed by zero or more characters
SELECT name, price FROM products WHERE name LIKE 'P__ %';

--MySQL also support regular expression matching via the REGEXE operator.

--Arithmetic Operators

/*
You can perform arithmetic operations on numeric fields using arithmetic operators, 
as tabulated below:
*/

-- Logical Operators - AND, OR, NOT, XOR
/**
You can combine multiple conditions with boolean operators AND, OR, XOR. 
You can also invert a condition using operator NOT. For examples,
*/
SELECT * FROM products WHERE quantity >= 5000 AND name LIKE 'Pen %';

SELECT * FROM products WHERE quantity >= 5000 AND price < 1.24 AND name LIKE 'Pen %';

SELECT * FROM products WHERE NOT (quantity >= 5000 AND name LIKE 'Pen %');

--IN, NOT IN
/*
You can select from members of a set with IN (or NOT IN) operator. 
This is easier and clearer than the equivalent AND-OR expression.
*/

SELECT * FROM products WHERE name IN ('Pen Red', 'Pen Black');

-- BETWEEN, NOT BETWEEN

-- To check if the value is within a range, you could use BETWEEN ... AND ... operator. 
-- Again, this is easier and clearer than the equivalent AND-OR expression.

SELECT * FROM products 
       WHERE (price BETWEEN 1.0 AND 2.0) AND (quantity BETWEEN 1000 AND 2000);

-- IS NULL, IS NOT NULL

-- NULL is a special value, which represent "no value", "missing value" or "unknown value". 
-- You can checking if a column contains NULL by IS NULL or IS NOT NULL. 
-- For example,
SELECT * FROM products WHERE productCode IS NULL;

SELECT * FROM products WHERE productCode = NULL;
-- This is a common mistake. NULL cannot be compared.

-- ORDER BY Clause

/*
You can order the rows selected using ORDER BY clause, with the following syntax:
SELECT ... FROM tableName
WHERE criteria
ORDER BY columnA ASC|DESC, columnB ASC|DESC, ...

The selected row will be ordered according to the values in columnA, in either ascending (ASC)(default)
or descending (DESC) order.

If several rows have the same value in columnA, it will be ordered according to columnB, and so on. 
For strings, the ordering could be case-sensitive or case-insensitive,
 depending on the so-called character collating sequence used. For examples,

*/

-- Order the results by price in descending order
SELECT * FROM products WHERE name LIKE 'Pen %' ORDER BY price DESC;
-- Order by price in descending order, followed by quantity in ascending (default) order
SELECT * FROM products WHERE name LIKE 'Pen %' ORDER BY price DESC, quantity;

--You can randomize the returned records via function RAND(), e.g.,
SELECT * FROM products ORDER BY RAND();


-- LIMIT Clause

-- A SELECT query on a large database may produce many rows. 
-- You could use the LIMIT clause to limit the number of rows displayed, e.g.,

-- Display the first two rows
SELECT * FROM products ORDER BY price LIMIT 2;

-- To continue to the following records , you could specify the number of rows to be skipped,
-- followed by the number of rows to be displayed in the LIMIT clause, as follows:
-- Skip the first two rows and display the next 1 row
SELECT * FROM products ORDER BY price LIMIT 2, 1;

-- AS - Alias

-- You could use the keyword AS to define an alias for an identifier 
-- (such as column name, table name). The alias will be used in displaying the name. 
-- It can also be used as reference. For example,

SELECT productID AS ID, productCode AS Code,
              name AS Description, price AS `Unit Price`  -- Define aliases to be used as display names
       FROM products
       ORDER BY ID;  -- Use alias ID as reference

-- Take note that the identifier "Unit Price" contains a blank and must be back-quoted.

-- Function CONCAT()

-- You can also concatenate a few columns as one (e.g., joining the last name and first name) using function CONCAT(). For example,
SELECT CONCAT(productCode, ' - ', name) AS `Product Description`, price FROM products;

-- 2.6  Producing Summary Reports
-- ******************************

-- To produce a summary report, we often need to aggregate related rows.

-- DISTINCT
-- A column may have duplicate values, we could use keyword DISTINCT to select only distinct values.
-- We can also apply DISTINCT to several columns to select distinct combinations of these columns. For examples,

-- Without DISTINCT
SELECT price FROM products;

-- With DISTINCT on price
SELECT DISTINCT price AS `Distinct Price` FROM products;

-- DISTINCT combination of price and name
SELECT DISTINCT price, name FROM products;

-- GROUP BY Clause
-- The GROUP BY clause allows you to collapse multiple records with a common value into groups. For example,

SELECT * FROM products ORDER BY productCode, productID;
SELECT * FROM products GROUP BY productCode;
        -- Only first record in each group is shown
-- GROUP BY by itself is not meaningful. It is used together with GROUP BY aggregate functions (such as COUNT(), AVG(), SUM()) to produce group summary.

-- GROUP BY Aggregate Functions: COUNT, MAX, MIN, AVG, SUM, STD, GROUP_CONCAT

/**
We can apply GROUP BY Aggregate functions to each group to produce group summary report.

The function COUNT(*) returns the rows selected; COUNT(columnName) counts only the non-NULL values of the given column. For example,

*/


-- Function COUNT(*) returns the number of rows selected
SELECT COUNT(*) AS `Count` FROM products;
 -- All rows without GROUP BY clause

SELECT productCode, COUNT(*) FROM products GROUP BY productCode;
-- Order by COUNT - need to define an alias to be used as reference
SELECT productCode, COUNT(*) AS count 
       FROM products 
       GROUP BY productCode
       ORDER BY count DESC;

-- Besides COUNT(), there are many other GROUP BY aggregate functions such as AVG(), MAX(), MIN() and SUM(). For example,

SELECT MAX(price), MIN(price), AVG(price), STD(price), SUM(quantity)
       FROM products;
       -- Without GROUP BY - All rows

SELECT productCode, MAX(price) AS `Highest Price`, MIN(price) AS `Lowest Price`
       FROM products
       GROUP BY productCode;

SELECT productCode, MAX(price), MIN(price),
              CAST(AVG(price) AS DECIMAL(7,2)) AS `Average`,
              CAST(STD(price) AS DECIMAL(7,2)) AS `Std Dev`,
              SUM(quantity)
       FROM products
       GROUP BY productCode;
       -- Use CAST(... AS ...) function to format floating-point numbers


-- HAVING clause
-- HAVING is similar to WHERE, but it can operate on the GROUP BY aggregate functions; 
-- whereas WHERE operates only on columns.

SELECT
	   productCode AS `Product Code`,
          COUNT(*) AS `Count`,
          CAST(AVG(price) AS DECIMAL(7,2)) AS `Average`
       FROM products 
       GROUP BY productCode
       HAVING Count >=3;
                 -- CANNOT use WHERE count >= 3

-- WITH ROLLUP

-- The WITH ROLLUP clause shows the summary of group summary, e.g.,

SELECT 
          productCode, 
          MAX(price), 
          MIN(price), 
          CAST(AVG(price) AS DECIMAL(7,2)) AS `Average`,
          SUM(quantity)
       FROM products
       GROUP BY productCode
       WITH ROLLUP;        -- Apply aggregate functions to all groups












