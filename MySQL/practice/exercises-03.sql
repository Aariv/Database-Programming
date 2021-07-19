-- 3.  More Than One Tables
---------------------------
/*
Our example so far involves only one table "products". A practical database contains many related tables.

Products have suppliers. If each product has one supplier, and each supplier supplies only one product
(known as one-to-one relationship),
we can simply add the supplier's data (name, address, phone number) into the products table. 

Suppose that each product has one supplier, and a supplier may supply zero or more products (known as one-to-many relationship). 

Putting the supplier's data into the products table results in duplication of data.

This is because one supplier may supply many products, hence, the same supplier's data appear in many rows. 

This not only wastes the storage but also easily leads to inconsistency (as all duplicate data must be updated simultaneously). 
The situation is even more complicated if one product has many suppliers, and each supplier can supply many products, in a many-to-many relationship.

*/
-- 3.1  One-To-Many Relationship
-- *****************************
/*
Suppose that each product has one supplier, and each supplier supplies one or more products.
We could create a table called suppliers to store suppliers' data
(e.g., name, address and phone number).
We create a column with unique value called supplierID to identify every suppliers.
We set supplierID as the primary key for the table suppliers (to ensure uniqueness and facilitate fast search).

To relate the suppliers table to the products table, we add a new column into the products table - the supplierID. 
We then set the supplierID column of the products table as a foreign key references the supplierID column of the suppliers table to ensure the so-called referential integrity.

We need to first create the suppliers table, because the products table references the suppliers table.
The suppliers table is known as the parent table; while the products table is known as the child table in this relationship.
*/

USE southwind;

DROP TABLE IF EXISTS suppliers;

CREATE TABLE suppliers (
         supplierID  INT UNSIGNED  NOT NULL AUTO_INCREMENT, 
         name        VARCHAR(30)   NOT NULL DEFAULT '', 
         phone       CHAR(8)       NOT NULL DEFAULT '',
         PRIMARY KEY (supplierID)
);

DESCRIBE suppliers;

INSERT INTO suppliers VALUE
          (501, 'ABC Traders', '88881111'), 
          (502, 'XYZ Company', '88882222'), 
          (503, 'QQ Corp', '88883333');

SELECT * FROM suppliers;

-- ALTER TABLE

-- Instead of deleting and re-creating the products table, we shall use "ALTER TABLE" to add a new column supplierID into the products table.

ALTER TABLE products
       ADD COLUMN supplierID INT UNSIGNED NOT NULL;

DESCRIBE products;

/*
Next, we shall add a foreign key constraint on the supplierID columns of the products child table
to the suppliers parent table, to ensure that every supplierID in the products table always refers to a valid supplierID in the suppliers table - this is called referential integrity.

Before we can add the foreign key, we need to set the supplierID of the existing records in the products table to a valid supplierID in the suppliers table (say supplierID=501).

*/

-- Set the supplierID of the existing records in "products" table to a VALID supplierID
--   of "suppliers" table

UPDATE products SET supplierID = 501;

-- Add a foreign key constrain
ALTER TABLE products
       ADD FOREIGN KEY (supplierID) REFERENCES suppliers (supplierID);

DESCRIBE products;

UPDATE products SET supplierID = 502 WHERE productID  = 2004;
  -- Choose a valid productID
SELECT * FROM products;

-- SELECT with JOIN
/*
SELECT command can be used to query and join data from two related tables. 
For example, to list the product's name (in products table) and supplier's name (in suppliers table), 
we could join the two table via the two common supplierID columns:
*/
-- ANSI style: JOIN ... ON ...

SELECT products.name, price, suppliers.name 
       FROM products 
          JOIN suppliers ON products.supplierID = suppliers.supplierID
       WHERE price < 0.6;

    -- Need to use products.name and suppliers.name to differentiate the two "names"
-- Join via WHERE clause (lagacy and not recommended)
SELECT products.name, price, suppliers.name 
       FROM products, suppliers 
       WHERE products.supplierID = suppliers.supplierID
          AND price < 0.6;

-- In the above query result, two of the columns have the same heading "name". We could create aliases for headings.
-- Use aliases for column names for display
SELECT products.name AS `Product Name`, price, suppliers.name AS `Supplier Name` 
       FROM products 
          JOIN suppliers ON products.supplierID = suppliers.supplierID
       WHERE price < 0.6;

-- Use aliases for table names too
SELECT p.name AS `Product Name`, p.price, s.name AS `Supplier Name` 
       FROM products AS p 
          JOIN suppliers AS s ON p.supplierID = s.supplierID
       WHERE p.price < 0.6;

-- 3.2  Many-To-Many Relationship
-- ******************************
/**
Suppose that a product has many suppliers;
and a supplier supplies many products in a so-called many-to-many relationship.
The above solution breaks.

You cannot include the supplierID in the products table, as you cannot determine the number of suppliers,
hence, the number of columns needed for the supplierIDs.

Similarly, you cannot include the productID in the suppliers table, as you cannot determine the number of products.

To resolve this problem, you need to create a new table, known as a junction table (or joint table), 
to provide the linkage.

Let's call the junction table products_suppliers, as illustrated.

Let's create the products_suppliers table.

The primary key of the table consists of two columns: productID and supplierID, as their combination uniquely identifies each rows. 
This primary key is defined to ensure uniqueness.
Two foreign keys are defined to set the constraint to the two parent tables.

*/

