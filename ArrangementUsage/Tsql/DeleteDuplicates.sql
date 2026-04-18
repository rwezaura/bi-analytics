--Delete duplicates 

;WITH cte
     AS (SELECT A.*,ROW_NUMBER() OVER (PARTITION BY sub_id,cust_id
                                       ORDER BY ( SELECT 0)) RN
        from CBSSUBSCRIBER_BO_20210701 A ) 
		--SELECT COUNT(1) FROM cte
DELETE top(15000000) FROM cte
WHERE  RN > 1 

--Delete  multiple records 

SELECT 1
	WHILE @@ROWCOUNT > 0
	BEGIN
	DELETE TOP (1000000)
	from sub.SUBSCRIBER_B_DAILY 
	where event_date = '4/14/2021' 
	END


-- Delete duplicates  TaskQueue

	;WITH cte
     AS (SELECT A.*,ROW_NUMBER() OVER (PARTITION BY filepath
                                       ORDER BY TaskID) RN
        from AnalyticsStaging.etl.TaskQueue A
		WHERE status = 1) 
		SELECT * FROM cte
--DELETE top(15000) FROM cte
WHERE  RN > 1 AND Status = 2