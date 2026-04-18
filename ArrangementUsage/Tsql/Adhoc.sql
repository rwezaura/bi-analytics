select * from AnalyticsAuditing.dbo.ETLBatch with (nolock) where subjectarea = 'ArrangementUsage' and layer = 'Analytics_AR' and status = 1

select status,count(1) from AnalyticsStaging.etl.TaskQueue with (nolock) where ppn_dt = '7/16/2024' group by status

select sourcesystem,count(1) from AnalyticsStaging.etl.TaskQueue with (nolock) where ppn_dt >= '7/16/2024' group by sourcesystem order by 2 desc

--           SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where parameter_name in ('SourceSystem','FileFilter')  

--			 SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Staging' and parameter_name = 'PPN_DT' order by created_time 

--			 SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Staging' and parameter_name = 'SourcesystemID' 

--			 SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Utility' and parameter_name = 'LOGGING_LEVEL'

--			 SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Analytics' and parameter_name = 'PPN_DT' 

--			 SELECT TOP (1000) * FROM [master].[dbo].[vw_Pending_Operations] where project_name = 'Subscriber' 

--			 SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where project_name = 'Reconciliation'

--			 SELECT TOP (1000) * FROM [master].[dbo].[vw_Running_Operations] where package_name = 'Stage_Zip_Extract_GZ.dtsx' and parameter_name = 'SourceDirectory' 

--           SELECT  * FROM AnalyticsStaging.etl.sourcesystemprocessing where isdump =0

-- SELECT DISTINCT kill_operation, process_id FROM [master].[dbo].[vw_Running_Operations] where DATEDIFF(MI,created_time,getdate()) > 30 and package_name = 'Stage_Zip_Extract_GZ.dtsx'

--                      sp_whoisactive 