CREATE TABLE products_suppliers (
         productID   INT UNSIGNED  NOT NULL,
         supplierID  INT UNSIGNED  NOT NULL,
                     -- Same data types as the parent tables
         PRIMARY KEY (productID, supplierID),
                     -- uniqueness
         FOREIGN KEY (productID)  REFERENCES products  (productID),
         FOREIGN KEY (supplierID) REFERENCES suppliers (supplierID)
       );

DESCRIBE products_suppliers;

INSERT INTO products_suppliers VALUES (2001, 501), (2002, 501),
       (2003, 501), (2004, 502), (2001, 503);

-- Values in the foreign-key columns (of the child table) must match 
--   valid values in the columns they reference (of the parent table)
SELECT * FROM products_suppliers;

/*
Next, remove the supplierID column from the products table. 
(This column was added to establish the one-to-many relationship. 
It is no longer needed in the many-to-many relationship.)

Before this column can be removed, you need to remove the foreign key that builds on this column. 
To remove a key in MySQL, you need to know its constraint name, which was generated by the system.
To find the constraint name, issue a "SHOW CREATE TABLE products" 
and take note of the foreign key's constraint name in the clause "CONSTRAINT constraint_name FOREIGN KEY ....". 

You can then drop the foreign key using "ALTER TABLE products DROP FOREIGN KEY constraint_name"
*/

SHOW CREATE TABLE products \G
ALTER TABLE products DROP FOREIGN KEY products_ibfk_1;
SHOW CREATE TABLE products \G

-- Now, we can remove the column redundant supplierID column.

ALTER TABLE products DROP supplierID;
DESC products;

-- Querying

-- Similarly, we can use SELECT with JOIN to query data from the 3 tables, for examples,

SELECT products.name AS `Product Name`, price, suppliers.name AS `Supplier Name`
       FROM products_suppliers 
          JOIN products  ON products_suppliers.productID = products.productID
          JOIN suppliers ON products_suppliers.supplierID = suppliers.supplierID
       WHERE price < 0.6;

-- Define aliases for tablenames too 
SELECT p.name AS `Product Name`, s.name AS `Supplier Name`
       FROM products_suppliers AS ps 
          JOIN products AS p ON ps.productID = p.productID
          JOIN suppliers AS s ON ps.supplierID = s.supplierID
       WHERE p.name = 'Pencil 3B';

-- Using WHERE clause to join (legacy and not recommended)
SELECT p.name AS `Product Name`, s.name AS `Supplier Name`
       FROM products AS p, products_suppliers AS ps, suppliers AS s
       WHERE p.productID = ps.productID
          AND ps.supplierID = s.supplierID
          AND s.name = 'ABC Traders';

-- Both products and suppliers tables exhibit a one-to-many relationship to the junction table. The many-to-many relationship is supported via the junction table.

-- 3.3  One-to-one Relationship
-- ****************************
/*
Suppose that some products have optional data (e.g., photo, comment). 
Instead of keeping these optional data in the products table, it is more efficient to create another table called product_details, and link it to products with a one-to-one relationship, as illustrated.
*/

CREATE TABLE product_details (
          productID  INT UNSIGNED   NOT NULL,
                     -- same data type as the parent table
          comment    TEXT  NULL,
                     -- up to 64KB
          PRIMARY KEY (productID),
          FOREIGN KEY (productID) REFERENCES products (productID)
       );

DESCRIBE product_details;

SHOW CREATE TABLE product_details \G

-- 3.4  Backup and Restore
-- ***********************
/*
Backup: Before we conclude this example, let's run the mysqldump utility program to dump out (backup) the entire southwind database.
mysqldump -u root -p --databases southwind > ~/Documents/backup_southwind.sql

Study the output file, which contains CREATE DATABASE, CREATE TABLE and INSERT statements to re-create the tables dumped.

The SYNTAX for the mysqldump utility program is as follows:


*/
-- Dump selected databases with --databases option
mysqldump -u username -p --databases database1Name [database2Name ...] > backupFile.sql

-- Dump all databases in the server with --all-databases option, except mysql.user table (for security)
mysqldump -u root -p --all-databases --ignore-table=mysql.user > backupServer.sql

-- Dump all the tables of a particular database
mysqldump -u username -p databaseName > backupFile.sql

-- Dump selected tables of a particular database
mysqldump -u username -p databaseName table1Name [table2Name ...] > backupFile.sql

/*
Restore: The utility mysqldump produces a SQL script (consisting of CREATE TABLE and INSERT commands to re-create the tables and loading their data). You can restore from the backup by running the script either:
*/

-- 1. via the "source" command in an interactive client. For example, to restore the southwind backup earlier:
source ~/Documents/backup_southwind.sql

-- 2. via the "batch mode" of the mysql client program by re-directing the input from the script:
mysql -u root -p southwind < ~/Documents/backup_southwind.sql

