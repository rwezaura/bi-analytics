--- query
update etl.SourcesystemProcessing 
--set FileFilter = 'mgr_*20240807*.unl'
  set FileFilter = 'mgr_*.unl'
--  select * 
from etl.SourcesystemProcessing 
where sourcesystemid= 33




--- rec
--- query
update etl.SourcesystemProcessing 
--set FileFilter = 'rec_*20260415*.unl'
  set FileFilter = 'rec_*.unl'
--  select * 
from etl.SourcesystemProcessing 
where sourcesystemid= 29

Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Staging_CBS_CDRS_CCI.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Staging', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 29
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SourceSystemID', @parameter_value=@var0
DECLARE @var1 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var1
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO


--- sms
--- query
update etl.SourcesystemProcessing 
--set FileFilter = 'sms_*20260415*.unl'
  set FileFilter = 'sms_*.unl'
--  select * 
from etl.SourcesystemProcessing 
where sourcesystemid= 30

Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Staging_CBS_CDRS_CCI.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Staging', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 30
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SourceSystemID', @parameter_value=@var0
DECLARE @var1 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var1
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO


--- data
--- query
update etl.SourcesystemProcessing 
--set FileFilter = 'data_*20260414*.unl'
  set FileFilter = 'data_*.unl'
--  select * 
from etl.SourcesystemProcessing 
where sourcesystemid= 31

Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Staging_CBS_CDRS_CCI.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Staging', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 31
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SourceSystemID', @parameter_value=@var0
DECLARE @var1 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var1
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO


--- mon
--- query
update etl.SourcesystemProcessing 
--set FileFilter = 'mon_*20260414*.unl'
  set FileFilter = 'mon_*.unl'
--  select * 
from etl.SourcesystemProcessing 
where sourcesystemid= 32

Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Staging_CBS_CDRS_CCI.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Staging', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 32
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SourceSystemID', @parameter_value=@var0
DECLARE @var1 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var1
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO


--- mgr
--- query
update etl.SourcesystemProcessing 
--set FileFilter = 'mgr_*20260415*.unl'
  set FileFilter = 'mgr_*.unl'
--  select * 
from etl.SourcesystemProcessing 
where sourcesystemid= 33

Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Staging_CBS_CDRS_CCI.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Staging', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 33
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SourceSystemID', @parameter_value=@var0
DECLARE @var1 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var1
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO



--- vou
--- query
update etl.SourcesystemProcessing 
--set FileFilter = 'vou_*20260415*.unl'
  set FileFilter = 'vou_*.unl'
--  select * 
from etl.SourcesystemProcessing 
where sourcesystemid= 34

Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Master_Staging_CBS_CDRS_CCI.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Analytics', @project_name=N'Staging', @use32bitruntime=False, @reference_id=Null, @runinscaleout=False
Select @execution_id
DECLARE @var0 int = 34
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'SourceSystemID', @parameter_value=@var0
DECLARE @var1 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var1
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO






