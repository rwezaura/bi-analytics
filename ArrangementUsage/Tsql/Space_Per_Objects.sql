SELECT D.[Month],
	   [TableName],
	   [Used],
	   [Total],
	   [RowCount],
	   [ColumnCount],
	   [FileCount]
FROM (
		SELECT [Month],
			   [TableName],
			   [Used],
			   [Total],
			   [RowCount],
			   [ColumnCount]
FROM (
				SELECT DATENAME(MONTH,cast(x.UpperBoundary as date)) AS 'Month',
				TableName,
				SUM(UsedPages_MB) AS 'Used',
				SUM(DataPages_MB) AS 'Total',
				SUM([RowCount]) AS 'RowCount'
-- SELECT x.*,'ALTER INDEX ' + x.IndexName  +  ' ON ' + SCHEMA_NAME(o.schema_id) + '.' + x.TableName + ' REBUILD PARTITION = ' + CONVERT(varchar,x.PartitionNumber) Rebuilds
			FROM (
SELECT
	DB_NAME() AS 'DatabaseName'
	,OBJECT_NAME(p.OBJECT_ID) AS 'TableName'
	,p.OBJECT_ID AS 'ObjectId'
	,p.index_id AS 'IndexId'
	,CASE
		WHEN p.index_id = 0 THEN 'HEAP'
		ELSE i.name
	END AS 'IndexName'
	,p.partition_number AS 'PartitionNumber'
	,prv_left.VALUE AS 'LowerBoundary'
	,prv_right.VALUE AS 'UpperBoundary'
	,CASE
		WHEN fg.name IS NULL THEN ds.name
		ELSE fg.name
	END AS 'FileGroupName'
	,CAST(p.used_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'UsedPages_MB'
	,CAST(p.in_row_data_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'DataPages_MB'
	,CAST(p.reserved_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'ReservedPages_MB'
	,CASE
		WHEN p.index_id IN (0,1) THEN p.ROW_COUNT
		ELSE 0
	END AS 'RowCount'
	,CASE
		WHEN p.index_id IN (0,1) THEN 'data'
		ELSE 'index'
	END 'Type'
FROM sys.dm_db_partition_stats p
	INNER JOIN sys.indexes i
		ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
	INNER JOIN sys.data_spaces ds
		ON ds.data_space_id = i.data_space_id
	LEFT OUTER JOIN sys.partition_schemes ps
		ON ps.data_space_id = i.data_space_id
	LEFT OUTER JOIN sys.destination_data_spaces dds
		ON dds.partition_scheme_id = ps.data_space_id
		AND dds.destination_id = p.partition_number
	LEFT OUTER JOIN sys.filegroups fg
		ON fg.data_space_id = dds.data_space_id
	LEFT OUTER JOIN sys.partition_range_values prv_right
		ON prv_right.function_id = ps.function_id
		AND prv_right.boundary_id = p.partition_number
	LEFT OUTER JOIN sys.partition_range_values prv_left
		ON prv_left.function_id = ps.function_id
		AND prv_left.boundary_id = p.partition_number - 1
WHERE
	OBJECTPROPERTY(p.OBJECT_ID, 'ISMSSHipped') = 0
	AND p.index_id in (0,1)
	--AND OBJECT_NAME(p.OBJECT_ID) = 'CBSREC'
	--AND OBJECT_NAME(p.OBJECT_ID) LIKE '%CBSREC%'
	) x 
	INNER JOIN sys.objects o
		ON o.OBJECT_ID = x.ObjectId 
				WHERE cast(x.UpperBoundary as date) >=  '1/1/2023' AND cast(x.UpperBoundary as date) <  '1/1/2024' AND x.UsedPages_MB > 0.02 -- AND x.[RowCount] > 0
				AND x.IndexId = 1
order by x.UsedPages_MB DESC




GROUP BY DATENAME(MONTH,cast(x.UpperBoundary as date)),TableName) R LEFT OUTER JOIN (SELECT TABLE_NAME,COUNT(COLUMN_NAME) AS ColumnCount 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'AnalyticsStaging' AND TABLE_SCHEMA = 'dbo'
--AND TABLE_NAME IN ('CBSREC','CBSSMS','CBSVOU','CBSDATA','CBSOREC','CBSCOM','CBSOSMS','CBSODATA','CBSLOAN','CBSMON','CBSOMON','EVC_REC','CBSMGR','CBSOMGR',
--	'EVC_REP','EVC_KPI','CBSOVOU','TP_VAU','INOPAC','CBSOCOM','USSD','VMS','TP_SJD','REMEDY','CMS','CBSGFT','CBSREC_IR','CBSSMS_IR','EVC_TRA','CBSDATA_IR','CBE_SUBSCRIBER',
--	'CBSCLR','TP_VCT','TP_SJS','UVC_ACT','TIGOMATIC','EVC_LOG','EVC_DUMP','TP_VAC','EVC_LOAN')
GROUP BY TABLE_NAME) C ON C.TABLE_NAME = R.[TableName]) D LEFT OUTER JOIN (SELECT DATENAME(MONTH,PPN_DT) AS 'Month',CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
'CBS-OCOM','CBS-GFT','CBS-REC_IR','CBS-SMS_IR','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') ELSE SourceSystem END SourceSystem,COUNT(1) FIleCount
FROM AnalyticsStaging.dbo.TaskQueue with (nolock)
WHERE PPN_DT >= '1/1/2017'
AND CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
'CBS-OCOM','CBS-GFT','CBS-REC_IR','CBS-SMS_IR','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') ELSE SourceSystem END
 IN ('CBSREC','CBSSMS','CBSVOU','CBSDATA','CBSOREC','CBSCOM','CBSOSMS','CBSODATA','CBSLOAN','CBSMON','CBSOMON','EVC_REC','CBSMGR','CBSOMGR',
	'EVC_REP','EVC_KPI','CBSOVOU','TP_VAU','INOPAC','CBSOCOM','USSD','VMS','TP_SJD','REMEDY','CMS','CBSGFT','CBSREC_IR','CBSSMS_IR','EVC_TRA','CBSDATA_IR','CBE_SUBSCRIBER',
	'CBSCLR','TP_VCT','TP_SJS','UVC_ACT','TIGOMATIC','EVC_LOG','EVC_DUMP','TP_VAC','EVC_LOAN')
GROUP BY DATENAME(MONTH,PPN_DT),CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
'CBS-OCOM','CBS-GFT','CBS-REC_IR','CBS-SMS_IR','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') ELSE SourceSystem END) F ON F.SourceSystem = D.[TableName] AND F.[Month] = D.[Month]
--ORDER BY DATENAME(MONTH,cast(x.UpperBoundary as date)) DESC





