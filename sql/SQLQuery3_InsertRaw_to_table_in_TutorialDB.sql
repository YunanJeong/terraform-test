--INSERT INTO TutorialDB.dbo.testTable
INSERT INTO TutorialDB.dbo.Customers
   ([CustomerId],[Name],[Location],[Email],[ServiceCode],[RegDate])
VALUES
   ( 1, N'Orlando', N'Australia', N'', N'NON_TEST_SVC', CONVERT(DATETIME, GETDATE())  ),
   ( 2, N'Keith', N'India', N'keith0@adventure-works.com', N'TEST_SVC', CONVERT(DATETIME, GETDATE()) ),
   ( 3, N'Donna', N'Germany', N'donna0@adventure-works.com', N'TEST_SVC', CONVERT(DATETIME, GETDATE()) ),
   ( 4, N'Janet', N'United States', N'janet1@adventure-works.com', N'TEST_SVC', CONVERT(DATETIME,'2022-05-11 00:00:01.000') ),
   ( 5, N'TestName', N'TestLocation', N'TESTEmail', N'TEST_SVC', CONVERT(DATETIME, '2022-05-11 00:00:01.000') )
GO