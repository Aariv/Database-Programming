2.  MySQL Data Types
====================

As a programmer, understanding the data types is curial in understanding the working of the underlying database system.
(Read "A Tutorial on Data Representation - Integers, Floating-point Numbers, and Character Sets".)

MySQL supports many data types, grouped in 3 categories:

1. Numeric: including integers, floating-point numbers, bits and boolean.
2. String: including fixed-length and variable-length strings, binary data, and collections (enumeration and set).
3. Date/Time: Date and time are extremely important in database applications. 
   This is because business records often carry date/time information 
   (e.g., orderDate, paymentDate). 
   There is also a need to time-stamp the creation and last update of records for auditing and security considerations. 
   MySQL provides many date/time data types 
   (e.g., DATETIME, DATE, TIME, YEAR, TIMESTAMP) and built-in functions for date/time manipulation.

***********************
2.1  Numeric - Integers
***********************

Integers, by default, are signed integers; unless UNSIGNED is declared.

You could set the display width, 
using the syntax INTEGER_TYPE(n), where n is the display field-width of up to 255, e.g., INT(10). 
You could also specify ZEROFILL to pad the displayed numbers with leading zeros (for UNSIGNED only) instead of blanks. 
The field-width affects only the display, and not the number stored.

MySQL supports many integer types with various precisions and ranges.

TINYINT: 8-bit precision. The range is [-128, 127] for signed integer, and [0, 255] for unsigned.
SMALLINT: 16-bit precision. The range is [-32768, 32767] for signed integer, and [0, 65535] for unsigned.
MEDIUMINT: 24-bit precision. The range is [-8388608, 8388607] for signed integer, and [0, 16777215] for unsigned.
INT (or INTEGER): 32-bit precision. The range is [-2147483648, 2147483647] for signed integer, and [0, 4294967295] for unsigned.
BIGINT: 64-bit precision. The range is [-9223372036854775808, 9223372036854775807] for signed integer, and [0, 18446744073709551615] for unsigned.
BIT(n): A n-bit column. To input a bit-value, use the syntax b'value' or 0bvalue, e.g., b'1001', 0b10010.
BOOLEAN (or BOOL): same as TINYINT(1) (with range of -128 to 127, display field-width of 1). Value of zero is considered false; non-zero is considered true. You could also use BIT(1) to store boolean value.

Choosing the right integer type is important for optimizing storage usage 
and computational efficiency. 
For example, for a integer column with a range of 1 to 9999, 
use SMALLINT(4) UNSIGNED: for 1 to 9999999, 
use MEDIUMINT(7) UNSIGNED (which shall be sufficient for a small business, but always allow more room for future expansion).

Integers (and floating-point numbers to be discussed later) could be declared as AUTO_INCREMENT, with default starting value of 1. 
When you insert a NULL (recommended) (or 0, or a missing value) into an AUTO_INCREMENT column, the maximum value of that column plus 1 would be inserted. 
You can also insert any valid value to an AUTO_INCREMENT column, bypassing the auto-increment. 
Take note that further INSERT would fail if the last INSERT has reached the maximum value. 
Hence, it is recommended to use INT for AUTO_INCREMENT column to avoid handling over-run. 
There can only be one AUTO_INCREMENT column in a table and the column must be defined as a key.

Example (Testing the Integer Data Types): Read "integer_arena.sql".

https://www3.ntu.edu.sg/home/ehchua/programming/sql/codes/integer_arena.sql.txt
https://www3.ntu.edu.sg/home/ehchua/programming/sql/codes/autoincrement_arena.sql.txt

****************************************************
2.2  Numeric - Fixed-Point & Floating-Point Numbers
****************************************************

MySQL supports both approximated floating points (FLOAT and DOUBLE) 
and exact fixed-point point (DECIMAL).

FLOAT: 32-bit single precision floating-point numbers. 
You can specify UNSIGNED to disallow negative number, and 
ZEROFILL to pad the displayed number with zeros.

DOUBLE (or DOUBLE PRECISION or REAL): 64-bit double precision floating-point numbers.

DECIMAL(n, d) (or DEC or NUMERIC or FIXED): fixed-point decimal numbers, where n is the number of digits with d decimal places. 
For example, DECIMAL(6, 2) specifies 6 total digits (not including the decimal point) with 2 digit after the decimal point, which has the range of -9999.99 to 9999.99.

Unlike INT(n), where n specifies the display field-width and does not affect the number stored; 
n in DECIMAL(n, d) specifies the range and affects the number stored.









