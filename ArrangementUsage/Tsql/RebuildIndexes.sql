--- Rebuild INDEXES with PARTITIONS (OPTION I)

SELECT x.*,'ALTER INDEX ' + x.IndexName  +  ' ON ' + SCHEMA_NAME(o.schema_id) + '.' + x.TableName + ' REBUILD PARTITION = ' + CONVERT(varchar,x.PartitionNumber) Rebuilds
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




--- Rebuild INDEXES with PARTITIONS (OPTION II)

declare @dt date = '12/31/2021'

while (@dt >= '1/1/2021')
begin

declare @tsql nvarchar(max)

declare @pf varchar(10) = $partition.pf_Daily(@dt)

set @tsql = N'
select ''ALTER INDEX ['' + i.name + ''] ON ['' + schema_name(o.schema_id) +''].['' + o.name + ''] REBUILD PARTITION = '  + @pf + ' '' + 
case when i.type = 1 then ''WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE)''
	 when i.type = 5 then ''WITH (DATA_COMPRESSION = COLUMNSTORE)'' end
from sys.indexes i inner join sys.objects o on i.object_id = o.object_id
where o.name in (''VOICE_SVC_FCT'')'
print @tsql + char(13) + 'union all'

--EXEC sp_executesql @tsql

set @dt = dateadd(DD,-1,@dt)

end



--- Rebuild INDEXES (GENERAL)

select 'ALTER INDEX [' + i.name + '] ON [' + schema_name(o.schema_id) +'].[' + o.name + '] REBUILD PARTITION = ALL ' +
case when i.type = 1 then 'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE)'
	 when i.type = 5 then 'WITH (DATA_COMPRESSION = COLUMNSTORE)' end
from sys.indexes i inner join sys.objects o on i.object_id = o.object_id
where o.name in ('CBSAR_ADJUSTMENT',
'CBSREC',
'CBSDATA',
'CBSACCT_BALANCE_BO',
'CBSBC_CUSTOMER',
'CBSBC_SUB_IDEN',
'CBSACCT_BO',
'CBSBC_ACCT',
'CBSCUSTOMER_BO',
'CBSMGR',
'CBSOFFERING_INST_BO',
'CBSPE_FREE_UNIT',
'CBSFREE_UNIT_BO',
'CBSBC_SUB_BRAND',
'CBSBC_SUB_EXTINFO',
'CBSG_MEMBER_BO',
'CBSBC_SUB_PROP',
'CBSBC_G_MEMBER',
'CBSAR_TRANSFER',
'CBSBC_PROD_PROP',
'CBSMON',
'CBSSCT',
'TaskQueue',
'TaskQueue_Stage',
'CBSBC_SUB_GROUP',
'CBSCLR',
'CBSCM_BALANCE_TYPE',
'CBSBC_SUB_IDEN_DEF',
'CBSVERF')