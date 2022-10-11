--db로그인 -------------------------------------------
CREATE LOGIN ${user} WITH PASSWORD = '${passwd}', check_policy = off
GO
--DB 생성 --------------------------------------------
CREATE DATABASE TutorialDB
GO

--role 멤버 등록(권한 작업)----------------------------
USE TutorialDB
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'${user}')
BEGIN
    CREATE USER ${user} FOR LOGIN ${user}
    EXEC sp_addrolemember N'db_owner', N'${user}'
END;
GO
--테이블 생성------------------------------------------
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

--DB에 값 넣기------------------------------------------
--INSERT INTO TutorialDB.dbo.testTable
INSERT INTO TutorialDB.dbo.Customers
   ([CustomerId],[Name],[Location],[Email],[ServiceCode],[RegDate])
VALUES
   ( 1, N'Orlando', N'Australia', N'', N'NON_TEST_SVC', CONVERT(DATETIME, '2022-05-11 00:00:01.000')  ),
   ( 2, N'Keith', N'India', N'keith0@adventure-works.com', N'TEST_SVC', CONVERT(DATETIME,'2022-05-11 00:00:01.000') ),
   ( 3, N'Donna', N'Germany', N'donna0@adventure-works.com', N'TEST_SVC', CONVERT(DATETIME, GETDATE()) ),
   ( 4, N'Janet', N'United States', N'janet1@adventure-works.com', N'TEST_SVC', CONVERT(DATETIME, GETDATE()) ),
   ( 5, N'TestName', N'TestLocation', N'TESTEmail', N'TEST_SVC',  CONVERT(DATETIME, GETDATE()))
GO