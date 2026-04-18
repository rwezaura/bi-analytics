
select * into #delete_ARKeys_11 from (
select ar_key from #not_delete_ARKeys_1
except 
select ar_key from #not_delete_ARKeys_2
) x

select * into  from AR_LAST_EV_FCT with (nolock) a where a.FCT_DT = '3/1/2025'
and exists ( select 1 from #not_delete_ARKeys b where a.AR_KEY = b.AR_KEY)

select * from AR_LAST_EV_FCT a where a.FCT_DT = '10/1/2023'
and AR_KEY = '14608704'

select * into #not_delete_ARKeys_18 from sub.SubscriberStatus a where a.FCT_DT = '3/1/2025'
and exists ( select 1 from #not_delete_ARKeys_17 b where a.AR_KEY = b.AR_KEY) and Inactive_Deleted = 0

--- Query 1

;WITH cte
     AS (SELECT A.*,ROW_NUMBER() OVER (PARTITION BY A.unq_cd_src_stm,A.MSISDN_DD,A.COS_NAME_DD,A.EXPIRETIME,A.SUBSCRIBERSTATUS
                                       ORDER BY  A.AR_KEY DESC) RN
        from AR_DIM A 
		--WHERE A.MSISDN_DD in ('99280600')
		) 
		SELECT * 
		into #not_delete_ARKeys_17
		FROM cte
--DELETE top(20000) FROM cte
WHERE  RN > 1
and not (ACTVN_DT_KEY <> '-1')
--and not exists ( select 1 from #not_delete_ARKeys_16 b where cte.AR_KEY = b.AR_KEY)
--and cast(dateentered as date) >= '5/22/2023'

--- Query 2

;WITH cte
     AS (SELECT A.*,ROW_NUMBER() OVER (PARTITION BY A.unq_cd_src_stm,A.MSISDN_DD,A.COS_NAME_DD,A.EXPIRETIME
                                       ORDER BY  A.AR_KEY) RN
        from AR_DIM A 
		--WHERE A.MSISDN_DD in ('96080101')
		) 
		--SELECT * 
		--into #not_delete_ARKeys_5
		--FROM cte
DELETE top(500) FROM cte
WHERE  RN > 1
--and not (ACTVN_DT_KEY <> '-1')
and exists ( select 1 from #delete_ARKeys_11 b where cte.AR_KEY = b.AR_KEY)
--and cast(dateentered as date) >= '5/22/2023'


--- Query 3

;WITH cte
     AS (SELECT A.*,ROW_NUMBER() OVER (PARTITION BY A.unq_cd_src_stm,A.MSISDN_DD,A.EXPIRETIME
                                       ORDER BY  A.AR_KEY) RN
        from AR_DIM A 
		--WHERE A.MSISDN_DD in ('93579854')
		) 
		--SELECT * 
		--into	#not_delete_ARKeys_6
		--FROM cte
DELETE top(2000) FROM cte
WHERE  RN > 1
and not (ACTVN_DT_KEY <> '-1')
--and exists ( select 1 from #delete_ARKeys_11 b where cte.UNQ_CD_SRC_STM = b.UNQ_CD_SRC_STM)
--and cast(dateentered as date) >= '5/22/2023'

rollback


select count(1) from AR_DIM

96932844
99652520
update AR_DIM set SUBSCRIBERSTATUS = 0
--select * from AR_DIM 
where exists ( select 1 from #not_delete_arkeys3_status b where AR_DIM.unq_cd_src_stm = b.SUBSCRIBER_KEY)
and AR_DIM.SUBSCRIBERSTATUS = 0

select 2156*2

select * from AR_DIM_Deleted3


select * from #not_delete_ARKeys

select * from #not_delete_ARKeys_16

select * from AR_DIM where MSISDN_DD = '93948001'

17017577	93948001 
17020981	95031405 
17020994	95202046 
17017520	95255578 

17017577
3522520

17017542
17017577

select * into AR_DIM_Deleted  from #delete_arkeys

EXEC etl.DT_DIM_Lookup
16554596
16554765

select * from SRC_OBJ_DIM where SRC_OBJ_KEY =  164

select * from AR_DIM where UNQ_CD_SRC_STM = '100000000244248337' order by UNQ_CD_SRC_STM,AR_KEY

select * from sub.SubscriberStatus with (nolock) where fct_dt = '2/26/2025' and Msisdn = '93948001'
select * from sub.SubscriberStatus with (nolock) where fct_dt = '2/27/2025' and Msisdn = '93948001'
select * from sub.SubscriberStatus with (nolock) where fct_dt = '3/1/2025' and Msisdn = '93948001'

select * from AR_DIM_Deleted3 where  cast(dateentered as date) >= '3/1/2023' order by UNQ_CD_SRC_STM,AR_KEY

select * from AR_DIM_Deleted2 where msisdn_dd = '91845173'
16554596
select  CAST(HASHBYTES('MD5', '101840000231524641') AS BINARY(20))
16554765
16554765
select * from WLT_DIM where COALESCE(STAGE_AUDT_KEY, 0) = 105176992
where UNQ_CD_SRC_STM in  ( 5258,5259 , 5260 ) 
order by 
16554765
6906
EXEC dbo.WLT_Source 

select *  from WLT_DIM where UNQ_CD_SRC_STM = 2000


select count(*)Nbre,UNQ_CD_SRC_STM,MSISDN_DD into #t5
from AnalyticsTD.dbo.AR_DIM
group by UNQ_CD_SRC_STM,MSISDN_DD order by 1 desc

select UNQ_CD_SRC_STM,MSISDN_DD into #dups4 from #t5 where Nbre>=2 and MSISDN_DD = '94844959' 

select * from #dups3



select LEN(CONTROL_MD5),* from AR_DIM where  MSISDN_DD = '95881118' and UNQ_CD_SRC_STM='105920000264516416'

select * from AR_DIM_Deleted2 where ar_key = 12460199

select * from AR_DIM_Deleted3 where ar_key = 12460199

select * from AR_DIM where UNQ_CD_SRC_STM = '103570000241952426'

select * from AR_LAST_EV_FCT where fct_dt = '5/27/2023' and ar_key = 12437013

select *from sub.SubscriberStatus a where a.FCT_DT = '5/27/2023' and ar_key = 12437013

select *from sub.SubscriberStatus a where a.FCT_DT = '5/27/2023' and Msisdn = '93579854'

18785515
18516548


select * from [srvbi01].analyticsstaging.etl.taskqueue with (nolock) where ppn_dt>= '6/1/2023' and stage_audit_key in ( 18785515)

select * from [srvbi01].analyticsstaging.etl.taskqueue with (nolock) where ppn_dt>= '6/1/2023' and stage_audit_key in ( 18516548)

select * from [srvbi01].analyticsstaging.etl.taskqueue with (nolock) where ppn_dt= '6/10/2023' and sourcesystem = 'CBS-SUBSCRIBER_BO'

select LEN(CONTROL_MD5),* from AR_DIM where  MSISDN_DD = '99280600' 

select * from AR_DIM

select * from #t3

select top 10 * from AR_DIM

select ar_key,Msisdn,SUBSCRIBER_KEY,DT_KEY,[OCS Status],* from ar_dim_ipdate inner join DT_DIM on DT = DateEnterActiveMIC

select * from DT_DIM