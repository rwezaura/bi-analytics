---*****************************************************************************************************************************************************************************************************************************---

------------------------------------------------------------------------			1.		DROP TABLES WITH ROWS = 0                    ------------------------------------------------------------------------	

---*****************************************************************************************************************************************************************************************************************************---

declare @database varchar(50) = 'AnalyticsStaging'
declare @schema varchar(20) = 'dbo'
declare @dt date = DATEADD(DD,-1,GETDATE())
declare @objstr varchar(6) = LEFT(CONVERT(VARCHAR,@dt,112),6)


SELECT DISTINCT
	'IF  EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N''[' + @schema + '].[' + OBJECT_NAME(x.OBJECT_ID)  + ']'') AND type in (N''U''))
	DROP TABLE [' + @schema + '].[' + OBJECT_NAME(x.OBJECT_ID)  + ']'
FROM 
	(
		SELECT 
			OBJECT_ID
		FROM
			SYS.PARTITIONS
		WHERE 
			OBJECT_NAME(OBJECT_ID) LIKE '%_' + @objstr + '%' AND ROWS = 0 AND PARTITION_NUMBER BETWEEN $partition.pf_Daily(DATEADD(DD,-10,@dt)) AND  $partition.pf_Daily(@dt)
	EXCEPT
		SELECT 
			OBJECT_ID
		FROM
			SYS.PARTITIONS
		WHERE 
			OBJECT_NAME(OBJECT_ID) LIKE '%_202408%' AND ROWS > 0 AND PARTITION_NUMBER BETWEEN $partition.pf_Daily(DATEADD(DD,-10,@dt)) AND  $partition.pf_Daily(@dt)
	) x




---*****************************************************************************************************************************************************************************************************************************---

------------------------------------------------------------------------			2.		CREATE CLUSTERED COLUMN STORE INDEX (CCI)                    ------------------------------------------------------------------------	

---*****************************************************************************************************************************************************************************************************************************---

select 'CREATE CLUSTERED COLUMNSTORE INDEX [CCIX_' + reverse(substring(reverse(o.name),charindex('_',reverse(o.name))+1,len(reverse(o.name))-9)) + '_CCI] ON [dbo].[' + o.name + '] WITH (DROP_EXISTING = ON, COMPRESSION_DELAY = 0)'
--,reverse(substring(reverse(o.name),charindex('_',reverse(o.name))+1,len(reverse(o.name))-9)),o.name
from sys.indexes i inner join
(select object_id,name from sys.objects where right(name,8) = '20240823' and right(left(right(name,8),6),2) in ('08')) o
on i.object_id = o.object_id
where i.type_desc = 'CLUSTERED' 
order by 1




---*****************************************************************************************************************************************************************************************************************************---

------------------------------------------------------------------------			3.		PARTITION SWITCH ONLY TABLES WITH ROWS > 0                    ------------------------------------------------------------------------	

---*****************************************************************************************************************************************************************************************************************************---

declare @database varchar(50) = 'AnalyticsStaging'
declare @schema varchar(20) = 'dbo'
declare @dt date = DATEADD(DD,-5,GETDATE())
declare @objstr varchar(6) = LEFT(CONVERT(VARCHAR,@dt,112),6)


SELECT DISTINCT
	'ALTER TABLE [' + @database + '].[' + @schema + '].[' + OBJECT_NAME(OBJECT_ID) + '] SWITCH PARTITION ' + CONVERT(VARCHAR,PARTITION_NUMBER) + ' TO [' + @database + '].[' + @schema + '].[' + LEFT(OBJECT_NAME(OBJECT_ID),LEN(OBJECT_NAME(OBJECT_ID))-9) + '] PARTITION ' + CONVERT(VARCHAR,PARTITION_NUMBER) + ' WITH (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE))'
FROM 
	SYS.PARTITIONS 
WHERE 
	OBJECT_NAME(OBJECT_ID) LIKE '%_' + @objstr + '%' AND ROWS > 0 AND PARTITION_NUMBER  BETWEEN $partition.pf_Daily(DATEADD(DD,-10,@dt)) AND  $partition.pf_Daily(@dt)






