declare @FCT_DT date = '6/1/2021'

-- Tracking

select FCT_DT,b.UNQ_CD_SRC_STM,COUNT(1)
from dbo.AR_TRCK_FCT a with (nolock)
		inner join dbo.AR_ST_DIM b
ON AR_ST_KEY = AR_TZ_ST_KEY
where FCT_DT between '9/1/2021' and '9/1/2021'
--AND AR_ST_KEY IN (5,20)
GROUP BY FCT_DT,b.UNQ_CD_SRC_STM

-- Movement

select a.FCT_DT,c.control_md5,COUNT(1) 
from dbo.staging_AR_MVMT_FCT_OUT a with (nolock)
		inner join dbo.AR_MVMT_RSN_TP_DIM b
ON a.AR_MVMT_RSN_TP_KEY = b.AR_MVMT_RSN_TP_KEY
			inner join dbo.AR_MVMT_TP_DIM c
ON a.AR_MVMT_TP_KEY = c.AR_MVMT_TP_KEY
where FCT_DT between '9/1/2021' and '9/1/2021'
--AND a.AR_MVMT_TP_KEY IN (1,2,3)
GROUP BY a.FCT_DT,c.control_md5


ALTER SCHEMA sub   
    TRANSFER OBJECT::dbo.SubscriberStatus;

select fct_dt,
sum(case when SubscriberStatus=1 and previoussubscriberstatus=0 then 1 else 0 end) Activations,
sum(case when coalesce(previoussubscriberstatus,0) not in (0,1) and SubscriberStatus=1 then 1 else 0 end) Reconnections,
sum(case when coalesce(SubscriberStatus,0)<>1 and previoussubscriberstatus=1 then 1 else 0 end) Disconnections,
--sum(case when [OCS Status] = 'SUSPENDED' and coalesce(SubscriberStatus,0) <> 1 and DATEDIFF(DD,LastRevenueActivity,FCT_DT) <= 89 and inactive_deleted = 0 then 1 else 0 end) Suspended,
sum(case when SubscriberStatus=1 OR [OCS Status] = 'SUSPENDED' and coalesce(SubscriberStatus,0) <> 1 and DATEDIFF(DD,LastRevenueActivity,FCT_DT) <= 89 and inactive_deleted = 0 then 1 else 0 end)Active      
FROM sub.SubscriberStatus with (nolock)
where FCT_DT >= '2/26/2025' --and FCT_DT < '12/27/2021'
group by fct_dt
order by 1

 ---  Life Cycle

 declare @FCT_FT date = '2/4/2025'

 if object_id('tempdb..#Opening') is not null DROP TABLE #Opening
 if object_id('tempdb..#Activations') is not null DROP TABLE #Activations
 if object_id('tempdb..#Reconnections') is not null DROP TABLE #Reconnections
 if object_id('tempdb..#Disconnections') is not null DROP TABLE #Disconnections
 if object_id('tempdb..#Closing') is not null DROP TABLE #Closing

 if object_id('tempdb..#Active') is not null DROP TABLE #Active
 if object_id('tempdb..#Inactive') is not null DROP TABLE #Inactive
 if object_id('tempdb..#Base') is not null DROP TABLE #Base
 if object_id('tempdb..#Missing') is not null DROP TABLE #Missing
 if object_id('tempdb..#Extra') is not null DROP TABLE #Extra

  if object_id('tempdb..#Inconsistence') is not null DROP TABLE #Inconsistence

  --Opening
  select ar_key into #Opening FROM sub.SubscriberStatus with (nolock) where  FCT_DT = dateadd(DD,-1,@FCT_FT) and SubscriberStatus=1

 --Activations
 select ar_key into #Activations FROM sub.SubscriberStatus with (nolock) where  FCT_DT = @FCT_FT and  SubscriberStatus=1 and previoussubscriberstatus=0

 --Reconnections
  select ar_key into #Reconnections FROM sub.SubscriberStatus with (nolock) where  FCT_DT = @FCT_FT and  coalesce(previoussubscriberstatus,0) not in (0,1) and SubscriberStatus=1

 --Disconnections
  select ar_key into #Disconnections FROM sub.SubscriberStatus with (nolock) where  FCT_DT = @FCT_FT and  coalesce(SubscriberStatus,0)<>1 and previoussubscriberstatus=1

 --Closing
  select ar_key into #Closing FROM sub.SubscriberStatus with (nolock) where  FCT_DT = @FCT_FT and SubscriberStatus=1

--Active
  select x.ar_key into #Active
  from (
  select ar_key from #Opening union select ar_key from #Activations union select ar_key from #Reconnections
) x

--Inactive
 select ar_key into #Inactive from #Disconnections

 --Base
   select x.ar_key into #Base
  from (
 select ar_key from #active except select ar_key from #inactive
 ) x

