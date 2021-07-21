An Intermediate MySQL Tutorial
- Scripting, Data Types, Examples

1.   Scripting
--------------

1.1  Creating and Running Scripts
---------------------------------

I shall begin by describing the syntax of a MySQL script, 
as scripts will be used for all the examples in this tutorial.

Instead of issuing each of the SQL statements from a mysql client interactively, 
it is often more convenience to keep the statements in a script. 
You could then run the entire script, or copy and paste selected statements to run.

Example

Use a programming text editor to create the following script and saved as "testscript.sql" in a chosen directory 
(e.g., "d:\myproject\sqlscripts"). 
You should use ".sql" as the file extension.

I recommend NetBeans which provides direct support to MySQL database 
(read NetBeans and MySQL), or NotePad++ (@ http://notepad-plus.sourceforge.net/uk/site.htm), 
which recognizes ".sql" file as a SQL script with syntax highlighting.

/* 
 * My First MySQL Script - testscript.sql.
 * You need to run this script with an authorized user.
 */
SHOW DATABASES;                -- List the name of all the databases in this server
USE mysql;                     -- Set system database 'mysql' as the current database
SELECT user, host FROM user;   -- List all users by querying table 'user'


You can run the script using mysql client in two ways: batch mode or using source command.

Running Script in Batch Mode

To run a script in batch (non-interactive) mode, start a mysql client and redirect the script as the input, as follows:

mysql -u username -p < path-to\scriptName.sql

The input redirection operator '<' re-directs the input from the file, instead of the default standard input (i.e., keyboard).

You may provide an absolute or relative path of the filename.
You may need to double quote the filename if it contains special characters such as blank (strongly discouraged!).

For example, we invoke the mysql client with user "myuser" in batch mode running the script "testscript.sql" created earlier. 
I assume that myuser is authorized to access mysql database.

mysql -u myuser -p < d:\myproject\sqlscripts\testscript.sql

The output contains the column headers and the rows selected. 
The column values are separated by 'tab'. 
This is to facilitate direct processing by another program. 
This format is known as TSV (Tab-Separated Values), similar to CSV (Comma-Separated Values).

You could also redirect the output to a text file (via the output redirection operator '>'), for example,

mysql -u myuser -p < d:\myproject\sqlscripts\testscript.sql > output.txt

To get the "table-like" output, use -t (table) option, for example,

mysql -u myuser -p -t < d:\myproject\sqlscripts\testscript.sql

You could echo the input commands via -vvv (verbose) option, for example,

mysql -u myuser -p -t -vvv < d:\myproject\sqlscripts\testscript.sql

In batch mode, you can also execute statement(s) directly via -e (evaluate) option. 

For example,

mysql -u myuser -p -vvv -e "SELECT user, host FROM user; SHOW databases" mysql

-- Running Script via SOURCE Command
************************************

In an interactive mysql client session, you can use the source command (or \. shorthand command) to run a script. For example,

-- Start and login to a mysql interactive client
mysql -u myuser -p

-- You can use 'source' command to run a script
SOURCE d:/myproject/sqlscripts/mytestscript.sql


-- 1.2  MySQL Scripting Language Syntax
***************************************

Comments

A multi-line comment begins with /* and ends with */ 
An end-of-line comment begins with '-- '
Comments are ignored by the processing engine but are important 
to provide explanation and documentation for the script. 
I strongly encourage you to use comments liberally.

MySQL Specific Codes

Statements enclosed within /*! .... */ are known as MySQL specific codes. 
They are recognized by the MySQL engine, but ignored by other database engines.
In other words, they will be processed by MySQL but treated as comments by other databases.

You can find the MySQL server version via show version() command.

MySQL specific codes (with version number) are often generated when you export a database via mysqldump utility. For example,

-- Identifiers and Backquotes
-----------------------------

Identifiers (such as database names, table names and column names) must be back-quoted 
if they contain blanks and special characters; or are reserved word, 
e.g., `date`, `order`, `desc` (reserved words), `Customer Name` (containing space).

It is a good practice to back-quote all the identifiers
in a script to distinguish the names from the reserved words (possibly in future MySQL versions).

Case Sensitivities
------------------
MySQL keywords are not case-sensitive. 
For clarity, I often show the keywords in uppercase (e.g., CREATE TABLE, SELECT).

1.3  Literals
-------------
String Literals: A string literal (or string value) is enclosed by a pair of single quotes (e.g., 'a string') (recommended); or a pair of double quotes (e.g., "a string").
****************
Hex Literals:
*************
Hex values are written as 0x.... or X'....' or x'....', e.g., 0xABCD, 0xDEF, X'ABCD', x'ABCD'. 
You can obtain the hex value of a string using function HEX().
For example,
-- Show hex value of a string
SELECT HEX('testing');

Bit Literals: 
*************
Similarly, a bit literal is written as 0b... or b'...', e.g., 0b1011, b'10111011'.

1.4  Variables
--------------
There are various types of variables in MySQL: 
System variables (system-wide), 
user-defined variables (within a connection) and 
local variables (within a stored function/procedure).

User-Defined Variables: 
A user-defined variable begins with a '@' sign, e.g., 
@myCount, 
@customerCreditLimit. 
A user-defined variable is connection-specific, and is available within a connection. 
A variable defined in one client session is not visible by another client session. 
You may use a user-defined variable to pass a value among SQL statements within the same connection.

In MySQL, you can define a user variables via:

SET @varname = value or (SET @varname := value)
SELECT @varname := value ...
SELECT columnName INTO @varname ...

For examples,

SET @today = CURDATE();    -- can use = or :=
SELECT name FROM patients WHERE nextVisitDate = @today;  -- can use the variable within the session

SET @v1 = 1, @v2 = 2, @v3 = 3;
SELECT @v1, @v2, @v3, @v4 := @v1 + @v2;  -- Use := in SELECT, because = is for comparison

SELECT @ali_dob := dateOfBirth FROM patients WHERE name = 'Ali';
SELECT dateOfBirth INTO @kumar_dob FROM patients WHERE name = 'kumar';
SELECT name WHERE dateOfBirth BETWEEN @ali_dob AND @kumar_dob;

Like all scripting languages, SQL scripting language is loosely-type. You do not have to explicitly declare the type of a variable, but simply assign a value.

System Variables:
=================
MySQL server maintains system variables, grouped in two categories: 

global and session. 

Global variables affect the overall operation of the server.
Session variables affect individual client connections. 

A system variable may have both a global value and a session value.

Global variables are referenced via GLOBAL variableName, or @@global.variableName.

Session variables are referenced via SESSION variableName, @@session.variableName 
or simply @@variableName.

You can use SET statement to change the value of a variable. For example,

SET GLOBAL sort_buffer_size = 1000000;
SET global.sort_buffer_size = 1000000;
SET SESSION sort_buffer_size = 1000000;
SET session.sort_buffer_size = 1000000;
SET @@sort_buffer_size = 1000000;        -- Session


Use SHOW SESSION|GLOBAL VARIABLES to display the value of variables. You could use a pattern matching LIKE clause to limit the outputs. For example,

-- Show all session variables beginning with 'character_set'.
SHOW VARIABLE LIKE 'character\_set%';
   -- Need to use '\_' for '_' inside a string, because '_' denotes any character.
-- Show all global variable beginning with 'max_'
SHOW GLOBAL VARIABLE LIKE 'max\_%';

Local Variables (within a Stored Program): 
==========================================
You could define local variables for stored programs (such as function and procedure). 
The scope of a local variable is within the program. 
You need to use a DECLARE statement to declare a local variable. 
Local variable will be discussed later.

1.5  MySQL Built-in Functions
-----------------------------
For details of MySQL built-in functions, refer to MySQL manual "Functions and Operators" @ http://dev.mysql.com/doc/refman/5.5/en//functions.html.

MySQL String Functions
======================
Reference: String Functions @ http://dev.mysql.com/doc/refman/5.5/en/string-functions.html.

LENTH(str): returns the length of the string.
INSTR(str, subStr): returns the index of the subStr in the str or 0 otherwise. Index begins at 1.
SUBSTR(str, fromIndex, len): returns the substring from index of length. Index starts at 1.
UCASE(str), LCASE(str): returns the uppercase and lowercase counterpart.
CONCAT(str1, str2, ...): returns the concatenated string.
CONCAT_WS(separator, str1, str2, ...): concatenate with separator.

MySQL GROUP BY Aggregate Functions
==================================
Reference: MySQL "GROUP BY (Aggregate) Functions" @ https://dev.mysql.com/doc/refman/5.5/en/group-by-functions.html.

We can apply GROUP BY aggregate functions to each group of rows.

COUNT([DISTINCT] col): returns the count of non-NULL rows. The optional DISTINCT discards duplicate rows.
COUNT(*): returns the count of the rows (including NULL).
MAX([DISTINCT] col), MIN([DISTINCT] col), AVG([DISTINCT] col), SUM([DISTINCT] col), STD([DISTINCT] col): these functions accept an optional keyword DISTINCT to discard duplicates.
GROUP_CONCAT([DISTINCT] col [ORDER BY ...] [SEPARATOR ...]): returns a string with the concatenated non-NULL values from a group. You can apply optional DISTINCT and ORDER BY. The default SEPARATOR is comma ','.

MySQL Date/Time Functions
=========================

MySQL Mathematical Functions
============================
PI().
RAND(): return a random float between 0 and 1.
ABS(number), SIGN(number): return -1 if negative, 0 for zero, and 1 if positive.
CEIL(float), FLOOR(float), ROUND(float).
GREATEST(value1, value2,...), LEAST(value1, value2,...),
EXP(power): base e, 
LN(number): base e, 
LOG(number, base), 
LOG2(number), 
LOG10(number), 
POWER(number, exponent), 
SQRT(number).

SIN(angleInRadians), 
ASIN(number), 
COS(angleInRadians), 
ACOS(number), 
TAN(angleInRadians), 
ATAN(number), 
ATAN2(y, x), 
COT(angleInRadians).

DEGREES(angleInRadians), RADIANS(angleInDegrees).
BITCOUNT(number): return the number of bits set to 1.
CONV(number, fromBase, toBase), OCT(number)
MOD(number, modulo),
FORMAT(float, decimalPlaces): Format the given float with the given decimal places. TRUNCATE(float, decimalPlaces): allow negative decimalPlaces.

1.6  Naming Convention
======================

My preferred naming convention is as follows:

Database name is a singular noun comprising one or more words, 
in lowercase joined with underscore '_', e.g., the_arena, southwind_traders.

Table name is a plural noun comprising one or more words, 
in lowercase joined with underscore '_', 
e.g., customers, orders, order_details, products, product_lines, product_extras. 
Junction table created to support many-to-many relationship between two tables may include both the table name,
(e.g., suppliers_products, moives_actors) or an action verbs (e.g., writes (author writes books)).

Column name is a singular noun comprising one or more words, 
in lower case joined with underscores or in camel-case begins with a lowercase letter, 
e.g. customerID, name, dateOrdered, and quantityInStock.

MySQL displays database names and table names in lowercase, but column names in its original case.

It is a good practice NOT to include special characters, 
especially blank, in names (unless you are looking for more challenge - these names must be back-quoted). 
Avoid MySQL reserved words, especially date, time, order, desc (used dateOrdered, timeOrdered, and orders instead). 
Backquote the names, if they contain special characters, or are SQL reserved words, 
e.g., `date`, `order`, `Customer ID`. 
It is a good practice to always backquote the names in script.