EXEC [SSISDB].[catalog].[stop_operation] 350776

  select 'IF EXIST ' + a.Filepath + ' move /Y ' + a.Filepath + ' ' + b.archivedirectory + '\' + convert(varchar(10),datecompleted,121) Command
  --,reverse(LEFT(reverse(FilePath),charindex('\',reverse(FilePath))-1))
	from AnalyticsStaging.etl.TaskQueue a with (nolock)
			inner join AnalyticsStaging.etl.sourcesystemprocessing b  on a.sourcesystem = b.sourcesystem
	where --a.sourcesystem = 'CBS-data' 
	 a.ppn_dt between '2024-10-20' and '2024-10-20'
	--and a.filepath like '%data_113_177_00101_20241020224133_53187.unl%'
	--and a.datecompleted is not null
	and a.status = 1


	  select 'IF EXIST ' + a.Filepath + ' move /Y ' + a.Filepath + ' ' + b.archivedirectory + '\' + convert(varchar(10),datecompleted,121) Command
	  ,'IF EXIST ' + a.Filepath + '.gz move /Y ' + a.Filepath + '.gz ' + b.archivedirectory + '\' + convert(varchar(10),datecompleted,121) Command2
	  ,'IF EXIST ' + a.Filepath + ' move /Y ' + a.Filepath + ' ' + 'A:\Corrupted' Command3
  --,reverse(LEFT(reverse(FilePath),charindex('\',reverse(FilePath))-1))
	from AnalyticsStaging.etl.TaskQueue a with (nolock)
			inner join AnalyticsStaging.etl.sourcesystemprocessing b  on a.sourcesystem = b.sourcesystem
	where  a.sourcesystem = 'CBS-OFFERING_INST_BO' 
	--and a.ppn_dt between '2021-10-01' and '2021-11-22'
	--and a.filepath like '%data_113_177_00101_20210920083857_72325.unl%'
	and a.status = 3

	

--- Delete Archives

	select 'IF EXIST ' + b.archivedirectory + '\' + convert(varchar(10),PPN_DT,121) + reverse(left(reverse(a.Filepath),charindex('\',reverse(a.Filepath)))) + ' DEL ' + b.archivedirectory + '\' + convert(varchar(10),PPN_DT,121) + reverse(left(reverse(a.Filepath),charindex('\',reverse(a.Filepath)))) AS Command
  --,reverse(LEFT(reverse(FilePath),charindex('\',reverse(FilePath))-1))
	from AnalyticsStaging.etl.TaskQueue a with (nolock)
			inner join AnalyticsStaging.etl.sourcesystemprocessing b  on a.sourcesystem = b.sourcesystem
	where --a.sourcesystem = 'CBS-data' 
	 a.ppn_dt between '2024-10-20' and '2024-10-20'
	--and a.filepath like '%data_113_177_00101_20241020224133_53187.unl%'
	--and a.datecompleted is not null
	and a.status = 1

	select sourcesystem,PPN_DT,count(1)
	--,count(1)/(DATEDIFF(HOUR,min(dateentered),max(dateentered) )) Per_Sec,min(dateentered) min_dateentered,max(dateentered) max_dateentered 
	from  AnalyticsStaging.etl.TaskQueue_Stage with (nolock) 
	--where sourcesystem = 'CBS-REC'
	--where ppn_dt >= '2021-08-01'
	group by  sourcesystem,PPN_DT



		select sourcesystem,status,count(1)
	--,count(1)/(DATEDIFF(HOUR,min(dateentered),max(dateentered) )) Per_Sec,min(dateentered) min_dateentered,max(dateentered) max_dateentered 
	from  AnalyticsStaging.etl.TaskQueue with (nolock) 
	where sourcesystem = 'CBS-REC'
	and ppn_dt = '2021-08-31'
	group by  sourcesystem,status

	select TQ.*
	from AnalyticsStaging.etl.TaskQueue_Stage TQT with (nolock) 
		inner join AnalyticsStaging.etl.TaskQueue TQ with (nolock) ON TQ.FilePath = TQT.FilePath AND TQ.PPN_DT = TQT.PPN_DT AND TQ.SourceSystem = TQT.SourceSystem
	where   TQ.status = 3

	select * into #TQ  from AnalyticsStaging.etl.TaskQueue TQT with (nolock) where status = 3 
	and not exists (select 1 from #TQ TQ where TQ.FilePath = TQT.FilePath AND TQ.PPN_DT = TQT.PPN_DT AND TQ.SourceSystem = TQT.SourceSystem)



	create clustered index cindx on #TQ(PPN_DT)
	create nonclustered index ncindx on #TQ(FilePath,SourceSystem)

	SELECT 1
	WHILE ROWCOUNT > 0
	BEGIN
	DELETE TOP (100000) TQT
	FROM AnalyticsStaging.etl.TaskQueue_Stage TQT 
		 inner join #TQ AS TQ  ON TQ.FilePath = TQT.FilePath AND TQ.PPN_DT = TQT.PPN_DT AND TQ.SourceSystem = TQT.SourceSystem
	END

	select * from AnalyticsStaging.etl.TaskQueue 
	where sourcesystem = 'cbs-data'
	and filepath like '%data_107_177_00101_20210915151818_26128.unl%'
	--and sourcesystem = 'cbs-data'


	select sourcesystem,ppn_dt,count(1) from AnalyticsStaging.etl.TaskQueue with (nolock)
	where status = 1
	group by sourcesystem,ppn_dt
	order by 1,2
	
	SELECT * INTO AnalyticsStaging.etl.TaskQueue_20210731 
	FROM AnalyticsStaging.etl.TaskQueue with (nolock)  WHERE  status = 3 and PPN_DT < '8/1/2021'

	delete FROM AnalyticsStaging.etl.TaskQueue   WHERE sourcesystem = 'cbs-data' and  status = 2 and PPN_DT <= '9/21/2021'

	(3213016 rows affected)

	select * from AnalyticsStaging.etl.SourcesystemProcessing 


	update AnalyticsStaging.etl.TaskQueue  set status = 1
	--   select *
	FROM AnalyticsStaging.etl.TaskQueue 
	WHERE ppn_dt >= '1/1/2022' and ppn_dt < '2022-07-11'
	--and sourcesystem = 'CBS-evcdump'  
	and status = 3
	and datecompleted is null

	

	select top 3 * from cbsvou with (nolock) where ppn_dt = '7/10/2022' and filename like '%vou_109_172_00101_20220710222334_65459.unl%'
	

	delete
	--  select *
	FROM AnalyticsStaging.etl.TaskQueue 
	where PPN_DT = '10/20/2024'
	and sourcesystem = 'cbs-data'
	and status = 1
	and filepath like '%rec_107_172_00101_20241020133551_33773.unl%'

	vou_107_172_00101_20240712140118_31564.unl

	--mgr_108_172_00101_20240712133847_28321
	--vou_109_177_00101_20240712070713_14544
	--rec_107_177_00101_20240712133944_30697


	D:\SRC_DATA\WORK_FOLDER\CBS\CDR\MGR\mgr_109_177_00101_20241021142138_87737.unl
	D:\SRC_DATA\WORK_FOLDER\CBS\CDR\VOU\vou_112_177_00101_20241020202858_45434.unl