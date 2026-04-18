declare @StartDate date = '2021-07-08'
declare @EndDate date = '2021-10-06'

DECLARE @SQL_Cursor NVARCHAR(max)

SET @SQL_Cursor = N'
with dates ([PPN_DT]) as (
    Select convert(date, ''' + convert(varchar(10),@StartDate,121) + ''') as [Date] 

    union all 

    Select dateadd(day, 1, [PPN_DT])
    from dates
    where [PPN_DT] <= ''' + convert(varchar(10),@EndDate,121) + '''
),
sourcesystem
AS
(	SELECT CASE 
		WHEN SourceSystem IN (''MSC_SS'') THEN ''MSC_Ericsson'' 
		WHEN SourceSystem = ''TC_ACC'' THEN ''TCACC''
		ELSE REPLACE(SourceSystem,''-'','''') END										as SourceTable
		,SourceDirectory
		,LEFT(FileFilter,CHARINDEX(''*'',FileFilter)- 1) + ''_'' as FileFilter
	--FROM etl.TaskQueueDirectories WHERE TQGroup = 1  
	FROM etl.SourcesystemProcessing WHERE IsCCI = 1
),
BaseResultSet
AS
(
		SELECT dt.PPN_DT
		, SourceTable
		,[dbo].[F_Loaded_Count](SourceTable + ''_'' + convert(varchar,dt.PPN_DT,112)) LoadedCount 
		,[dbo].[F_Verified_Count](SourceDirectory,FileFilter + convert(varchar,dt.PPN_DT,112)  + ''.verf'') VerifiedCount 
		, SourceDirectory
		, FileFilter  
		,FileFilter + convert(varchar,dt.PPN_DT,112)  + ''.verf'' FileName
	FROM SourceSystem cross apply dates dt
)

SELECT PPN_DT, SourceTable,LoadedCount, VerifiedCount,FileName
			FROM BaseResultSet
			WHERE LoadedCount>0';

EXEC sp_executesql @SQL_Cursor