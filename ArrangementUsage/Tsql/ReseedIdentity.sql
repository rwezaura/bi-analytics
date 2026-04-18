/****** Script for SelectTopNRows command from SSMS  ******/
SELECT max([id])
  FROM [AnalyticsAuditing].[dbo].[sysssislog]


  truncate table  [AnalyticsAuditing].[dbo].[sysssislog]

  alter table [AnalyticsAuditing].[dbo].[sysssislog]
  alter column [id] bigint

  DBCC CHECKIDENT ('sysssislog', RESEED, 1)