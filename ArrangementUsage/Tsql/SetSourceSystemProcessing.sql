

  SELECT
  'INSERT INTO [AnalyticsStaging].[etl].[SourcesystemProcessing]( 
       [Sourcesystem]
      ,[PackageName]
      ,[SourceDirectory]
      ,[ArchiveDirectory]
      ,[FileFilter]
      ,[TaskQueueStageTable]
      ,[FileCount]
      ,[Threads]
      ,[ETLBatchSubjectArea]
      ,[ETLBatchLayer]
      ,[IsDump]
      ,[IsCCI]
      ,[IsCompressed]
      ,[Priority]
      ,[ActiveFlag]
      ,[RetentionPeriod])
 SELECT TOP 1
	   REPLACE(''' + TABLE_NAME + ''',''MFS'',''MFS-'') AS [Sourcesystem]
      ,REPLACE(''' + TABLE_NAME + ''',''MFS'',''Stage_MFS'') + ''.dtsx'' AS [PackageName]
      ,''D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\' + TABLE_NAME + ''' AS [SourceDirectory]
      ,''D:\SRC_DATA\ARC_FOLDER\CBS\DUMP\'+ TABLE_NAME + ''' AS [ArchiveDirectory]
      ,LOWER(''' + TABLE_NAME + ''') + ''*.csv'' AS [FileFilter]
      ,''_' +  TABLE_NAME + ''' AS [TaskQueueStageTable]
      ,1 AS [FileCount]
      , 1AS  [Threads]
      ,''' + TABLE_NAME + '''
      ,''Staging''AS [ETLBatchLayer]
      ,0 AS [IsDump]
      ,0 AS [IsCCI]
      ,0 AS [IsCompressed]
      ,1 AS [Priority]
      ,1 AS [ActiveFlag]
      ,3 AS [RetentionPeriod]
  FROM [AnalyticsStaging].[etl].[SourcesystemProcessing]'
  FROM information_schema.TABLES 
where TABLE_NAME in (
--'MFSTRANS_FULL',
--'MFSRESET_PIN_STATUS',
--'MFSUNREGISTERED_CUST',
--'MFSSNE_TRANS_DETAIL',
--'MFSGIMAC_TRANS_DETAIL',
--'MFSCANAL_TRANS_DETAIL',
--'MFSTRANS_DETAIL',
--'MFSMOBILE_ACCOUNT',
--'MFSTRANS_FLOW_DETAIL',
'MFSTRANS_INFO',
'MFSTRANS_ADDS',
'MFSTRANS_ACCOUNT_ENTRY'
)









--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



DECLARE @Stream VARCHAR(40) = 'SYS_STAFF'

INSERT INTO [AnalyticsStaging].[etl].[SourcesystemProcessing]( 
       [Sourcesystem]
      ,[PackageName]
      ,[SourceDirectory]
      ,[ArchiveDirectory]
      ,[FileFilter]
      ,[TaskQueueStageTable]
      ,[FileCount]
      ,[Threads]
      ,[ETLBatchSubjectArea]
      ,[ETLBatchLayer]
      ,[IsDump]
      ,[IsCCI]
      ,[IsCompressed]
      ,[Priority]
      ,[ActiveFlag]
      ,[RetentionPeriod])
  SELECT
	   REPLACE([Sourcesystem],'ACCT_BALANCE_BO',@Stream)
      ,REPLACE([PackageName],'ACCT_BALANCE_BO',@Stream)
      ,REPLACE([SourceDirectory],'ACCT_BALANCE_BO',@Stream)
      ,REPLACE([ArchiveDirectory],'ACCT_BALANCE_BO',@Stream)
      ,REPLACE([FileFilter],'acct_balance_bo',LOWER(@Stream))
      ,REPLACE([TaskQueueStageTable],'ACCT_BALANCE_BO',@Stream)
      ,1 [FileCount]
      ,1 [Threads]
      ,REPLACE([ETLBatchSubjectArea],'ACCT_BALANCE_BO',@Stream)
      ,'Staging' [ETLBatchLayer]
      ,0 [IsDump]
      ,0 [IsCCI]
      ,0 [IsCompressed]
      ,1 [Priority]
      ,1 [ActiveFlag]
      ,3 [RetentionPeriod]
  FROM [AnalyticsStaging].[etl].[SourcesystemProcessing]
  WHERE SourcesystemID = 46

  SELECT *  FROM [AnalyticsStaging].[etl].[SourcesystemProcessing] WHERE [Sourcesystem] LIKE '%' + @Stream + '%'