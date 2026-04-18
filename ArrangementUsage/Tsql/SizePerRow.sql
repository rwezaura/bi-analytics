


--SELECT x.NAME,SUM(x.max_length) BYTES
--FROM
--	(
--		select name,max_length from sys.columns
--		where OBJECT_NAME(object_id) = 'AR_LAST_EV_FCT'
--		and name in ('AR_KEY', 'SUB_LAST_IN_ONNET_VOICE_EV_DT', 'SUB_LAST_IN_OTHR_VOICE_EV_DT', 'SUB_LAST_OUT_VOICE_EV_DT', 'SUB_LAST_IN_ONNET_SMS_EV_DT
--		', 'SUB_LAST_IN_OTHR_SMS_EV_DT', 'SUB_LAST_OUT_SMS_EV_DT', 'SUB_LAST_VAS_PRCH_MON_EV_DT', 'SUB_LAST_VAS_PRCH_MGR_EV_DT', 'SUB_LAST_VAS_PRCH_MCL_EV_DT
--		', 'SUB_LAST_VAS_PRCH_COM_EV_DT', 'LAST_RBT_PRCH_EV_DT', 'SUB_LAST_DATA_EV_DT', 'SUB_LAST_LOAN_EV_DT', 'SUB_LAST_MFS_EV_DT', 'LAST_RLD_EV_DT
--		', 'SUB_LAST_BTR_EV_DT', 'SUB_LAST_MON_EVC_EV_DT', 'SUB_LAST_BONUS_EV_DT')
--		UNION
--			select name,max_length from sys.columns
--		where OBJECT_NAME(object_id) = 'AR_DIM'
--		and name in ('MSISDN_DD','UNQ_CD_SRC_STM')
--	) x
--GROUP BY ROLLUP(x.NAME)

	
DECLARE @SpaceUsaged TABLE 
(
	[name] varchar(50),
	[rows] varchar(20),
	[reserved] varchar(20),
	[data] varchar(20),
	[index_size] varchar(20),
	[unused] varchar(20)

)


DECLARE @TableName VARCHAR(50) = 'AR_DIM'

DECLARE @DefaultBufferSize int = 1048576
DECLARE @DefaultBufferMaxRows int = 10000

INSERT @SpaceUsaged
EXEC sp_spaceused @TableName

SELECT 'Actual_Table_Size' kpi,cast(LEFT([data],LEN([data])-3) as bigint)*1024 value FROM @SpaceUsaged
union all
SELECT 'Actual_Row_Size' kpi,cast(LEFT([data],LEN([data])-3) as bigint)*1024/[rows] value FROM @SpaceUsaged
union all
SELECT 'Expected_Number_Of_Rows_Per_Bucket' kpi,@DefaultBufferMaxRows/(cast(LEFT([data],LEN([data])-3) as bigint)*1024/[rows]) value FROM @SpaceUsaged
