select * from sub.subscriberstatus
  union all
  select top 2 ppn_dt FCT_DT
  ,ar_key
  ,sub_identity Msisdn
  ,active_time DateEnterActive
  ,active_time DateEnterActiveMIC
  ,'1900-01-01' LastRevenueActivity
  ,CASE WHEN status  =1 then 0 when status =2 then 1 else 3 end SubscriberStatus
  ,CASE WHEN status  =1 then 0 when status =2 then 1 else 3 end PreviousSubscriberStatus
  ,'Unknown' CELLID
  ,'Unknown' Region
  ,'Unknown' ARPU
  ,'Unknown' Classification
  ,'Un' Technology
  ,CASE WHEN status = 1 THEN 'IDLE'
		 WHEN status = 2 THEN 'ACTIVE'
		 WHEN status = 3 THEN 'BARRING'
		 WHEN status = 4 THEN 'SUSPENDED'
		 WHEN status = 6 THEN 'TEST'
		 WHEN status = 7 THEN 'STORAGE'
		 WHEN status = 8 THEN 'DISABLED'
		 WHEN status = 9 THEN 'POOL'
	END [OCS Status]
	,0 [Data User Status]
	,0 Decile
	,'Unknown' PortingStatus
	,'1900-01-01' PortingDate
	,pln_nm [Service Class],
	'1900-01-01' LastDataRevenueDate
	,'Unknown' IMEI
	,0 [Voice User Status]
	,0[ SMS User Status]
	,'1900-01-01' LastVoiceRevenueDate
	,'1900-01-01' LastSMSRevenueDate
	,0 Bonus_Status
	,SUB_ID SUBSCRIBER_KEY
	,3 RegistrationStatus
	,CASE WHEN status  =1 then 0 when status =2 then 1 else 3 end SubscriberStatus_MIC
	,CASE WHEN status  =1 then 0 when status =2 then 1 else 3 end PrevioussubScriberstatus_MIC
	,'Unknown' CELLID_FIRST_TOPUP
	,'Unknown' ARPU_TZ
	,0 Classification_TZ
	,'Unknown' CELLID_FIRST_ACTIVATION
	,0 Inactive_Deleted
  from #subs_bo inner join ar_dim on unq_cd_src_stm = sub_id
				inner join pln_dim b on b.unq_cd_src_stm = PRIMARY_OFFERING 