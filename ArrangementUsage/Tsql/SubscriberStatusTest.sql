SELECT
	Msisdn
	, DateEnterActive
	, DateEnterActiveMIC
	, LastRevenueActivity
	, SubscriberStatus
	, PreviousSubscriberStatus
	, CELLID
	, convert(varchar(50),Region ) Region
	, ARPU
	, Classification
	, Technology
	, [Data User Status]
	, LastDataRevenueDate
	, IMEI
	,[Voice User Status]
	,[SMS User Status]
	,LastVoiceRevenueDate
	,LastSMSRevenueDate
	,CAST(LTRIM(RTRIM(SUBSCRIBER_KEY)) as bigint) 'SNAPSHOT_SUBSCRIBE_KEY'
	,SubscriberStatus_MIC
	,PrevioussubScriberstatus_MIC
	,CELLID_FIRST_TOPUP
	,CELLID_FIRST_ACTIVATION
	,ARPU_TZ
	,Classification_TZ
	,[OCS Status] 'OCS_STATUS_SNAPSHOT'
	,[Service Class] 'Service_Class_SNAPSHOT'
	,Decile
	,Inactive_Deleted
	into #subsprevious
FROM
	sub.SubscriberStatus WITH(NOLOCK)
WHERE
	FCT_DT = '5/31/2021' 


	SELECT
	LTRIM(RTRIM(SERVICENUMBER))SERVICENUMBER
  , FIRSTACTIVEDDATE
  , MAINPRODUCTKEY 'Service Class'
  , CASE WHEN CURRENTSTATE = 1 THEN 'IDLE'
		 WHEN CURRENTSTATE = 2 THEN 'ACTIVE'
		 WHEN CURRENTSTATE = 3 THEN 'BARRING'
		 WHEN CURRENTSTATE = 4 THEN 'SUSPENDED'
		 WHEN CURRENTSTATE = 6 THEN 'TEST'
		 WHEN CURRENTSTATE = 7 THEN 'STORAGE'
		 WHEN CURRENTSTATE = 8 THEN 'DISABLED'
		 WHEN CURRENTSTATE = 9 THEN 'POOL'
	END 'OCS_STATUS'
  , SUSPENDENDDATE 'SUB_SUSPND_END_DT'
  , ACTIVEFLAG
  ,CAST(LTRIM(RTRIM(SUBSCRIBERKEY)) as bigint) 'SUBSCRIBERKEY'
  into #subsmaster
FROM
	[SRVBI01].AnalyticsStaging.sub.SubscriberMaster WITH(NOLOCK)
WHERE
	PPN_DT = '6/1/2021'  
--	and LTRIM(RTRIM(SERVICENUMBER)) in ('714901980',
--'652240792',
--'652256624',
--'652262281',
--'652263352',
--'652265081',
--'652267159',
--'652269791',
--'652274454',
--'652277741'
--)
ORDER BY
	LTRIM(RTRIM(SUBSCRIBERKEY))

	--- 7052671
	select * into #subsmerged
	from #subsprevious full outer join #subsmaster on SERVICENUMBER = Msisdn

	--- 7052671
	select b.AR_KEY,a.* into #ar_dim_lkp
	from #subsmerged a inner join AR_DIM b on UNQ_CD_SRC_STM = SNAPSHOT_SUBSCRIBE_KEY

	--- 7052671
	select b.AR_KEY,a.* into #ar_dim_lkp
	from #subsmerged a inner join AR_DIM b on UNQ_CD_SRC_STM = SNAPSHOT_SUBSCRIBE_KEY


	SELECT
	 AR_KEY AR_KEY_LKP
	 ,LAST_RGA_DT
	 into #ar_last_ev
FROM
	dbo.AR_LAST_EV_FCT
	where 1=2

	-- 
	insert into #ar_last_ev
	EXEC [sub].[AR_LAST_EV_FCT_Lookup]  '6/1/2021'

	--- 2191761
	select b.AR_KEY_LKP, a.* into #ar_last_ev_lkp
	from #ar_dim_lkp a inner join #ar_last_ev b on a.AR_KEY = b.AR_KEY_LKP