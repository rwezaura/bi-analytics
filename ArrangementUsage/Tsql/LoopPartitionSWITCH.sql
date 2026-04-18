--********************************************* TABLES *********************************************--
		-- AR_TRCK_FCT
		-- SubscriberStatus
		-- SubscriberMaster
		-- AR_LAST_EV_FCT
		-- Subscriber_BTS
		-- Subscriber_BTS_DETAILS
--********************************************* TABLES *********************************************--

declare @dt date = '4/30/2023'
declare @database varchar(50) = 'AnalyticsTD'
declare @schema varchar(20) = 'dbo'
declare @table varchar(50) = 'AR_TRCK_FCT'
declare @cols NVARCHAR(MAX) = N''

select @cols += N', [' + name + '] ' + system_type_name + case is_nullable when 1 then ' NULL' else ' NOT NULL' end
	 FROM sys.dm_exec_describe_first_result_set(N'SELECT * FROM ' + @schema + '.'+ @table , NULL, 1);
set @cols = STUFF(@cols, 1, 1, N'');

while (@dt > '5/29/2022')
begin

declare @tsql nvarchar(max)

declare @pt varchar(20) = datename(MONTH,@dt) + '_' + convert(varchar,datepart(YEAR,@dt))
declare @pf varchar(10) = $partition.pf_Daily(@dt)
declare @vdt varchar(6) = convert(varchar(6),@dt,112)
declare @xdt varchar(10) = convert(varchar(10),@dt,121)

set @tsql = N'
BEGIN TRANSACTION
USE [' + @database + ']
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF OBJECT_ID(''' + @schema + '.staging_' + @table + '_' + @vdt + ''') IS NULL
CREATE TABLE [' + @schema + '].[staging_' + @table + '_' + @vdt + '](' + @cols + ')  ON [ps_Daily]([FCT_DT])

USE [' + @database + ']
IF INDEXPROPERTY(OBJECT_ID(''' + @schema + '.staging_' + @table + '_' + @vdt + '''),''staging_' + @table + '_' + @vdt + '_CCI_' + @table + ''',''IndexID'') IS NULL
	AND (SELECT i.type_desc FROM SYS.INDEXES i INNER JOIN SYS.OBJECTS o ON i.OBJECT_ID = o.OBJECT_ID WHERE SCHEMA_NAME(o.SCHEMA_ID) = ''' + @schema + ''' AND OBJECT_NAME(o.OBJECT_ID) = ''' + @table + '''  AND i.type_desc = ''CLUSTERED COLUMNSTORE'' ) IS NOT NULL
CREATE CLUSTERED COLUMNSTORE INDEX [staging_' + @table + '_' + @vdt + '_CCI_' + @table + '] ON [' + @schema + '].[staging_' + @table + '_' + @vdt + '] WITH (DROP_EXISTING = OFF, DATA_COMPRESSION = COLUMNSTORE, COMPRESSION_DELAY = 0) ON [ps_Daily]([FCT_DT])
ELSE IF INDEXPROPERTY(OBJECT_ID(''' + @schema + '.staging_' + @table + '_' + @vdt + '''),''staging_' + @table + '_' + @vdt + '_CI_' + @table + ''',''IndexID'') IS NULL
	AND (SELECT i.type_desc FROM SYS.INDEXES i INNER JOIN SYS.OBJECTS o ON i.OBJECT_ID = o.OBJECT_ID WHERE SCHEMA_NAME(o.SCHEMA_ID) = ''' + @schema + ''' AND OBJECT_NAME(o.OBJECT_ID) = ''' + @table + '''  AND i.type_desc = ''CLUSTERED'' ) IS NOT NULL
CREATE CLUSTERED INDEX [staging_' + @table + '_' + @vdt + '_CI_' + @table + '] ON [' + @schema + '].[staging_' + @table + '_' + @vdt + ']([FCT_DT] ASC) WITH (PAD_INDEX = OFF, DATA_COMPRESSION = PAGE, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ps_Daily]([FCT_DT])
USE [' + @database + ']
IF INDEXPROPERTY(OBJECT_ID(''' + @schema + '.staging_' + @table + '_' + @vdt + '''),''staging_' + @table + '_' + @vdt + '_NCI_' + @table + ''',''IndexID'') IS NULL
	AND (SELECT i.type_desc FROM SYS.INDEXES i INNER JOIN SYS.OBJECTS o ON i.OBJECT_ID = o.OBJECT_ID WHERE SCHEMA_NAME(o.SCHEMA_ID) = ''' + @schema + ''' AND OBJECT_NAME(o.OBJECT_ID) = ''' + @table + '''  AND i.type_desc = ''NONCLUSTERED'' ) IS NOT NULL
CREATE NONCLUSTERED INDEX [staging_' + @table + '_' + @vdt + '_NCI_' + @table + ']  ON [' + @schema + '].[staging_' + @table + '_' + @vdt + '] ([AR_KEY] ASC) INCLUDE([FCT_DT]) WITH (PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ps_Daily]([FCT_DT])
USE [' + @database + ']
ALTER TABLE [' + @database + '].[' + @schema + '].[' + @table + '] SWITCH PARTITION ' + @pf + ' TO [' + @database + '].[' + @schema + '].[staging_' + @table + '_' + @vdt + '] PARTITION ' + @pf + ' WITH (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = NONE))
COMMIT TRANSACTION';
print @tsql

--EXEC sp_executesql @tsql

set @dt = dateadd(DD,-1,@dt)

end





