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
Indexes (or Keys) can be created on selected column(s) to facilitate fast search.
Without index, a "SELECT * FROM products WHERE productID=x" needs to match with the productID column of all the records in the products table.
If productID column is indexed (e.g., using a binary tree), the matching can be greatly improved (via the binary tree search).

You should index columns which are frequently used in the WHERE clause; and as JOIN columns.

The drawback about indexing is cost and space.
Building and maintaining indexes require computations and memory spaces. 
Indexes facilitate fast search but deplete the performance on modifying the table (INSERT/UPDATE/DELETE), and need to be justified.
Nevertheless, relational databases are typically optimized for queries and retrievals, but NOT for updates.

In MySQL, the keyword KEY is synonym to INDEX.

In MySQL, indexes can be built on:

1. a single column (column-index)
2. a set of columns (concatenated-index)
3. on unique-value column (UNIQUE INDEX or UNIQUE KEY)
4. on a prefix of a column for strings (VARCHAR or CHAR), e.g., first 5 characters.

There can be more than one indexes in a table. Index are automatically built on the primary-key column(s).

You can build index via CREATE TABLE, CREATE INDEX or ALTER TABLE.

CREATE TABLE tableName (
   [UNIQUE] INDEX|KEY indexName (columnName, ...),
      -- The optional keyword UNIQUE ensures that all values in this column are distinct
      -- KEY is synonym to INDEX
   PRIMAY KEY (columnName, ...)  -- Index automatically built on PRIMARY KEY column

   CREATE [UNIQUE] INDEX indexName ON tableName(columnName, ...);

ALTER TABLE tableName ADD UNIQUE|INDEX|PRIMARY KEY indexName (columnName, ...)
SHOW INDEX FROM tableName;

--Example:

CREATE TABLE employees (
          emp_no      INT UNSIGNED   NOT NULL AUTO_INCREMENT,
          name        VARCHAR(50)    NOT NULL,
          gender      ENUM ('M','F') NOT NULL,    
          birth_date  DATE           NOT NULL,
          hire_date   DATE           NOT NULL,
          PRIMARY KEY (emp_no)  -- Index built automatically on primary-key column
       );

DESCRIBE employees;

SHOW INDEX FROM employees \G

CREATE TABLE departments (
         dept_no    CHAR(4)      NOT NULL,
         dept_name  VARCHAR(40)  NOT NULL,
         PRIMARY KEY  (dept_no),   -- Index built automatically on primary-key column
         UNIQUE INDEX (dept_name)  -- Build INDEX on this unique-value column
       );

DESCRIBE departments;

SHOW INDEX FROM departments \G

-- Many-to-many junction table between employees and departments
CREATE TABLE dept_emp (
         emp_no     INT UNSIGNED  NOT NULL,
         dept_no    CHAR(4)       NOT NULL,
         from_date  DATE          NOT NULL,
         to_date    DATE          NOT NULL,
         INDEX       (emp_no),          -- Build INDEX on this non-unique-value column
         INDEX       (dept_no),         -- Build INDEX on this non-unique-value column
         FOREIGN KEY (emp_no)  REFERENCES employees (emp_no) 
            ON DELETE CASCADE ON UPDATE CASCADE,
         FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
            ON DELETE CASCADE ON UPDATE CASCADE,
         PRIMARY KEY (emp_no, dept_no)  -- Index built automatically
     );

DESCRIBE dept_emp;
SHOW INDEX FROM dept_emp \G


