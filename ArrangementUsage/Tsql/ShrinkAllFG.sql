SELECT
	'DBCC SHRINKFILE (N''' + x.FileName + ''' , ' + CONVERT(varchar,CAST(CEILING((x.TotalSizeMB - x.FreeSpaceMB)) as INT)) + ')
	GO' AS Result
FROM
	(
		SELECT 
			name AS FileName,
			size/128.0 AS TotalSizeMB,
			size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB,
			(size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0)/(size/128.0) PercentFree
		FROM 
			sys.database_files
	) x
WHERE
	x.PercentFree >= 0.96