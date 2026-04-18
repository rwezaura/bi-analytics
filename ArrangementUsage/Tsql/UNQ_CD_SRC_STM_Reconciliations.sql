--- Check Duplicates

-- CBSREC
;WITH cte
     AS (
			SELECT A.*,ROW_NUMBER() OVER (PARTITION BY CAST(CDR_ID AS VARCHAR(25))+':'+ CAST(CDR_SUB_ID AS VARCHAR(24))
														,CONVERT(VARCHAR(50),replace(replace(replace(convert(varchar(30),[CREATE_DATE], 20),'-',''),':',''),' ',''))
                                       ORDER BY ( SELECT 0)) RN
			FROM AnalyticsStaging.dbo.CBSREC A 
			WHERE PPN_DT = '8/20/2025'
		) 
		SELECT COUNT(1) FROM cte
--DELETE 
--		top(15000000) FROM cte
WHERE  RN > 1 


-- CBSDATA
;WITH cte
     AS (
			SELECT A.*,ROW_NUMBER() OVER (PARTITION BY CAST(CDR_ID AS VARCHAR(25))+':'+ CAST(CDR_SUB_ID AS VARCHAR(24))
														,CONVERT(VARCHAR(50),replace(replace(replace(convert(varchar(30),[CREATE_DATE], 20),'-',''),':',''),' ',''))
                                       ORDER BY ( SELECT 0)) RN
			FROM AnalyticsStaging.dbo.CBSDATA A 
			WHERE PPN_DT = '3/21/2026'
		) 
		SELECT COUNT(1) FROM cte
--DELETE 
--		top(15000000) FROM cte
WHERE  RN = 1 


-- CBSMGR
;WITH cte
     AS (
			SELECT A.*,ROW_NUMBER() OVER (PARTITION BY CAST(CDR_ID AS VARCHAR(25))+':'+ CAST(CDR_SUB_ID AS VARCHAR(24))
														,CONVERT(VARCHAR(50),replace(replace(replace(convert(varchar(30),[CREATE_DATE], 20),'-',''),':',''),' ',''))
                                       ORDER BY ( SELECT 0)) RN
			FROM AnalyticsStaging.dbo.CBSMGR A 
			WHERE PPN_DT = '8/20/2025'
		) 
		--SELECT COUNT(1) FROM cte
DELETE 
		top(15000000) FROM cte
WHERE  RN > 1 


-- CBSMON
;WITH cte
     AS (
			SELECT A.*,ROW_NUMBER() OVER (PARTITION BY CAST(CDR_ID AS VARCHAR(25))+':'+ CAST(CDR_SUB_ID AS VARCHAR(24))
														,CONVERT(VARCHAR(50),replace(replace(replace(convert(varchar(30),[CREATE_DATE], 20),'-',''),':',''),' ',''))
                                       ORDER BY ( SELECT 0)) RN
			FROM AnalyticsStaging.dbo.CBSMON A 
			WHERE PPN_DT = '10/10/2023'
		) 
		SELECT COUNT(1) FROM cte
--DELETE 
		--top(15000000) FROM cte
WHERE  RN > 1 


-- CBSVOU
;WITH cte
     AS (
			SELECT A.*,ROW_NUMBER() OVER (PARTITION BY COALESCE
															(NULLIF
																(CAST(CDR_ID AS VARCHAR(50)), ''), cast(CDR_ID as varchar(15))+cast(MainOfferingID as varchar(10))+cast(TIME_STAMP as varchar(25)))		
														,CONVERT(VARCHAR(50),CONVERT(VARCHAR(14),TIME_STAMP,112) + REPLACE(CONVERT(VARCHAR(14),TIME_STAMP,108),':',''))	
                                       ORDER BY ( SELECT 0)) RN
			FROM AnalyticsStaging.dbo.CBSVOU A 
			WHERE PPN_DT = '8/20/2025'
		) 
		--SELECT COUNT(1) FROM cte
DELETE 
		top(15000000) FROM cte
WHERE  RN > 1 





;WITH cte
     AS (
			SELECT A.*,ROW_NUMBER() OVER (PARTITION BY UNQ_CD_SRC_STM1,UNQ_CD_SRC_STM2
                                       ORDER BY ( SELECT 0)) RN
			FROM [SrvBI02].AnalyticsTD.dbo.VOICE_SVC_FCT A 
			WHERE FCT_DT = '4/3/2026' --and SRC_OBJ_KEY = 248 
		) 
		SELECT COUNT(1) FROM cte
--DELETE 
--		top(15000000) FROM cte
WHERE  RN = 1 



--- SMS Reconciliation

declare @dt date = '10/10/2023'

select 
		CAST(CDR_ID AS VARCHAR(50)) AS 'UNQ_CD_SRC_STM1'
	   ,CAST(CDR_BATCH_ID AS VARCHAR(50)) + convert(varchar(50),CONVERT(VARCHAR(14),CREATE_DATE,112) + REPLACE(CONVERT(VARCHAR(14),CREATE_DATE,108),':',''))AS 'UNQ_CD_SRC_STM2'
from 
		AnalyticsStaging.dbo.CBSSMS with (nolock)
where 
		PPN_DT between dateadd(D,0,@dt) and dateadd(D,1,@dt) 
		and CUST_LOCAL_START_DATE >= convert(varchar(8),@dt,112) + '000000' and CUST_LOCAL_START_DATE < convert(varchar(8),dateadd(D,1,@dt),112) + '000000'
		except
select 
		UNQ_CD_SRC_STM1
		,UNQ_CD_SRC_STM2
from 
		[SrvBI02].AnalyticsTD.dbo.VAS_SVC_FCT with (nolock)
where 
		FCT_DT = @dt
		--and SRC_OBJ_KEY = 249