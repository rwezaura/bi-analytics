--DECLARE @StartDate DATE = DATEADD(DD, -90, CAST(GETDATE() AS DATE))
--DECLARE @EndDate DATE = DATEADD(DD, @NumberDays, @StartDate)
DECLARE @StartDate DATE = '2021-08-11'
DECLARE @EndDate DATE = '2021-11-18'

--IF OBJECT_ID('etl.IsReconciled ') IS NOT NULL TRUNCATE TABLE etl.IsReconciled 

SET @SQL = N'
WHILE ( @PPN_DT_v < DATEADD(DD,0,GETDATE()) )
	BEGIN

;WITH IsReconciled ( PPN_DT,SourceTable,LoadedCount,VerifiedCount)
AS (	SELECT 
		@PPN_DT_v PPN_DT
		, REPLACE(SourceSystem,''-'','''') as SourceTable
		,[dbo].[F_Loaded_Count](REPLACE(SourceSystem,''-'','''') + ''_'' + convert(varchar,@PPN_DT_v,112)) LoadedCount 
		,[dbo].[F_Verified_Count](SourceDirectory,LEFT(FileFilter,CHARINDEX(''*'',FileFilter)- 1) + ''_'' + convert(varchar,@PPN_DT_v,112)  + ''.verf'') VerifiedCount 
	FROM etl.SourcesystemProcessing with (NOLOCK)
	WHERE IsCCI = 1
) 
INSERT INTO etl.IsReconciled ( PPN_DT,SourceTable,LoadedCount,VerifiedCount)
SELECT PPN_DT,SourceTable,LoadedCount,VerifiedCount
FROM IsReconciled
WHERE LoadedCount > 0;

SET @PPN_DT_v = DATEADD(DD,1,@PPN_DT_v)

	END';

EXEC sp_executesql @SQL,N'@PPN_DT_v DATE',@PPN_DT_v=@PPN_DT
WITH RESULT SETS NONE

