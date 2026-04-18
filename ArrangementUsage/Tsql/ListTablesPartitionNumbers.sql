-- List Table Partition Number

SELECT 
		OBJECT_NAME(c.object_id),a.boundary_id,a.value
	FROM 
		sys.partition_range_values a
	INNER JOIN
		sys.partition_functions b
	ON
		a.function_id = b.function_id
	INNER JOIN
		sys.dm_db_partition_stats c
	ON
		a.boundary_id = c.partition_number
	WHERE
		b.name = 'pf_Daily'
		AND object_id = OBJECT_ID('CBSSUBSCRIBER_BO');

--- Table Row Count


		SELECT 
		OBJECT_NAME(c.object_id),c.row_count
	FROM 
		sys.partition_range_values a
	INNER JOIN
		sys.partition_functions b
	ON
		a.function_id = b.function_id
	INNER JOIN
		sys.dm_db_partition_stats c
	ON
		a.boundary_id = c.partition_number
	WHERE
		b.name = 'pf_Daily'
		AND OBJECT_NAME(object_id) LIKE '%CBSSUBSCRIBER_BO_%'
		
	