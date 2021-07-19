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

2.  An Example for the Beginners (But NOT for the dummies)

A MySQL database server contains many databases (or schemas). Each database consists of one or more tables. A table is made up of columns (or fields) and rows (records).
The SQL keywords and commands are NOT case-sensitive.
For clarity, they are shown in uppercase. 
The names or identifiers (database names, table names, column names, etc.) are case-sensitive in some systems, but not in other systems. Hence, it is best to treat identifiers as case-sensitive.

SHOW DATABASES

You can use SHOW DATABASES to list all the existing databases in the server.

mysql> SHOW DATABASES;
The databases "mysql", "information_schema" and "performance_schema" are system databases used internally by MySQL. A "test" database is provided during installation for your testing.

Let us begin with a simple example - a product sales database.
A product sales database typically consists of many tables, e.g., products, customers, suppliers, orders, payments, employees, among others.
Let's call our database "southwind"'


We shall begin with the first table called "products" with the following columns (having data types as indicated) and rows:

2.1  Creating and Deleting a Database - CREATE DATABASE and DROP DATABASE
----------------------------------------------------------------------------
You can create a new database using SQL command "CREATE DATABASE databaseName"; 
and delete a database using "DROP DATABASE databaseName". 
You could optionally apply condition "IF EXISTS" or "IF NOT EXISTS" to these commands. For example,
mysql> CREATE DATABASE southwind;
mysql> DROP DATABASE southwind;
mysql> CREATE DATABASE IF NOT EXISTS southwind;
mysql> DROP DATABASE IF EXISTS southwind;

IMPORTANT: Use SQL DROP (and DELETE) commands with extreme care, as the deleted entities are irrecoverable. THERE IS NO UNDO!!!

SHOW CREATE DATABASE

The CREATE DATABASE commands uses some defaults. 
You can issue a "SHOW CREATE DATABASE databaseName" to display the full command and check these default values. 
We use \G (instead of ';') to display the results vertically. (Try comparing the outputs produced by ';' and \G.)

mysql> CREATE DATABASE IF NOT EXISTS southwind;
mysql> SHOW CREATE DATABASE southwind \G

