/****************************************
Statement of Authorship: Abdi Sidnoor, certify that this material is my original work. 
No other person's work has been used without acknowledgment, and I have not made my work available to anyone else.
****************************************/

/****************************************
Script: SQLQUrey1.sql
Author: Abdi Sidnoor
Date: October 6 2023
Description: Create  Database objects for Shine Clean Home
****************************************/

-- Setting NOCOUNT ON suppresses completion messages for each INSERT
SET NOCOUNT ON;

-- Set date format to year, month, day
SET DATEFORMAT ymd;

-- Make the master database the current database
USE master;

-- If the co859 database exists, drop it
IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'co859')
BEGIN
    ALTER DATABASE co859 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE co859;
END;
GO

-- Create the co859 database
CREATE DATABASE co859;
GO

-- Make the co859 database the current database
USE co859;

-- Create shine_clean_home table
CREATE TABLE shine_clean_home (
    service_id INT PRIMARY KEY,
    service_description VARCHAR(30),
    service_type CHAR(1) CHECK (service_type IN ('S', 'D', 'C')),
    hourly_rate MONEY,
    sales_ytd MONEY
);

-- Create sales_new table (
CREATE TABLE sales_new (
    sales_id INT PRIMARY KEY,
    sales_date DATE,
    amount MONEY,
    service_id INT FOREIGN KEY REFERENCES shine_clean_home (service_id)
);
GO

-- Insert shine_clean_home records
INSERT INTO shine_clean_home VALUES(100, 'Standard Cleaning', 'S', 100, 300);
INSERT INTO shine_clean_home VALUES(200, 'Deep Cleaning', 'D', 100, 300);
INSERT INTO shine_clean_home VALUES(300, 'Deep Window Cleaning', 'D', 50, 150);
INSERT INTO shine_clean_home VALUES(400, 'Carpet Cleaning', 'C', 50, 150);
INSERT INTO shine_clean_home VALUES(500, 'Standard Move-in/Move-out', 'S', 200, 600);

-- Insert sales_new records
INSERT INTO sales_new VALUES(1, '2023-05-10', 100, 100);
INSERT INTO sales_new VALUES(10, '2023-05-19', 100, 100);
INSERT INTO sales_new VALUES(15, '2023-05-24', 100, 100);
INSERT INTO sales_new VALUES(5, '2023-05-14', 100, 200);
INSERT INTO sales_new VALUES(9, '2023-05-18', 100, 200);
INSERT INTO sales_new VALUES(11, '2023-05-20', 100, 200);
INSERT INTO sales_new VALUES(4, '2023-05-13', 50, 300);
INSERT INTO sales_new VALUES(8, '2023-05-17', 50, 300);
INSERT INTO sales_new VALUES(12, '2023-05-21', 50, 300);
INSERT INTO sales_new VALUES(3, '2023-05-12', 50, 400);
INSERT INTO sales_new VALUES(7, '2023-05-16', 50, 400);
INSERT INTO sales_new VALUES(13, '2023-05-22', 50, 400);
INSERT INTO sales_new VALUES(2, '2023-05-11', 200, 500);
INSERT INTO sales_new VALUES(6, '2023-05-15', 200, 500);
INSERT INTO sales_new VALUES(14, '2023-05-23', 200, 500);
GO

-- Verify inserts
CREATE TABLE verify (
    table_name VARCHAR(30),
    actual INT,
    expected INT
);
GO

INSERT INTO verify (table_name, actual, expected) VALUES
    ('shine_clean_home', (SELECT COUNT(*) FROM shine_clean_home), 5),
    ('sales_new', (SELECT COUNT(*) FROM sales_new), 15);

PRINT 'Verification';
SELECT table_name, actual, expected, expected - actual AS discrepancy FROM verify;

DROP TABLE verify;
GO

-- Create an index on the 'service_description' column
SELECT *
FROM information_schema.tables
WHERE table_name = 'Shine Clean Home Services';


-- Create an index on the 'service_description
CREATE INDEX IX_ShineCleanHomeServices_service_description
ON shine_clean_home  (service_description);

-- Start a new batch
GO

-- Create a view for high-end Shine Clean Home Services
CREATE VIEW high_end_ShineCleanHomeServices
AS
SELECT 
    SUBSTRING(service_description, 1, 15) AS short_description,
    sales_ytd
FROM shine_clean_home 
WHERE hourly_rate > (
    SELECT AVG(hourly_rate)
    FROM shine_clean_home 
);

-- Start another new batch
GO
