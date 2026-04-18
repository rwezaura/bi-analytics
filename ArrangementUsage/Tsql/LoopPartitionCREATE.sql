--********************************************* TABLES *********************************************--
		-- CBSSUBSCRIBER_BO
--********************************************* TABLES *********************************************--

declare @dt date = '7/31/2023'
declare @database varchar(50) = 'AnalyticsStaging'
declare @schema varchar(20) = 'dbo'
declare @table varchar(50) = 'CBSSUBSCRIBER_BO'
declare @cols NVARCHAR(MAX) = N''


while (@dt > '6/30/2023')
begin

declare @tsql nvarchar(max)

declare @pt varchar(20) = datename(MONTH,@dt) + '_' + convert(varchar,datepart(YEAR,@dt))
declare @pf varchar(10) = $partition.pf_Daily(@dt)
declare @vdt varchar(8) = convert(varchar(8),@dt,112)
declare @xdt varchar(10) = convert(varchar(10),@dt,121)

set @tsql = N'
USE [AnalyticsStaging]
GO
BEGIN TRANSACTION
DROP INDEX [CCIX_' + @table + '_CCI] ON [' + @schema + '].[' + @table + '_' + @vdt + ']

CREATE CLUSTERED INDEX [ClusteredIndex_on_ps_Daily_638381639046621950] ON [' + @schema + '].[' + @table + '_' + @vdt + ']
(
	[PPN_DT]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [ps_Daily]([PPN_DT])


DROP INDEX [ClusteredIndex_on_ps_Daily_638381639046621950] ON [' + @schema + '].[' + @table + '_' + @vdt + ']


CREATE CLUSTERED COLUMNSTORE INDEX [CCIX_' + @table + '_CCI] ON [' + @schema + '].[' + @table + '_' + @vdt + '] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [ps_Daily]([PPN_DT])

COMMIT TRANSACTION';
print @tsql

--EXEC sp_executesql @tsql

set @dt = dateadd(DD,-1,@dt)

end

