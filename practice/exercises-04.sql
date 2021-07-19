-- 4.  More on Primary Key, Foreign Key and Index
--------------------------------------------------

-- 4.1  Primary Key
-- ****************
/*
In the relational model, 
a table shall not contain duplicate rows, because that would create ambiguity in retrieval. 
To ensure uniqueness, each table should have a column (or a set of columns), called primary key, 
that uniquely identifies every record of the table. 
For example, an unique number customerID can be used as the primary key for the customers table; 
productCode for products table; 
isbn for books table. 
A primary key is called a simple key if it is a single column; 
it is called a composite key if it is made up of several columns. 
Most RDBMSs build an index on the primary key to facilitate fast search. 
The primary key is often used to relate to other tables.
*/

-- 4.2  Foreign Key
-- ****************
/*
A foreign key of a child table is used to reference the parent table. 
Foreign key constraint can be imposed to ensure so-called referential integrity - values in the child table must be valid values in the parent table.

We define the foreign key when defining the child table, which references a parent table, as follows:
*/
-- Child table definition
CREATE TABLE tableName (
......
   ......
   CONSTRAINT constraintName FOREIGN KEY (columName) REFERENCES parentTableName (columnName)
   [ON DELETE RESTRICT | CASCADE | SET NULL | NO ACTION]   -- On DELETE reference action
   [ON UPDATE RESTRICT | CASCADE | SET NULL | NO ACTION]   -- On UPDATE reference action
)
/*
You can specify the reference action for UPDATE and DELETE via the optional ON UPDATE and ON DELETE clauses:
RESTRICT (default): disallow DELETE or UPDATE of the parent's row, if there are matching rows in child table.
CASCADE: cascade the DELETE or UPDATE action to the matching rows in the child table.
SET NULL: set the foreign key value in the child table to NULL (if NULL is allowed).
NO ACTION: a SQL term which means no action on the parent's row. Same as RESTRICT in MySQL, which disallows DELETE or UPDATE (do nothing).

Try deleting a record in the suppliers (parent) table that is referenced by products_suppliers (child) table, e.g.,

*/

SELECT * FROM products_suppliers;

-- Try deleting a row from parent table with matching rows in the child table
DELETE FROM suppliers WHERE supplierID = 501;

/*
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails 
(`southwind`.`products_suppliers`, CONSTRAINT `products_suppliers_ibfk_2` 
FOREIGN KEY (`supplierID`) REFERENCES `suppliers` (`supplierID`))

The record cannot be deleted as the default "ON DELETE RESTRICT" constraint was imposed.
*/

-- 4.3  Indexes (or Keys)
-- ***********************

