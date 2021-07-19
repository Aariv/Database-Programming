-- 2.7  Modifying Data - UPDATE

/**
To modify existing data, use UPDATE ... SET command, with the following syntax:

UPDATE tableName SET columnName = {value|NULL|DEFAULT}, ... WHERE criteria
*/

-- For example,
-- Increase the price by 10% for all products
UPDATE products SET price = price * 1.1;

SELECT * FROM products;

-- Modify selected rows
UPDATE products SET quantity = quantity - 100 WHERE name = 'Pen Red';

SELECT * FROM products WHERE name = 'Pen Red';

-- You can modify more than one values
UPDATE products SET quantity = quantity + 50, price = 1.23 WHERE name = 'Pen Red';

SELECT * FROM products WHERE name = 'Pen Red';

/*
CAUTION: If the WHERE clause is omitted in the UPDATE command, ALL ROWS will be updated. 
Hence, it is a good practice to issue a SELECT query, using the same criteria, to check the result set before issuing the UPDATE. 

This also applies to the DELETE statement in the following section.
*/

-- 2.8  Deleting Rows - DELETE FROM
-- ********************************

-- Use the DELELE FROM command to delete row(s) from a table, with the following syntax:
-- Delete all rows from the table. Use with extreme care! Records are NOT recoverable!!!
DELETE FROM tableName
-- Delete only row(s) that meets the criteria
DELETE FROM tableName WHERE criteria
-- For example,
DELETE FROM products WHERE name LIKE 'Pencil%';

SELECT * FROM products;

-- Use this with extreme care, as the deleted records are irrecoverable!
DELETE FROM products;
SELECT * FROM products;

/*
Beware that "DELETE FROM tableName" without a WHERE clause deletes ALL records from the table.
Even with a WHERE clause, you might have deleted some records unintentionally. 
It is always advisable to issue a SELECT command with the same WHERE clause 
to check the result set before issuing the DELETE (and UPDATE).
*/


-- 2.9  Loading/Exporting Data from/to a Text File
-- ***********************************************
/*
	There are several ways to add data into the database:
	
	(a) manually issue the INSERT commands;
	(b) run the INSERT commands from a script;
	(c) load raw data from a file using LOAD DATA or via mysqlimport utility.

*/

-- LOAD DATA LOCAL INFILE ... INTO TABLE ...
/*
	Besides using INSERT commands to insert rows, you could keep your raw data in a text file, 
	and load them into the table via the LOAD DATA command. 

products.csv
\N,PEC,Pencil 3B,500,0.52
\N,PEC,Pencil 4B,200,0.62
\N,PEC,Pencil 5B,100,0.73
\N,PEC,Pencil 6B,500,0.47

	You can load the raw data into the products table as follows:
*/
LOAD DATA LOCAL INFILE '~/Documents/products_in.csv' INTO TABLE products
         COLUMNS TERMINATED BY ',';

SELECT * FROM products;
/*
Notes:

You need to provide the path (absolute or relative) and the filename. Use Unix-style forward-slash '/' as the directory separator, instead of Windows-style back-slash '\'.
The default column delimiter is "tab" (in a so-called TSV file - Tab-Separated Values). If you use another delimiter, e.g. ',', include COLUMNS TERMINATED BY ','.
You need to use \N for NULL.
*/

-- mysqlimport Utility Program
-- ***************************

-- You can also use the mysqlimport utility program to load data from a text file.

-- SYNTAX
mysqlimport -u username -p --local databaseName tableName.tsv
   -- The raw data must be kept in a TSV (Tab-Separated Values) file with filename the same as tablename

-- EXAMPLES
-- Create a new file called "products.tsv" containing the following record,
--  and saved under "Documents" (for Mac)
-- The values are separated by tab (not spaces).
\N  PEC  Pencil 3B  500  0.52
\N  PEC  Pencil 4B  200  0.62
\N  PEC  Pencil 5B  100  0.73
\N  PEC  Pencil 6B  500  0.47


mysqlimport -u root -p --local southwind ~/Documents/products.tsv

-- SELECT ... INTO OUTFILE ...
/*
Complimenting LOAD DATA command, you can use SELECT ... INTO OUTFILE fileName FROM tableName to export data from a table to a text file. For example,
*/

SELECT * FROM products INTO OUTFILE '~/Documents/products_out.csv'
         COLUMNS TERMINATED BY ',';

-- 2.10  Running a SQL Script
-- **************************

/**
Instead of manually entering each of the SQL statements, you can keep many SQL statements in a text file, called SQL script, and run the script. 
For example, use a programming text editor to prepare the following script and save as "load_products.sql" under "d:\myProject" (for Windows) or "Documents" (for Mac).
*/

DELETE FROM products;
INSERT INTO products VALUES (2001, 'PEC', 'Pencil 3B', 500, 0.52),
                            (NULL, 'PEC', 'Pencil 4B', 200, 0.62),
                            (NULL, 'PEC', 'Pencil 5B', 100, 0.73),
                            (NULL, 'PEC', 'Pencil 6B', 500, 0.47);
SELECT * FROM products;


/**
You can run the script either:

1. via the "source" command in a MySQL client. For example, to restore the southwind backup earlier:
source ~/Documents/load_products.sql

2. via the "batch mode" of the mysql client program, by re-directing the input from the script:
mysql -u root -p southwind < ~\Documents\load_products.sql