--Checks

select x.ar_key,x.reason into #Inconsistence 
from (
 select ar_key,'In Opening and Activations' reason from #Opening
 intersect 
 select ar_key,'In Opening and Activations' from #Activations
 union all
 select ar_key, 'In Opening and Reconnections' from #Opening
 intersect 
 select ar_key,'In Opening and Reconnections' from #Reconnections
 union all
 select ar_key,'In Activations and Reconnections' from #Activations
 intersect 
 select ar_key,'In Activations and Reconnections' from #Reconnections
 union all
 select ar_key,'In Activations and Disconnections' from #Activations
 intersect 
 select ar_key,'In Activations and Disconnections' from #Disconnections
 union all
 select ar_key,'In Reconnections and Disconnections' from #Reconnections
 intersect 
 select ar_key,'In Reconnections and Disconnections' from #Disconnections
 union all
 select ar_key,'In Closing and Disconnections' from #Closing
 intersect 
 select ar_key,'In Closing and Disconnections' from #Disconnections
 union all
 select ar_key,'In Activations except Closing' from #Activations
 except
 select ar_key,'In Activations except Closing' from #Closing
 union all
 select ar_key,'In Reconnections except Closing' from #Reconnections
 except
 select ar_key,'In Reconnections except Closing' from #Closing
 union all
 select ar_key,'In Disconnections except Opening' from #Disconnections
 except 
 select ar_key,'In Disconnections except Opening' from #Opening
 union all
 select ar_key,'Excess from Closing' from #Closing
 except 
 select ar_key,'Excess from Closing' from #Base
 union all
 select ar_key,'Missing from Closing' from #Base 
 except 
 select ar_key,'Missing from Closing'  from #Closing
) x


select reason,count(1) from #Inconsistence group by reason

--Analysis

select x.ar_key into #inconsistence from (
select ar_key from #Active
intersect
select ar_key from #Inactive
) x


 select *  FROM sub.SubscriberStatus with (nolock) where  FCT_DT = '5/22/2023' and ar_key in (select ar_key FROM #inconsistence) 

 select * FROM sub.SubscriberStatus with (nolock) where  FCT_DT = '5/23/2023'  and ar_key in (select ar_key FROM #inconsistence)

 select *  FROM sub.SubscriberStatus with (nolock) where  FCT_DT = '5/22/2023' and ar_key in (11563286,11533104,11553462) 

 select * FROM sub.SubscriberStatus with (nolock) where  FCT_DT = '5/23/2023'  and ar_key in (11563286,11533104,11553462) 
 	

-- Fix
update sub.SubscriberStatus  set   previoussubscriberstatus = 1
-- select DATEdiff(DD,lastrevenueactivity,fct_dt),* 
FROM sub.SubscriberStatus 
where FCT_DT = '8/1/2021'
and ar_key in (select ar_key FROM #Missing)


select * FROM AR_DIM_Deleted3 with (nolock) where  ar_key in (select ar_key FROM #inconsistence)

select * FROM AR_DIM_Deleted2 with (nolock) where  ar_key in (select ar_key FROM #inconsistence)

select * FROM AR_DIM_Deleted with (nolock) where  ar_key in (select ar_key FROM #inconsistence)



 select * into #obase from sub.SubscriberStatus where FCT_DT = '10/15/2024' and SubscriberStatus=1

  select * into #obase_na from sub.SubscriberStatus where FCT_DT = '10/15/2024' and SubscriberStatus<>1

--create table #b2b(msisdn varchar(20))
-- create clustered index indx on #obase_na(msisdn)
 

 select count(1),count(distinct msisdn) from #b2b

 select * from #obase a where exists (select 1 from #b2b b where a.msisdn = b.msisdn)

  select * from #obase_na a where exists (select 1 from #b2b b where a.msisdn = b.msisdn) and Inactive_Deleted = 0


  select * into #ocs from [srvbi01].analyticsstaging.dbo.CBSSUBSCRIBER_BO_20241017 a where exists (select 1 from #b2b b where a.sub_identity = b.msisdn)

   select * from #ocs a where exists (select 1 from #obase_na b where a.sub_identity = b.msisdn) and DATEDIFF(DD,ppn_dt,eff_date) > 0

   select * from #ocs a where exists (select 1 from #obase b where a.sub_identity = b.msisdn) and DATEDIFF(DD,ppn_dt,eff_date) > 0

   select * into #check from sub.SubscriberStatus where FCT_DT = '10/15/2024' and [OCS Status] = 'ACTIVE' and coalesce(SubscriberStatus,0) <> 1 and DATEDIFF(DD,LastRevenueActivity,FCT_DT) <= 89 and inactive_deleted = 0