---- Number of Columns

SELECT TABLE_NAME,COUNT(COLUMN_NAME) 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'AnalyticsStaging' AND TABLE_SCHEMA = 'dbo'
AND TABLE_NAME IN ('CBSREC','CBSSMS','CBSVOU','CBSDATA','CBSOREC','CBSCOM','CBSOSMS','CBSODATA','CBSLOAN','CBSMON','CBSOMON','EVC_REC','CBSMGR','CBSOMGR',
	'EVC_REP','EVC_KPI','CBSOVOU','TP_VAU','INOPAC','CBSOCOM','USSD','VMS','TP_SJD','REMEDY','CMS','CBSGFT','CBSREC_IR','CBSSMS_IR','EVC_TRA','CBSDATA_IR','CBE_SUBSCRIBER',
	'CBSCLR','TP_VCT','TP_SJS','UVC_ACT','TIGOMATIC','EVC_LOG','EVC_DUMP','TP_VAC','EVC_LOAN')
GROUP BY TABLE_NAME




---- Number of Files

SELECT DATENAME(MONTH,PPN_DT) AS 'Month',CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
'CBS-OCOM','CBS-GFT','CBS-REC_IR','CBS-SMS_IR','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') ELSE SourceSystem END SourceSystem,COUNT(1)
FROM AnalyticsStaging.dbo.TaskQueue
WHERE PPN_DT >= '1/1/2017'
--AND CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
--'CBS-OCOM','CBS-GFT','CBS-REC_IR','CBS-SMS_IR','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') ELSE SourceSystem END
-- IN ('CBSREC','CBSSMS','CBSVOU','CBSDATA','CBSOREC','CBSCOM','CBSOSMS','CBSODATA','CBSLOAN','CBSMON','CBSOMON','EVC_REC','CBSMGR','CBSOMGR',
--	'EVC_REP','EVC_KPI','CBSOVOU','TP_VAU','INOPAC','CBSOCOM','USSD','VMS','TP_SJD','REMEDY','CMS','CBSGFT','CBSREC_IR','CBSSMS_IR','EVC_TRA','CBSDATA_IR','CBE_SUBSCRIBER',
--	'CBSCLR','TP_VCT','TP_SJS','UVC_ACT','TIGOMATIC','EVC_LOG','EVC_DUMP','TP_VAC','EVC_LOAN')
GROUP BY DATENAME(MONTH,PPN_DT),CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
'CBS-OCOM','CBS-GFT','CBS-REC_IR','CBS-SMS_IR','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') ELSE SourceSystem END



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------- Files, Records and Rows Counts -------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



DECLARE @FCT_DT DATE = '1/1/2017'

