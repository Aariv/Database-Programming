-- 5.  More SQL
-----------------

--5.1  Sub-Query
----------------
/*
Results of one query can be used in another SQL statement. 
Subquery is useful if more than one tables are involved.
*/

-- SELECT with Subquery
/*
In the previous many-to-many product sales example,
how to find the suppliers that do not supply any product? 
You can query for the suppliers that supply at least one product in the products_suppliers table, 
and then query the suppliers table for those that are not in the previous result set.
*/

SELECT suppliers.name from suppliers
	WHERE suppliers.supplierID
	 NOT IN (SELECT DISTINCT supplierID from products_suppliers);

/*
Can you do this without sub-query?

A subquery may return a scalar, 
a single column, a single row, or a table. 
You can use comparison operator (e.g., '=', '>') on scalar, IN or NOT IN for single row or column,
EXISTS or NOT EXIST to test for empty set.
*/

-- INSERT|UPDATE|DELETE with Subquery
/**
	You can also use a subquery with other SQL statements such as INSERT, DELETE, or UPDATE. 
	For example,
*/

-- Supplier 'QQ Corp' now supplies 'Pencil 6B'
-- You need to put the SELECT subqueies in parentheses
INSERT INTO products_suppliers VALUES (
          (SELECT productID  FROM products  WHERE name = 'Pencil 6B'),
          (SELECT supplierID FROM suppliers WHERE name = 'QQ Corp'));

-- Supplier 'QQ Copr' no longer supplies any item
DELETE FROM products_suppliers
       WHERE supplierID = (SELECT supplierID FROM suppliers WHERE name = 'QQ Corp');

-- 5.2  Working with Date and Time
-- *******************************
/**
Date and time are of particular interest for database applications. 
This is because business records often carry date/time information
(e.g., orderDate, deliveryDate, paymentDate, dateOfBirth), as well as the need to time-stamp the creation and last-update of the records for auditing and security.
With date/time data types, you can sort the results by date, 
search for a particular date or a range of dates, 
calculate the difference between dates, 
compute a new date by adding/subtracting an interval from a given date.
*/

-- Date By Example
/*
Let's begin with Date (without Time) with the following example. 
Take note that date value must be written as a string in the format of 'yyyy-mm-dd', 
e.g., '2012-01-31'.
*/

-- Create a table 'patients' of a clinic
CREATE TABLE patients (
          patientID      INT UNSIGNED  NOT NULL AUTO_INCREMENT,
          name           VARCHAR(30)   NOT NULL DEFAULT '',
          dateOfBirth    DATE          NOT NULL,
          lastVisitDate  DATE          NOT NULL,
          nextVisitDate  DATE          NULL,
                         -- The 'Date' type contains a date value in 'yyyy-mm-dd'
          PRIMARY KEY (patientID)
       );
 
 INSERT INTO patients VALUES
          (1001, 'Ah Teck', '1991-12-31', '2012-01-20', NULL),
          (NULL, 'Kumar', '2011-10-29', '2012-09-20', NULL),
          (NULL, 'Ali', '2011-01-30', CURDATE(), NULL);

-- Date must be written as 'yyyy-mm-dd'
-- Function CURDATE() returns today's date

SELECT * FROM patients;

-- Select patients who last visited on a particular range of date
SELECT * FROM patients
       WHERE lastVisitDate BETWEEN '2012-09-15' AND CURDATE()
       ORDER BY lastVisitDate;

-- Select patients who were born in a particular year and sort by birth-month
-- Function YEAR(date), MONTH(date), DAY(date) returns 
--   the year, month, day part of the given date
SELECT * FROM patients
       WHERE YEAR(dateOfBirth) = 2011
       ORDER BY MONTH(dateOfBirth), DAY(dateOfBirth);

-- Select patients whose birthday is today
SELECT * FROM patients
       WHERE MONTH(dateOfBirth) = MONTH(CURDATE()) 
          AND DAY(dateOfBirth) = DAY(CURDATE());

-- List the age of patients
-- Function TIMESTAMPDIFF(unit, start, end) returns the difference in the unit specified
SELECT name, dateOfBirth, TIMESTAMPDIFF(YEAR, dateOfBirth, CURDATE()) AS age 
       FROM patients
       ORDER BY age, dateOfBirth;     

-- List patients whose last visited more than 60 days ago
SELECT name, lastVisitDate FROM patients
       WHERE TIMESTAMPDIFF(DAY, lastVisitDate, CURDATE()) > 60;
