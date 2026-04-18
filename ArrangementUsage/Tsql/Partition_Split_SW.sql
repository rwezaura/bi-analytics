--- Filegroupname
select * from sys.data_spaces where data_space_id =3

--- data_space_id =3 (Data Filegroup)
select container_id into #partition_id from sys.allocation_units where data_space_id =3

--- data_space_id <>3 (Other Filegroups)
select container_id into #partition_id from sys.allocation_units where data_space_id in (2,
3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43)

--- Tables rows > 0 (Data Filegroup)
select * from sys.partitions p inner join sys.objects o on p.object_id = o.object_id
where o.is_ms_shipped = 0 and p.index_id in (0,1) and p.rows>0 and p.partition_id in (select container_id from #partition_id)



























--SELECT x.*--,'ALTER INDEX ' + x.IndexName  +  ' ON ' + x.SchemaName + '.' + x.TableName + ' REBUILD PARTITION = ' + CONVERT(varchar,x.PartitionNumber)
--			FROM (
--SELECT
--	DB_NAME() AS 'DatabaseName'
--	,SCHEMA_NAME(p.schema_id) AS 'SchemaName'
--	,OBJECT_NAME(p.OBJECT_ID) AS 'TableName'
--	,p.index_id AS 'IndexId'
--	,CASE
--		WHEN p.index_id = 0 THEN 'HEAP'
--		ELSE i.name
--	END AS 'IndexName'
--	,p.partition_number AS 'PartitionNumber'
--	,prv_left.VALUE AS 'LowerBoundary'
--	,prv_right.VALUE AS 'UpperBoundary'
--	,CASE
--		WHEN fg.name IS NULL THEN ds.name
--		ELSE fg.name
--	END AS 'FileGroupName'
--	,CAST(p.used_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'UsedPages_MB'
--	,CAST(p.in_row_data_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'DataPages_MB'
--	,CAST(p.reserved_page_count * 0.0078125 AS NUMERIC(18,2)) AS 'ReservedPages_MB'
--	,CASE
--		WHEN p.index_id IN (0,1) THEN p.ROW_COUNT
--		ELSE 0
--	END AS 'RowCount'
--	,CASE
--		WHEN p.index_id IN (0,1) THEN 'data'
--		ELSE 'index'
--	END 'Type'
--FROM sys.dm_db_partition_stats p
--	INNER JOIN sys.indexes i
--		ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
--	INNER JOIN sys.data_spaces ds
--		ON ds.data_space_id = i.data_space_id
--	LEFT OUTER JOIN sys.partition_schemes ps
--		ON ps.data_space_id = i.data_space_id
--	LEFT OUTER JOIN sys.destination_data_spaces dds
--		ON dds.partition_scheme_id = ps.data_space_id
--		AND dds.destination_id = p.partition_number
--	LEFT OUTER JOIN sys.filegroups fg
--		ON fg.data_space_id = dds.data_space_id
--	LEFT OUTER JOIN sys.partition_range_values prv_right
--		ON prv_right.function_id = ps.function_id
--		AND prv_right.boundary_id = p.partition_number
--	LEFT OUTER JOIN sys.partition_range_values prv_left
--		ON prv_left.function_id = ps.function_id
--		AND prv_left.boundary_id = p.partition_number - 1
--WHERE
--	OBJECTPROPERTY(p.OBJECT_ID, 'ISMSSHipped') = 0
--	AND p.index_id in (0,1)
--	AND OBJECT_NAME(p.OBJECT_ID) = 'TaskQueue_Stage'
--	AND OBJECT_NAME(p.OBJECT_ID) LIKE '%CBSREC%'
--	) x
--				WHERE cast(x.UpperBoundary as date) >=  '2/1/2024' AND cast(x.UpperBoundary as date) <  '3/1/2024' AND x.[RowCount] > 0
--ORDER BY x.PartitionNumber


--SELECT 1
--	WHILE @@ROWCOUNT > 0
--	BEGIN
--	DELETE TOP (1000000)
--	from sub.SubscriberMaster
--where PPN_DT between '1/1/2021' and '7/31/2021'
--	END









