-- Average CPU Load

SELECT COUNT(*) Schedulers,
AVG(current_tasks_count) AS [Avg Current Task Count],
AVG(runnable_tasks_count) AS [Avg Runnable Task Count],
AVG(work_queue_count) AS [Avg Work Queue Count],
AVG(pending_disk_io_count) AS [Avg Pending DiskIO Count],
AVG(current_workers_count) AS [Avg Current Worker Count],
AVG(active_workers_count) AS [Avg Active Worker Count]
FROM sys.dm_os_schedulers WITH (NOLOCK)
WHERE scheduler_id < 255;

-- Total CPU Load
				
SELECT COUNT(*) Schedulers,
SUM(current_tasks_count) AS [Sum Current Task Count],
SUM(runnable_tasks_count) AS [Sum Runnable Task Count],
SUM(work_queue_count) AS [Sum Work Queue Count],
SUM(pending_disk_io_count) AS [Sum Pending DiskIO Count],
SUM(current_workers_count) AS [Sum Current Worker Count],
SUM(active_workers_count) AS [Sum Active Worker Count]
FROM sys.dm_os_schedulers WITH (NOLOCK)
WHERE scheduler_id < 255;


-- Get Average Task Counts (run multiple times)  (Avg Task Counts)


   SELECT AVG(current_tasks_count) AS [Avg Task Count], 
   AVG(work_queue_count) AS [Avg Work Queue Count],
   AVG(runnable_tasks_count) AS [Avg Runnable Task Count],
   AVG(pending_disk_io_count) AS [Avg Pending DiskIO Count]
   FROM sys.dm_os_schedulers WITH (NOLOCK)
   WHERE scheduler_id < 255 OPTION (RECOMPILE);
     
   -- Sustained values above 10 suggest further investigation in that area
   -- High Avg Task Counts are often caused by blocking/deadlocking or other resource contention
    
   -- Sustained values above 1 suggest further investigation in that area
   -- High Avg Runnable Task Counts are a good sign of CPU pressure
   -- High Avg Pending DiskIO Counts are a sign of disk pressure


 -- Detect blocking (run multiple times)  (Query 36) (Detect Blocking)


SELECT t1.resource_type AS [lock type], DB_NAME(resource_database_id) AS [database],
t1.resource_associated_entity_id AS [blk object],t1.request_mode AS [lock req],  --- lock requested
t1.request_session_id AS [waiter sid], t2.wait_duration_ms AS [wait time],       -- spid of waiter  
(SELECT [text][/text] FROM sys.dm_exec_requests AS r WITH (NOLOCK)                      -- get sql for waiter
CROSS APPLY sys.dm_exec_sql_text(r.[sql_handle]) 
WHERE r.session_id = t1.request_session_id) AS [waiter_batch],
(SELECT SUBSTRING(qt.[text],r.statement_start_offset/2, 
(CASE WHEN r.statement_end_offset = -1 
  THEN LEN(CONVERT(nvarchar(max), qt.[text])) * 2 
   ELSE r.statement_end_offset END - r.statement_start_offset)/2) 
  FROM sys.dm_exec_requests AS r WITH (NOLOCK)
  CROSS APPLY sys.dm_exec_sql_text(r.[sql_handle]) AS qt
  WHERE r.session_id = t1.request_session_id) AS [waiter_stmt],                    -- statement blocked
  t2.blocking_session_id AS [blocker sid],                                        -- spid of blocker
  (SELECT [text][/text] FROM sys.sysprocesses AS p                                        -- get sql for blocker
  CROSS APPLY sys.dm_exec_sql_text(p.[sql_handle]) 
  WHERE p.spid = t2.blocking_session_id) AS [blocker_batch]
  FROM sys.dm_tran_locks AS t1 WITH (NOLOCK)
  INNER JOIN sys.dm_os_waiting_tasks AS t2 WITH (NOLOCK)
  ON t1.lock_owner_address = t2.resource_address OPTION (RECOMPILE);
    
  -- Helps troubleshoot blocking and deadlocking issues
  -- The results will change from second to second on a busy system
  -- You should run this query multiple times when you see signs of blocking