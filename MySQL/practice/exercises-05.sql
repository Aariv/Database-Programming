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
 DATETIME: stores both date and time in the format of 'YYYY-MM-DD HH:MM:SS'. The valid range is '1000-01-01 00:00:00' to '9999-12-31 23:59:59'. You can set a value using the valid format (e.g., '2011-08-15 00:00:00'). You could also apply functions NOW() or CURDATE() (time will be set to '00:00:00'), but not CURTIME().
 DATE: stores date only in the format of 'YYYY-MM-DD'. The range is '1000-01-01' to '9999-12-31'. You could apply CURDATE() or NOW() (the time discarded) on this field.