DECLARE @Files TABLE(
[Month] VARCHAR(50),
SourceSystem VARCHAR(50),
FileCount INT);

INSERT INTO @Files
SELECT DATENAME(MONTH,PPN_DT) AS 'Month',CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
'CBS-OCOM','CBS-GFT','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') 
WHEN SourceSystem = 'TP_VAC' THEN 'TP_ACCOUNTS'
WHEN SourceSystem = 'TP_VAU' THEN 'TP_ACCOUNT_USER'
WHEN SourceSystem = 'TP_SJS' THEN 'TP_TRANSACTIONS_STATUS'
WHEN SourceSystem = 'TP_VCT' THEN 'VCREDIT_TRANSFER'
WHEN SourceSystem = 'UVC_ACT' THEN 'UVC_ACTIVATION'
WHEN SourceSystem IN ('CBS-RECIR','CBS-SMSIR','CBS-DATAIR') THEN REPLACE(REPLACE(SourceSystem,'CBS-','CBS'),'IR','_IR')  ELSE SourceSystem END SourceSystem,COUNT(1) FIleCount
FROM AnalyticsStaging.dbo.TaskQueue with (nolock)
WHERE PPN_DT >= @FCT_DT
AND CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
'CBS-OCOM','CBS-GFT','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') ELSE SourceSystem END
 IN ('CBSREC','CBSSMS','CBSVOU','CBSDATA','CBSOREC','CBSCOM','CBSOSMS','CBSODATA','CBSLOAN','CBSMON','CBSOMON','EVC_REC','CBSMGR','CBSOMGR',
	'EVC_REP','EVC_KPI','CBSOVOU','TP_VAU','INOPAC','CBSOCOM','USSD','VMS','TP_SJD','REMEDY','CMS','CBSGFT','CBSREC_IR','CBSSMS_IR','EVC_TRA','CBSDATA_IR','CBE_SUBSCRIBER',
	'CBSCLR','TP_VCT','TP_SJS','UVC_ACTIVATION','TIGOMATIC','EVC_LOG','EVC_DUMP','TP_VAC','EVC_LOAN')
GROUP BY DATENAME(MONTH,PPN_DT),CASE WHEN SourceSystem IN ('CBS-REC','CBS-SMS','CBS-VOU','CBS-DATA','CBS-OREC','CBS-COM','CBS-OSMS','CBS-ODATA','CBS-LOAN','CBS-MON','CBS-OMON','CBS-MGR','CBS-OMGR','CBS-OVOU',
'CBS-OCOM','CBS-GFT','CBS-CLR') THEN REPLACE(SourceSystem,'CBS-','CBS') 
WHEN SourceSystem = 'TP_VAC' THEN 'TP_ACCOUNTS'
WHEN SourceSystem = 'TP_VAU' THEN 'TP_ACCOUNT_USER'
WHEN SourceSystem = 'TP_SJS' THEN 'TP_TRANSACTIONS_STATUS'
WHEN SourceSystem = 'TP_VCT' THEN 'VCREDIT_TRANSFER'
WHEN SourceSystem = 'UVC_ACT' THEN 'UVC_ACTIVATION' 
WHEN SourceSystem IN ('CBS-RECIR','CBS-SMSIR','CBS-DATAIR') THEN REPLACE(REPLACE(SourceSystem,'CBS-','CBS'),'IR','_IR') ELSE SourceSystem END

DECLARE @Columns TABLE(
TABLE_NAME VARCHAR(50),
ColumnCount INT);

INSERT INTO @Columns
SELECT TABLE_NAME,COUNT(COLUMN_NAME) AS ColumnCount 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'AnalyticsStaging' AND TABLE_SCHEMA = 'dbo'
AND TABLE_NAME IN ('CBSREC','CBSSMS','CBSVOU','CBSDATA','CBSOREC','CBSCOM','CBSOSMS','CBSODATA','CBSLOAN','CBSMON','CBSOMON','EVC_REC','CBSMGR','CBSOMGR',
	'EVC_REP','EVC_KPI','CBSOVOU','TP_ACCOUNT_USER','INOPAC','CBSOCOM','USSD','VMS','TP_SJD','REMEDY','CMS','CBSGFT','CBSREC_IR','CBSSMS_IR','EVC_TRA','CBSDATA_IR','CBE_SUBSCRIBER',
	'CBSCLR','VCREDIT_TRANSFER','TP_TRANSACTIONS_STATUS','UVC_ACTIVATION','TIGOMATIC','EVC_LOG','EVC_DUMP','TP_ACCOUNTS','EVC_LOAN')
GROUP BY TABLE_NAME

SELECT D.[Month],
	   [TableName],
	   [Used],
	   [Total],
	   [RowCount],
	   [ColumnCount],
	   [FileCount]
