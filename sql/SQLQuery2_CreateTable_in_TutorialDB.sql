USE [TutorialDB]
-- Create a new table called 'Customers' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('Customers', 'U') IS NOT NULL
DROP TABLE Customers
GO
-- Create the table in the specified schema
CREATE TABLE Customers
(
   CustomerId        INT    NOT NULL   PRIMARY KEY, -- primary key column
   Name      [NVARCHAR](50)  NOT NULL,
   Location  [NVARCHAR](50)  NOT NULL,
   Email     [NVARCHAR](50)  NOT NULL,
   ServiceCode [NVARCHAR](50) NOT NULL,
   RegDate [DATETIME] NOT NULL
);
GO