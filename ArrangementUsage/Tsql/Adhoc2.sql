--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------- ANALYTICS -------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Analytics_ArrangementUsage.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Analytics', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 datetime = N'2026-04-18T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'PPN_DT', @parameter_value=@var0
DECLARE @var1 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var1
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO


SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Analytics'

--- rec
Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Facts_ArrangementUsage_1Time Load.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Analytics', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'CBSREC_Enable', @parameter_value=@var0
DECLARE @var1 datetime = N'2026-04-16T11:49:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SystemStartTime', @parameter_value=@var1
DECLARE @var2 datetime = N'2026-04-12T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtEndDate', @parameter_value=@var2
DECLARE @var3 datetime = N'2026-04-12T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtStartDate', @parameter_value=@var3
DECLARE @var4 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var4
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO


--- data
Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Facts_ArrangementUsage_1Time Load.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Analytics', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'CBSDATA_Enable', @parameter_value=@var0
DECLARE @var1 datetime = N'2026-04-16T11:47:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SystemStartTime', @parameter_value=@var1
DECLARE @var2 datetime = N'2026-04-12T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtEndDate', @parameter_value=@var2
DECLARE @var3 datetime = N'2026-04-12T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtStartDate', @parameter_value=@var3
DECLARE @var4 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var4
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO


--- mgr
Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Facts_ArrangementUsage_1Time Load.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Analytics', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'CBSMGR_Enable', @parameter_value=@var0
DECLARE @var1 datetime = N'2025-08-21T19:40:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SystemStartTime', @parameter_value=@var1
DECLARE @var2 datetime = N'2025-08-05T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtEndDate', @parameter_value=@var2
DECLARE @var3 datetime = N'2025-08-20T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtStartDate', @parameter_value=@var3
DECLARE @var4 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var4
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO



--- mon
Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Facts_ArrangementUsage_1Time Load.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Analytics', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'CBSMON_Enable', @parameter_value=@var0
DECLARE @var1 datetime = N'2026-04-16T11:50:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SystemStartTime', @parameter_value=@var1
DECLARE @var2 datetime = N'2026-04-12T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtEndDate', @parameter_value=@var2
DECLARE @var3 datetime = N'2026-04-12T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtStartDate', @parameter_value=@var3
DECLARE @var4 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var4
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO



--- sms
Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Facts_ArrangementUsage_1Time Load.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Analytics', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'CBSSMS_Enable', @parameter_value=@var0
DECLARE @var1 datetime = N'2026-04-15T20:44:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SystemStartTime', @parameter_value=@var1
DECLARE @var2 datetime = N'2026-04-14T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtEndDate', @parameter_value=@var2
DECLARE @var3 datetime = N'2026-04-14T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtStartDate', @parameter_value=@var3
DECLARE @var4 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var4
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO



--- vou
Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Facts_ArrangementUsage_1Time Load.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Analytics', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'CBSVOU_Enable', @parameter_value=@var0
DECLARE @var1 datetime = N'2026-04-16T11:48:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SystemStartTime', @parameter_value=@var1
DECLARE @var2 datetime = N'2026-04-12T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtEndDate', @parameter_value=@var2
DECLARE @var3 datetime = N'2026-04-12T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'dtStartDate', @parameter_value=@var3
DECLARE @var4 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var4
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO

SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Analytics'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------- RECONCILIATION -------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Reconciliation_Live.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Reconciliation', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 datetime = N'2026-04-17T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'EndDate', @parameter_value=@var0
DECLARE @var1 datetime = N'2026-04-17T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'StartDate', @parameter_value=@var1
DECLARE @var2 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var2
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO

SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Reconciliation' 



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------- SUBSCRIBERS -------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Analytics_SubsCalculation_UtilUnProcessDate.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Subscriber', @use32bitruntime=False, @reference_id=Null, @useanyworker=True, @runinscaleout=True
Select @execution_id
DECLARE @var0 int = 55000
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'DefaultBufferMaxRows', @parameter_value=@var0
DECLARE @var1 datetime = N'2025-08-20T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'End_Date', @parameter_value=@var1
DECLARE @var2 datetime = N'2025-08-20T00:00:00.000'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'Start_Date', @parameter_value=@var2
DECLARE @var3 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var3
EXEC [SSISDB].[catalog].[start_execution] @execution_id,  @retry_count=0
GO

SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Subscriber' 




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------- LAST LOAD -------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE 
		AnalyticsAuditing.dbo.ControlTable 
	SET	 LastLoadDate = '2021-12-05 00:00:13.000'
 FROM
		AnalyticsAuditing.dbo.ControlTable 
	WHERE
		SourceTable = 'CBSDATA' AND
		PPN_DT		= '12/4/2021'