-- Functions TO_DAYS(date) converts the date to days
SELECT name, lastVisitDate FROM patients
       WHERE TO_DAYS(CURDATE()) - TO_DAYS(lastVisitDate) > 60;

-- Select patients 18 years old or younger
-- Function DATE_SUB(date, INTERVAL x unit) returns the date 
--   by subtracting the given date by x unit.
SELECT * FROM patients 
       WHERE dateOfBirth > DATE_SUB(CURDATE(), INTERVAL 18 YEAR);
-- Schedule Ali's next visit to be 6 months from now
-- Function DATE_ADD(date, INTERVAL x unit) returns the date
--   by adding the given date by x unit
UPDATE patients 
       SET nextVisitDate = DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
       WHERE name = 'Ali';

-- Date/Time Functions
/*
MySQL provides these built-in functions for getting the current date, time and datetime:

 NOW(): returns the current date and time in the format of 'YYYY-MM-DD HH:MM:SS'.
 CURDATE() (or CURRENT_DATE(), or CURRENT_DATE): returns the current date in the format of 'YYYY-MM-DD'.
 CURTIME() (or CURRENT_TIME(), or CURRENT_TIME): returns the current time in the format of 'HH:MM:SS'.
*/

select now(), curdate(), curtime();

-- SQL Date/Time Types
-- MySQL provides these date/time data types:
/*
 DATETIME: stores both date and time in the format of 'YYYY-MM-DD HH:MM:SS'. 
 The valid range is '1000-01-01 00:00:00' to '9999-12-31 23:59:59'. 
 You can set a value using the valid format (e.g., '2011-08-15 00:00:00'). 
 You could also apply functions NOW() or CURDATE() (time will be set to '00:00:00'), 
 but not CURTIME().
 
 DATE: stores date only in the format of 'YYYY-MM-DD'. The range is '1000-01-01' to '9999-12-31'. 
 You could apply CURDATE() or NOW() (the time discarded) on this field.

 TIME: stores time only in the format of 'HH:MM:SS'. 
 You could apply CURTIME() or NOW() (the date discarded) for this field.

 YEAR(4|2): in 'YYYY' or 'YY'. The range of years is 1901 to 2155. 
 Use DATE type for year outside this range. 
 You could apply CURDATE() to this field (month and day discarded).

 TIMESTAMP: similar to DATETIME but stored the number of seconds since January 1, 1970 UTC (Unix-style). 
 The range is '1970-01-01 00:00:00' to '2037-12-31 23:59:59'.

 The differences between DATETIME and TIMESTAMP are:
  the range,
  support for time zone,
  TIMESTAMP column could be declared with DEFAULT CURRENT_TIMESTAMP to set the default value to the current date/time.
  You can also declare a TIMESTAMP column with "ON UPDATE CURRENT_TIMESTAMP" to capture the timestamp of the last update.

*/

/*

More Date/Time Functions
------------------------
There are many date/time functions:

 Extracting part of a date/time: YEAR(), MONTH(), DAY(), HOUR(), MINUTE(), SECOND(), 
 e.g.,

*/

SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), MINUTE(NOW()), SECOND(NOW());

/*
 Extracting information: 
  DAYNAME() (e.g., 'Monday'), MONTHNAME() (e.g., 'March'), DAYOFWEEK() (1=Sunday, …, 7=Saturday), DAYOFYEAR() (1-366), ...
*/

SELECT DAYNAME(NOW()), MONTHNAME(NOW()), DAYOFWEEK(NOW()), DAYOFYEAR(NOW());

/*
 Computing another date/time:
  DATE_SUB(date, INTERVAL expr unit), 
  DATE_ADD(date, INTERVAL expr unit), 
  TIMESTAMPADD(unit, interval, timestamp), 

  e.g.,
*/

SELECT DATE_ADD('2012-01-31', INTERVAL 5 DAY);
SELECT DATE_SUB('2012-01-31', INTERVAL 2 MONTH);

/*

Computing interval: 
  DATEDIFF(end_date, start_date), 
  TIMEDIFF(end_time, start_time), 
  TIMESTAMPDIFF(unit, start_timestamp, end_timestamp), 

  e.g.,
*/

SELECT DATEDIFF('2012-02-01', '2012-01-28');
SELECT TIMESTAMPDIFF(DAY, '2012-02-01', '2012-01-28');

