SET NOCOUNT ON
GO

DECLARE @First DATE = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-45, 0)

DECLARE @Last DATE =  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-34, -1)

EXEC [dbo].[Empty_FileGroup_FULL] @First,@Last

-- sqlcmd -d AnalyticsStaging -i C:\ArrangementUsage\Tsql\sqlcmd_PURGE3.sql -o C:\Users\bi_analytics\Documents\Purge3.sql -h -1

-- sqlcmd -d AnalyticsStaging -i C:\Users\bi_analytics\Documents\Purge3.sql