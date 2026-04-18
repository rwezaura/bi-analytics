--- Run Analytics

declare @dt datetime = '9/5/2022' 

while ( @dt <= convert(nvarchar, cast('9/5/2022' as datetime), 126))
	begin

Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Analytics_ArrangementUsage.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Analytics', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False

DECLARE @var0 datetime = convert(nvarchar, @dt, 126)
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'PPN_DT', @parameter_value=@var0
DECLARE @var1 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var1
DECLARE @var2 bit = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'SYNCHRONIZED', @parameter_value=@var2

EXEC [SSISDB].[catalog].[start_execution] @execution_id

	set @dt = dateadd(DD,1,@dt)

end




--- Run Reconciliations

declare @dt2_start datetime = '9/2/2022' 
declare @dt2_end datetime = '9/17/2022'

Declare @execution_id2 bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Reconciliation_Live.dtsx', @execution_id=@execution_id2 OUTPUT, @folder_name=N'Analytics', @project_name=N'Reconciliation', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
select @execution_id2
DECLARE @var3 datetime = convert(nvarchar, @dt2_end, 126)
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id2,  @object_type=30, @parameter_name=N'EndDate', @parameter_value=@var3
DECLARE @var4 int = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id2,  @object_type=30, @parameter_name=N'IsManualExecution', @parameter_value=@var4
DECLARE @var5 datetime = convert(nvarchar, @dt2_start, 126)
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id2,  @object_type=30, @parameter_name=N'StartDate', @parameter_value=@var5
DECLARE @var6 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id2,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var6

EXEC [SSISDB].[catalog].[start_execution] @execution_id2





--- Run Subscribers

declare @dt3_start datetime = '9/3/2022' 
declare @dt3_end datetime = '9/4/2022'

Declare @execution_id3 bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Analytics_SubsCalculation_UtilUnProcessDate.dtsx', @execution_id=@execution_id3 OUTPUT, @folder_name=N'Analytics', @project_name=N'Subscriber', @use32bitruntime=False, @reference_id=Null, @useanyworker=False, @runinscaleout=True

DECLARE @var8 int = 60000
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id3,  @object_type=20, @parameter_name=N'DefaultBufferMaxRows', @parameter_value=@var8
DECLARE @var9 datetime = convert(nvarchar, @dt3_end, 126)
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id3,  @object_type=30, @parameter_name=N'End_Date', @parameter_value=@var9
DECLARE @var10 datetime = convert(nvarchar, @dt3_start, 126)
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id3,  @object_type=30, @parameter_name=N'Start_Date', @parameter_value=@var10
DECLARE @var11 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id3,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var11
--DECLARE @var12 bit = 1
--EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id3,  @object_type=50, @parameter_name=N'SYNCHRONIZED', @parameter_value=@var12
EXEC [SSISDB].[catalog].[add_execution_worker] @execution_id3,  @workeragent_id=N'4156c14d-08aa-4818-8331-2b4e617e9e94'

EXEC [SSISDB].[catalog].[start_execution] @execution_id3,  @retry_count=0
