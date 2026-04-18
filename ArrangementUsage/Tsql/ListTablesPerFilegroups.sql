-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------- OBJECTS IN  A FILE GROUP ------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------





DECLARE @database_id int
DECLARE @database_name sysname
DECLARE @table_name sysname
DECLARE @index_name sysname
DECLARE @sql_string nvarchar(2000)
DECLARE @svrIP varchar(15)

DECLARE @file_size TABLE
    (
	[ServerName] varchar(15) NULL,
	[file_group] [sysname] NULL,
	[database] [sysname] NULL,
	[table] [sysname] NULL,
	--[index] [sysname] NULL,
    [file_size] [decimal](12, 2) NULL,
    [space_used] [decimal](12, 2) NULL,
    [free_space] [decimal](12, 2) NULL
    )

SELECT @svrIP = dec.local_net_address FROM sys.dm_exec_connections AS dec WHERE dec.session_id = @@SPID

SELECT TOP 1 @database_id = database_id
    ,@database_name = name
FROM sys.databases
WHERE database_id > 0
ORDER BY database_id

WHILE @database_name IS NOT NULL
BEGIN

    SET @sql_string = 'USE ' + QUOTENAME(@database_name) + CHAR(10)
    SET @sql_string = @sql_string + 'SELECT

ServerName = @svrIP,

FileGroup = FILEGROUP_NAME(a.data_space_id),

DataBaseName = @database_name,

TableName = OBJECT_NAME(p.object_id),

--IndexName = i.name,

TotalSpaceMB = sum(a.total_pages*8)/1024,

UsedSpaceMB = sum(a.used_pages*8)/1024,

FreeSpaceMB = sum((a.total_pages - a.used_pages)*8)/1024

FROM sys.allocation_units a

INNER JOIN sys.partitions p ON a.container_id = CASE WHEN a.type in(1,3) THEN p.hobt_id ELSE p.partition_id END AND p.object_id > 1024

LEFT JOIN sys.indexes i ON i.object_id = p.object_id AND i.index_id = p.index_id



GROUP BY FILEGROUP_NAME(a.data_space_id)

,OBJECT_NAME(p.object_id)

--,i.name

ORDER BY FileGroup'

INSERT INTO @file_size
        EXEC sp_executesql @sql_string,N'@svrIP varchar(15),@database_name varchar(30)',@svrIP,@database_name

    --Grab next database
    SET @database_name = NULL
    SELECT TOP 1 @database_id = database_id
        ,@database_name = name
    FROM sys.databases
    WHERE database_id > @database_id
    ORDER BY database_id
END

--File Group Sizes
SELECT ServerName,[database],[table],file_group, SUM(file_size) as file_size, SUM(space_used) as space_used, SUM(free_space) as free_space
FROM @file_size
where file_group LIKE '%May_2026%'
and [database] = 'AnalyticsStaging'
GROUP BY ServerName,[database],[table],file_group
having SUM(space_used)>0
order by 6 desc


