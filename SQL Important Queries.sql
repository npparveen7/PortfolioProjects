/*

-- String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

*/

-- Drop Table EmployeeErrors;

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50),
FirstName varchar(50),
LastName Varchar (50)
)

Insert into EmployeeErrors Values
('1001' , 'Jimbo', 'Halbert'),
('1002' , 'Pamela', 'Beasely'),
('1003' , 'Toby', 'Flenderson - Fired')

Select *
From EmployeeErrors


-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

Select EmployeeID ,RTRIM(EmployeeID) as IDRTRIM
FROM EmployeeErrors

Select EmployeeID, LTRIM(EmployeeID) as LTRIM
FROM EmployeeErrors


-- Using Replace


SELECT LastName, Replace(LastName, '- Fired', '') as LastNameFixed
From EmployeeErrors

-- Using Upper and Lower

Select firstname, Lower(firstname) AS LoweredCase
from EmployeeErrors

Select firstname, UPPER(firstname) as Upperedcase
From EmployeeErrors

-- Using Autoincrement

CREATE TABLE student_records1
(stud_id  int IDENTITY,
 Name Varchar (50) NOT NULL,
 City varchar(50),
PRIMARY KEY (stud_id),
 );

 CREATE TABLE e_com_fashion
 (serial_number int IDENTITY (100,1),
 name varchar (100),
 product_name varchar (200) NOT NULL,
 Price int,
 PRIMARY KEY (serial_number),
 )

 DROP TABLE e_com_fashion

 INSERT INTO e_com_fashion VALUES
 ( 'Myntra', 'Anouk_Suit', 2500 ),
 ('Ajio', 'TrueBorwn_Coord' , 4000),
( 'Myntra', 'Biba_Suit', 1500 ),
( 'Myntra', 'Taavi_Mojri',800 ),
( 'Myntra', 'Mango_Jeans', 1200 ),
( 'Myntra', 'Vishudh_Suit', 2100 )

-- Creating another table 
CREATE TABLE e_com_fashion1
 (serial_number int IDENTITY (100,1),
 name varchar (100),
 product_name varchar (200) NOT NULL,
 PRIMARY KEY (serial_number),
 )
;
-- Inserting Values
INSERT INTO e_com_fashion1 VALUES
 ( 'Myntra', 'Anouk_Suit' ),
 ('Ajio', 'TrueBorwn_Coord' ),
( 'Myntra', 'Biba_Suit'),
( 'Myntra', 'Taavi_Mojri'),
( 'Myntra', 'Mango_Jeans' ),
( 'Myntra', 'Vishudh_Suit' );

SELECT *
FROM e_com_fashion

INSERT INTO student_records1 VALUES
  ( 'Shikha' , 'Delhi'),
 ('Ridhi', 'Ghaziabad'),
 ( 'Rishi' , 'Gurugram');

 -- Use of Union All Command
SELECT *
FROM e_com_fashion1
 UNION ALL
SELECT *
FROM student_records1


SELECT *
FROM e_com_fashion


-- Use of scalar subquery and windows function
Ques1. What is the maximum price by name? Also allocate row_number to each product?

SELECT e.*,
row_number() over ( order by product_name) as row_numb,
                   (select max(price) from e_com_fashion) as MAXIMUM_PRICE
FROM e_com_fashion e


-- Use of rank,dense_rank,lead, lag
 
Ques2. Which are the top 3 product as per prcie.?

SELECT e.*,
 rank() over (partition by  name order by price desc) as rnk,
 dense_rank() over (partition by  name order by price desc) as rnk,
 row_number() over ( order by product_name) as row_numb,
 lag(price) over( partition by name order by price desc)  as prev_product_price,
 lead(price) over ( partition by name order by price desc )  as next_product_price
FROM e_com_fashion e

-- Use of case statements

SELECT e.*,
 case 
  when price > 2100 then 'Expensive'
  when price < 2000 then 'Cheap'
  when price = 2100 then 'Affordable'
 End 
FROM  e_com_fashion e