FROM (
		SELECT [Month],
			   [TableName],
			   [Used],
			   [Total],
			   [RowCount],
			   [ColumnCount]
FROM (
				SELECT DATENAME(MONTH,cast(x.UpperBoundary as date)) AS 'Month',
				TableName,
				SUM(UsedPages_MB) AS 'Used',
				SUM(DataPages_MB) AS 'Total',
				SUM([RowCount]) AS 'RowCount'
--SELECT x.*
			FROM (
SELECT
	DB_NAME() AS 'DatabaseName'
	,OBJECT_NAME(p.OBJECT_ID) AS 'TableName'
	,p.index_id AS 'IndexId'
	,CASE
		WHEN p.index_id = 0 THEN 'HEAP'
		ELSE i.name
	END AS 'IndexName'
	,p.partition_number AS 'PartitionNumber'
	,prv_left.VALUE AS 'LowerBoundary'
	,prv_right.VALUE AS 'UpperBoundary'
	,CASE
		WHEN fg.name IS NULL THEN ds.name
		ELSE fg.name
	END AS 'FileGroupName'
	,CAST(p.used_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'UsedPages_MB'
	,CAST(p.in_row_data_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'DataPages_MB'
	,CAST(p.reserved_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'ReservedPages_MB'
	,CASE
		WHEN p.index_id IN (0,1) THEN p.ROW_COUNT
		ELSE 0
	END AS 'RowCount'
	,CASE
		WHEN p.index_id IN (0,1) THEN 'data'
		ELSE 'index'
	END 'Type'
FROM sys.dm_db_partition_stats p
	INNER JOIN sys.indexes i
		ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
	INNER JOIN sys.data_spaces ds
		ON ds.data_space_id = i.data_space_id
	LEFT OUTER JOIN sys.partition_schemes ps
		ON ps.data_space_id = i.data_space_id
	LEFT OUTER JOIN sys.destination_data_spaces dds
		ON dds.partition_scheme_id = ps.data_space_id
		AND dds.destination_id = p.partition_number
	LEFT OUTER JOIN sys.filegroups fg
		ON fg.data_space_id = dds.data_space_id
	LEFT OUTER JOIN sys.partition_range_values prv_right
		ON prv_right.function_id = ps.function_id
		AND prv_right.boundary_id = p.partition_number
	LEFT OUTER JOIN sys.partition_range_values prv_left
		ON prv_left.function_id = ps.function_id
		AND prv_left.boundary_id = p.partition_number - 1
WHERE
	OBJECTPROPERTY(p.OBJECT_ID, 'ISMSSHipped') = 0
	AND p.index_id in (0,1)
	AND OBJECT_NAME(p.OBJECT_ID) IN ('CBSREC')
	--,'CBSSMS','CBSVOU','CBSDATA','CBSOREC','CBSCOM','CBSOSMS','CBSODATA','CBSLOAN','CBSMON','CBSOMON','EVC_REC','CBSMGR','CBSOMGR',
	--'EVC_REP','EVC_KPI','CBSOVOU','TP_ACCOUNT_USER','INOPAC','CBSOCOM','USSD','VMS','TP_SJD','REMEDY','CMS','CBSGFT','CBSREC_IR','CBSSMS_IR','EVC_TRA','CBSDATA_IR','CBE_SUBSCRIBER',
	--'CBSCLR','VCREDIT_TRANSFER','TP_TRANSACTIONS_STATUS','UVC_ACTIVATION','TIGOMATIC','EVC_LOG','EVC_DUMP','TP_ACCOUNTS','EVC_LOAN')
	) x
				WHERE cast(x.UpperBoundary as date) >= @FCT_DT AND x.UsedPages_MB > 0

GROUP BY DATENAME(MONTH,cast(x.UpperBoundary as date)),TableName) R LEFT OUTER JOIN @Columns C ON C.TABLE_NAME = R.[TableName]) D LEFT OUTER JOIN @Files F ON F.SourceSystem = D.[TableName] AND F.[Month] = D.[Month]
--ORDER BY DATENAME(MONTH,cast(x.UpperBoundary as date)) DESC

















SELECT
t.name as TableName,i.name as IndexName,
p.partition_id as partitionID,
p.partition_number,rows, fg.name
FROM sys.tables AS t 
         INNER JOIN sys.indexes AS i ON (t.object_id = i.object_id)
     INNER JOIN sys.partitions AS p ON (t.object_id = p.object_id and i.index_id = p.index_id)
        INNER JOIN sys.destination_data_spaces dds ON (p.partition_number = dds.destination_id)
        INNER JOIN sys.filegroups AS fg ON (dds.data_space_id = fg.data_space_id)
WHERE (t.name = 'PGW') and (i.index_id IN (0,1))