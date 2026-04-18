SET NOCOUNT ON
GO

DECLARE @str VARCHAR(6) = CONVERT(VARCHAR(6),DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-4, 0),112)

SELECT
N'IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + TABLE_SCHEMA + '.' + TABLE_NAME + ''') AND type in (N''U''))
DROP TABLE ' + TABLE_SCHEMA + '.' + TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME like '%_' + @str + '%'

-- sqlcmd -d AnalyticsStaging -i C:\ArrangementUsage\Tsql\sqlcmd_purge_dumps.sql -o C:\Users\bi_analytics\Documents\purge_dumps.sql -h -1

-- sqlcmd -d AnalyticsStaging -i C:\Users\bi_analytics\Documents\purge_dumps.sql