/*
Representation: 

 TO_DAYS(date) (days since year 0), FROM_DAYS(day_number), e.g.,

*/
SELECT TO_DAYS('2012-01-31');
SELECT FROM_DAYS(734899);

/*
Formatting: DATE_FORMAT(date, formatSpecifier), e.g.,
*/

SELECT DATE_FORMAT('2012-01-01', '%W %D %M %Y');
SELECT DATE_FORMAT('2011-12-31 23:59:30', '%W %D %M %Y %r');

/*

Exercises:

*/

-- 5.3  View
-- *********

/*
  A view is a virtual table that contains no physical data. '
  It provide an alternative way to look at the data.
*/
-- Define a VIEW called supplier_view from products, suppliers and products_suppliers tables

CREATE VIEW supplier_view
  AS
  SELECT suppliers.name as `Supplier Name`, products.name as `Product Name`
       FROM products 
          JOIN suppliers ON products.productID = products_suppliers.productID
          JOIN products_suppliers ON suppliers.supplierID = products_suppliers.supplierID;
-- You can treat the VIEW defined like a normal table
SELECT * FROM supplier_view;
SELECT * FROM supplier_view WHERE `Supplier Name` LIKE 'ABC%';

DROP VIEW IF EXISTS patient_view;

CREATE VIEW patient_view
       AS
       SELECT 
          patientID AS ID, 
          name AS Name, 
          dateOfBirth AS DOB,
          TIMESTAMPDIFF(YEAR, dateOfBirth, NOW()) AS Age
       FROM patients
       ORDER BY Age, DOB;

SELECT * FROM patient_view WHERE Name LIKE 'A%';
SELECT * FROM patient_view WHERE age >= 18;

-- 5.4  Transactions
-- *****************

/*

A atomic transaction is a set of SQL statements that either ALL succeed or ALL fail.
Transaction is important to ensure that there is no partial update to the database,
given an atomic of SQL statements. Transactions are carried out via COMMIT and ROLLBACK.
*/

CREATE TABLE accounts (
          name     VARCHAR(30),
          balance  DECIMAL(10,2)
       );

INSERT INTO accounts VALUES ('Paul', 1000), ('Peter', 2000);
SELECT * FROM accounts;

-- Transfer money from one account to another account
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE name = 'Paul';
UPDATE accounts SET balance = balance + 100 WHERE name = 'Peter';
COMMIT;     -- Commit the transaction and end transaction
SELECT * FROM accounts;

START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE name = 'Paul';
UPDATE accounts SET balance = balance + 100 WHERE name = 'Peter';
ROLLBACK;    -- Discard all changes of this transaction and end Transaction
SELECT * FROM accounts;

/*
If you start another mysql client and do a SELECT during the transaction (before the commit or rollback), you will not see the changes.
Alternatively, you can also disable the so-called autocommit mode, which is set by default and commit every single SQL statement.

*/
-- Disable autocommit by setting it to false (0)
SET autocommit = 0;
UPDATE accounts SET balance = balance - 100 WHERE name = 'Paul';
UPDATE accounts SET balance = balance + 100 WHERE name = 'Peter';
COMMIT;
SELECT * FROM accounts;
UPDATE accounts SET balance = balance - 100 WHERE name = 'Paul';
UPDATE accounts SET balance = balance + 100 WHERE name = 'Peter';
ROLLBACK;
SELECT * FROM accounts;
SET autocommit = 1;   -- Enable autocommit

/*
A transaction groups a set of operations into a unit that meets the ACID test:
 1. Atomicity: If all the operations succeed, changes are committed to the database. 
 If any of the operations fails, the entire transaction is rolled back, 
 and no change is made to the database. In other words, there is no partial update.
 2. Consistency: A transaction transform the database from one consistent state to another consistent state.
 3. Isolation: Changes to a transaction are not visible to another transaction until they are committed.
 4. Durability: Committed changes are durable and never lost.
*/

-- 5.5  User Variables
-- *******************
/*
In MySQL, you can define user variables via:

1. @varname :=value in a SELECT command, or
2. SET @varname := value or SET @varname = value command.

For examples,

*/
SELECT @ali_dob := dateOfBirth FROM patients WHERE name = 'Ali';
SELECT name WHERE dateOfBirth < @ali_dob;
SET @today := CURDATE();
SELECT name FROM patients WHERE nextVisitDate = @today;





