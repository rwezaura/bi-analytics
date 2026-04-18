USE [AnalyticsStaging]
GO

/****** Object:  StoredProcedure [dbo].[DAILY_CHABAB_USAGE_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[DAILY_CHABAB_USAGE_NAC] (
	@Ppn_dt	DATE
)
AS
Begin

Select Ppn_dt,Msisdn_dd,sum(TTL_Outgoing_Rev)TTL_Outgoing_Rev,sum(TTL_Rev_Data)TTL_Rev_Data
	  ,sum(Rev_TSS)Rev_TSS,sum(Traffic_Data)Traffic_Data,sum(Reload)Reload
	  ,Case when SubCosID='1054' then 'TigoShababTest'
			when SubCosID='1056' then 'TigoShabab2'
			when SubCosID='1130' then 'TigoShabab_2'
			when SubCosID='1031' then 'TigoShabab'
		    else 'NewShabab'
	  End PLN_NM
Into #TEMP
From dbo.TSS_TTL_CVM with(nolock)
Where (Ppn_dt =@Ppn_dt) and SubCosID in ('1054','1056','1130','1031')
Group by Ppn_dt,Msisdn_dd
	  ,Case when SubCosID='1054' then 'TigoShababTest'
			when SubCosID='1056' then 'TigoShabab2'
			when SubCosID='1130' then 'TigoShabab_2'
			when SubCosID='1031' then 'TigoShabab'
		    else 'NewShabab'
	   End

Alter table #TEMP add Traffic_Shabab float
--Alter table #TEMP add Traffic_Shabab_Expired float
-- Select * from #TEMP

--Insert into #USAGE
Select Ppn_dt,right(PRI_IDENTITY,8)PRI_IDENTITY
	 ,(SUM(cast((Case when OBJECT_TYPE_ID in (5206,5156,5163) then CHG_AMOUNT  else 0 end +
				 Case when OBJECT_TYPE_ID1 in (5206,5156,5163) then CHG_AMOUNT1  else 0 end +
				 Case when OBJECT_TYPE_ID2 in (5206,5156,5163) then CHG_AMOUNT2  else 0 end +
				 Case when OBJECT_TYPE_ID3 in (5206,5156,5163) then CHG_AMOUNT3  else 0 end +
				 Case when OBJECT_TYPE_ID4 in (5206,5156,5163) then CHG_AMOUNT4  else 0 end +
				 Case when OBJECT_TYPE_ID5 in (5206,5156,5163) then CHG_AMOUNT5  else 0 end +
				 Case when OBJECT_TYPE_ID6 in (5206,5156,5163) then CHG_AMOUNT6  else 0 end +
				 Case when OBJECT_TYPE_ID7 in (5206,5156,5163) then CHG_AMOUNT7  else 0 end +
				 Case when OBJECT_TYPE_ID8 in (5206,5156,5163) then CHG_AMOUNT8  else 0 end +
				 Case when OBJECT_TYPE_ID9 in (5206,5156,5163) then CHG_AMOUNT9  else 0 end +
				 Case when OBJECT_TYPE_ID10 in (5206,5156,5163)then CHG_AMOUNT10 else 0 end +
				 Case when OBJECT_TYPE_ID11 in (5206,5156,5163)then CHG_AMOUNT11 else 0 end +
				 Case when OBJECT_TYPE_ID12 in (5206,5156,5163)then CHG_AMOUNT12 else 0 end +
				 Case when OBJECT_TYPE_ID13 in (5206,5156,5163)then CHG_AMOUNT13 else 0 end +
				 Case when OBJECT_TYPE_ID14 in (5206,5156,5163)then CHG_AMOUNT14 else 0 end)as float))/(1024*1024))Usage 
Into #USAGE
From dbo.OCSDATA_NUPGRD with(nolock)
Where (Ppn_dt =@Ppn_dt)-- and RESULT_CODE='0'
Group by Ppn_dt,right(PRI_IDENTITY,8)


/*
Select Ppn_dt,right(PRI_IDENTITY,8)PRI_IDENTITY
	 ,(SUM(cast((Case when OBJECT_TYPE_ID in (5206,5156,5163) then CHG_AMOUNT  else 0 end +
				 Case when OBJECT_TYPE_ID1 in (5206,5156,5163) then CHG_AMOUNT1  else 0 end +
				 Case when OBJECT_TYPE_ID2 in (5206,5156,5163) then CHG_AMOUNT2  else 0 end +
				 Case when OBJECT_TYPE_ID3 in (5206,5156,5163) then CHG_AMOUNT3  else 0 end +
				 Case when OBJECT_TYPE_ID4 in (5206,5156,5163) then CHG_AMOUNT4  else 0 end +
				 Case when OBJECT_TYPE_ID5 in (5206,5156,5163) then CHG_AMOUNT5  else 0 end +
				 Case when OBJECT_TYPE_ID6 in (5206,5156,5163) then CHG_AMOUNT6  else 0 end +
				 Case when OBJECT_TYPE_ID7 in (5206,5156,5163) then CHG_AMOUNT7  else 0 end +
				 Case when OBJECT_TYPE_ID8 in (5206,5156,5163) then CHG_AMOUNT8  else 0 end +
				 Case when OBJECT_TYPE_ID9 in (5206,5156,5163) then CHG_AMOUNT9  else 0 end +
				 Case when OBJECT_TYPE_ID10 in (5206,5156,5163)then CHG_AMOUNT10 else 0 end +
				 Case when OBJECT_TYPE_ID11 in (5206,5156,5163)then CHG_AMOUNT11 else 0 end +
				 Case when OBJECT_TYPE_ID12 in (5206,5156,5163)then CHG_AMOUNT12 else 0 end +
				 Case when OBJECT_TYPE_ID13 in (5206,5156,5163)then CHG_AMOUNT13 else 0 end +
				 Case when OBJECT_TYPE_ID14 in (5206,5156,5163)then CHG_AMOUNT14 else 0 end)as float))/(1024*1024))Usage 
into #EXPIRED
From dbo.OCSCLR_NUPGRD with(nolock)
Where (Ppn_dt =@Ppn_dt) --and RESULT_CODE='0'
Group by Ppn_dt,right(PRI_IDENTITY,8)

update a set Traffic_Shabab=b.Usage
from #TEMP a
left outer join
#USAGE b
on a.Ppn_dt=b.Ppn_dt
and a.Msisdn_dd=b.ChargingPartyNumber
where b.ChargingPartyNumber is not null */

Update #TEMP set Traffic_Shabab=b.Usage
From (Select Usage, Ppn_dt ppndt, PRI_IDENTITY from #USAGE where PRI_IDENTITY is not null )b
Where Ppn_dt=ppndt and Msisdn_dd=PRI_IDENTITY

/*
update a set Traffic_Shabab_Expired=b.Usage
from #TEMP a
left outer join
#EXPIRED b
on a.Ppn_dt=b.Ppn_dt
and a.Msisdn_dd=b.ChargingPartyNumber
where b.ChargingPartyNumber is not null

Update #TEMP set Traffic_Shabab_Expired=b.Usage
From (Select Ppn_dt ppndt,PRI_IDENTITY,Usage from #EXPIRED where PRI_IDENTITY is not null )b
Where Ppn_dt=ppndt and Msisdn_dd=PRI_IDENTITY
*/ 
Delete from dbo.AGG_DAILY_SHABAB_USAGE where Ppn_dt=@Ppn_dt
Insert into dbo.AGG_DAILY_SHABAB_USAGE
Select Ppn_dt,PLN_NM,count(distinct Msisdn_dd)Subs
	  ,sum(TTL_Outgoing_Rev)TTL_Outgoing_Rev
	  ,sum(TTL_Rev_Data)TTL_Rev_Data
	  ,sum(Rev_TSS)Rev_TSS
	  ,sum(Traffic_Data)Traffic_Data,sum(Reload)Reload
	  ,isnull(sum(Traffic_Shabab),0)Traffic_Shabab
	  --,isnull(sum(Traffic_Shabab_Expired),0)Traffic_Shabab_Expired
From #TEMP 
Group by Ppn_dt,PLN_NM

Drop table #TEMP
Drop table #USAGE
--Drop table #EXPIRED

End
GO

/****** Object:  StoredProcedure [dbo].[DAILY_KPI_USAGE_ZIADA_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[DAILY_KPI_USAGE_ZIADA_NAC] (
	@PPN_DT	DATE
)
AS
Begin
--- VOICE HANANA AIR TIME
Select PPN_DT
,(sum(cast((Case when OBJECT_TYPE_ID=2538 then CHG_AMOUNT  else 0 end +
			Case when OBJECT_TYPE_ID1=2538 then CHG_AMOUNT1  else 0 end +
			Case when OBJECT_TYPE_ID2=2538 then CHG_AMOUNT2  else 0 end +
			Case when OBJECT_TYPE_ID3=2538 then CHG_AMOUNT3  else 0 end +
			Case when OBJECT_TYPE_ID4=2538 then CHG_AMOUNT4  else 0 end +
			Case when OBJECT_TYPE_ID5=2538 then CHG_AMOUNT5  else 0 end +
			Case when OBJECT_TYPE_ID6=2538 then CHG_AMOUNT6  else 0 end +
			Case when OBJECT_TYPE_ID7=2538 then CHG_AMOUNT7  else 0 end +
			Case when OBJECT_TYPE_ID8=2538 then CHG_AMOUNT8  else 0 end +
			Case when OBJECT_TYPE_ID9=2538 then CHG_AMOUNT9  else 0 end +
			Case when OBJECT_TYPE_ID10=2538then CHG_AMOUNT10 else 0 end +
			Case when OBJECT_TYPE_ID11=2538then CHG_AMOUNT11 else 0 end +
			Case when OBJECT_TYPE_ID12=2538then CHG_AMOUNT12 else 0 end +
			Case when OBJECT_TYPE_ID13=2538then CHG_AMOUNT13 else 0 end +
			Case when OBJECT_TYPE_ID14=2538then CHG_AMOUNT14 else 0 end)as float))/100)/88.5 Usage_ZIADA_100 
,(sum(cast((Case when OBJECT_TYPE_ID=2537 then CHG_AMOUNT  else 0 end +
			Case when OBJECT_TYPE_ID1=2537 then CHG_AMOUNT1  else 0 end +
			Case when OBJECT_TYPE_ID2=2537 then CHG_AMOUNT2  else 0 end +
			Case when OBJECT_TYPE_ID3=2537 then CHG_AMOUNT3  else 0 end +
			Case when OBJECT_TYPE_ID4=2537 then CHG_AMOUNT4  else 0 end +
			Case when OBJECT_TYPE_ID5=2537 then CHG_AMOUNT5  else 0 end +
			Case when OBJECT_TYPE_ID6=2537 then CHG_AMOUNT6  else 0 end +
			Case when OBJECT_TYPE_ID7=2537 then CHG_AMOUNT7  else 0 end +
			Case when OBJECT_TYPE_ID8=2537 then CHG_AMOUNT8  else 0 end +
			Case when OBJECT_TYPE_ID9=2537 then CHG_AMOUNT9  else 0 end +
			Case when OBJECT_TYPE_ID10=2537then CHG_AMOUNT10 else 0 end +
			Case when OBJECT_TYPE_ID11=2537then CHG_AMOUNT11 else 0 end +
			Case when OBJECT_TYPE_ID12=2537then CHG_AMOUNT12 else 0 end +
			Case when OBJECT_TYPE_ID13=2537then CHG_AMOUNT13 else 0 end +
			Case when OBJECT_TYPE_ID14=2537then CHG_AMOUNT14 else 0 end)as float))/100)/88.5 Usage_ZIADA_250 
,(sum(cast((Case when OBJECT_TYPE_ID in(2536,2547) then CHG_AMOUNT  else 0 end +
			Case when OBJECT_TYPE_ID1 in(2536,2547) then CHG_AMOUNT1  else 0 end +
			Case when OBJECT_TYPE_ID2 in(2536,2547) then CHG_AMOUNT2  else 0 end +
			Case when OBJECT_TYPE_ID3 in(2536,2547) then CHG_AMOUNT3  else 0 end +
			Case when OBJECT_TYPE_ID4 in(2536,2547) then CHG_AMOUNT4  else 0 end +
			Case when OBJECT_TYPE_ID5 in(2536,2547) then CHG_AMOUNT5  else 0 end +
			Case when OBJECT_TYPE_ID6 in(2536,2547) then CHG_AMOUNT6  else 0 end +
			Case when OBJECT_TYPE_ID7 in(2536,2547) then CHG_AMOUNT7  else 0 end +
			Case when OBJECT_TYPE_ID8 in(2536,2547) then CHG_AMOUNT8  else 0 end +
			Case when OBJECT_TYPE_ID9 in(2536,2547) then CHG_AMOUNT9  else 0 end +
			Case when OBJECT_TYPE_ID10 in(2536,2547)then CHG_AMOUNT10 else 0 end +
			Case when OBJECT_TYPE_ID11 in(2536,2547)then CHG_AMOUNT11 else 0 end +
			Case when OBJECT_TYPE_ID12 in(2536,2547)then CHG_AMOUNT12 else 0 end +
			Case when OBJECT_TYPE_ID13 in(2536,2547)then CHG_AMOUNT13 else 0 end +
			Case when OBJECT_TYPE_ID14 in(2536,2547)then CHG_AMOUNT14 else 0 end)as float))/100)/88.5 Usage_ZIADA_500 
,(sum(cast((Case when OBJECT_TYPE_ID in(2533,2543) then CHG_AMOUNT  else 0 end +
			Case when OBJECT_TYPE_ID1 in(2533,2543) then CHG_AMOUNT1  else 0 end +
			Case when OBJECT_TYPE_ID2 in(2533,2543) then CHG_AMOUNT2  else 0 end +
			Case when OBJECT_TYPE_ID3 in(2533,2543) then CHG_AMOUNT3  else 0 end +
			Case when OBJECT_TYPE_ID4 in(2533,2543) then CHG_AMOUNT4  else 0 end +
			Case when OBJECT_TYPE_ID5 in(2533,2543) then CHG_AMOUNT5  else 0 end +
			Case when OBJECT_TYPE_ID6 in(2533,2543) then CHG_AMOUNT6  else 0 end +
			Case when OBJECT_TYPE_ID7 in(2533,2543) then CHG_AMOUNT7  else 0 end +
			Case when OBJECT_TYPE_ID8 in(2533,2543) then CHG_AMOUNT8  else 0 end +
			Case when OBJECT_TYPE_ID9 in(2533,2543) then CHG_AMOUNT9  else 0 end +
			Case when OBJECT_TYPE_ID10 in(2533,2543)then CHG_AMOUNT10 else 0 end +
			Case when OBJECT_TYPE_ID11 in(2533,2543)then CHG_AMOUNT11 else 0 end +
			Case when OBJECT_TYPE_ID12 in(2533,2543)then CHG_AMOUNT12 else 0 end +
			Case when OBJECT_TYPE_ID13 in(2533,2543)then CHG_AMOUNT13 else 0 end +
			Case when OBJECT_TYPE_ID14 in(2533,2543)then CHG_AMOUNT14 else 0 end)as float))/100)/88.5 Usage_ZIADA_1000 
,(sum(cast((Case when OBJECT_TYPE_ID in(2539,2544) then CHG_AMOUNT  else 0 end +
			Case when OBJECT_TYPE_ID1 in(2539,2544) then CHG_AMOUNT1  else 0 end +
			Case when OBJECT_TYPE_ID2 in(2539,2544) then CHG_AMOUNT2  else 0 end +
			Case when OBJECT_TYPE_ID3 in(2539,2544) then CHG_AMOUNT3  else 0 end +
			Case when OBJECT_TYPE_ID4 in(2539,2544) then CHG_AMOUNT4  else 0 end +
			Case when OBJECT_TYPE_ID5 in(2539,2544) then CHG_AMOUNT5  else 0 end +
			Case when OBJECT_TYPE_ID6 in(2539,2544) then CHG_AMOUNT6  else 0 end +
			Case when OBJECT_TYPE_ID7 in(2539,2544) then CHG_AMOUNT7  else 0 end +
			Case when OBJECT_TYPE_ID8 in(2539,2544) then CHG_AMOUNT8  else 0 end +
			Case when OBJECT_TYPE_ID9 in(2539,2544) then CHG_AMOUNT9  else 0 end +
			Case when OBJECT_TYPE_ID10 in(2539,2544)then CHG_AMOUNT10 else 0 end +
			Case when OBJECT_TYPE_ID11 in(2539,2544)then CHG_AMOUNT11 else 0 end +
			Case when OBJECT_TYPE_ID12 in(2539,2544)then CHG_AMOUNT12 else 0 end +
			Case when OBJECT_TYPE_ID13 in(2539,2544)then CHG_AMOUNT13 else 0 end +
			Case when OBJECT_TYPE_ID14 in(2539,2544)then CHG_AMOUNT14 else 0 end)as float))/100)/88.5 Usage_ZIADA_2000 
,(sum(cast((Case when OBJECT_TYPE_ID in(2541,2545) then CHG_AMOUNT  else 0 end +
			Case when OBJECT_TYPE_ID1 in(2541,2545) then CHG_AMOUNT1  else 0 end +
			Case when OBJECT_TYPE_ID2 in(2541,2545) then CHG_AMOUNT2  else 0 end +
			Case when OBJECT_TYPE_ID3 in(2541,2545) then CHG_AMOUNT3  else 0 end +
			Case when OBJECT_TYPE_ID4 in(2541,2545) then CHG_AMOUNT4  else 0 end +
			Case when OBJECT_TYPE_ID5 in(2541,2545) then CHG_AMOUNT5  else 0 end +
			Case when OBJECT_TYPE_ID6 in(2541,2545) then CHG_AMOUNT6  else 0 end +
			Case when OBJECT_TYPE_ID7 in(2541,2545) then CHG_AMOUNT7  else 0 end +
			Case when OBJECT_TYPE_ID8 in(2541,2545) then CHG_AMOUNT8  else 0 end +
			Case when OBJECT_TYPE_ID9 in(2541,2545) then CHG_AMOUNT9  else 0 end +
			Case when OBJECT_TYPE_ID10 in(2541,2545)then CHG_AMOUNT10 else 0 end +
			Case when OBJECT_TYPE_ID11 in(2541,2545)then CHG_AMOUNT11 else 0 end +
			Case when OBJECT_TYPE_ID12 in(2541,2545)then CHG_AMOUNT12 else 0 end +
			Case when OBJECT_TYPE_ID13 in(2541,2545)then CHG_AMOUNT13 else 0 end +
			Case when OBJECT_TYPE_ID14 in(2541,2545)then CHG_AMOUNT14 else 0 end)as float))/100)/88.5 Usage_ZIADA_3000 
,(sum(cast((Case when OBJECT_TYPE_ID in(2542,2546) then CHG_AMOUNT  else 0 end +
			Case when OBJECT_TYPE_ID1 in(2542,2546) then CHG_AMOUNT1  else 0 end +
			Case when OBJECT_TYPE_ID2 in(2542,2546) then CHG_AMOUNT2  else 0 end +
			Case when OBJECT_TYPE_ID3 in(2542,2546) then CHG_AMOUNT3  else 0 end +
			Case when OBJECT_TYPE_ID4 in(2542,2546) then CHG_AMOUNT4  else 0 end +
			Case when OBJECT_TYPE_ID5 in(2542,2546) then CHG_AMOUNT5  else 0 end +
			Case when OBJECT_TYPE_ID6 in(2542,2546) then CHG_AMOUNT6  else 0 end +
			Case when OBJECT_TYPE_ID7 in(2542,2546) then CHG_AMOUNT7  else 0 end +
			Case when OBJECT_TYPE_ID8 in(2542,2546) then CHG_AMOUNT8  else 0 end +
			Case when OBJECT_TYPE_ID9 in(2542,2546) then CHG_AMOUNT9  else 0 end +
			Case when OBJECT_TYPE_ID10 in(2542,2546)then CHG_AMOUNT10 else 0 end +
			Case when OBJECT_TYPE_ID11 in(2542,2546)then CHG_AMOUNT11 else 0 end +
			Case when OBJECT_TYPE_ID12 in(2542,2546)then CHG_AMOUNT12 else 0 end +
			Case when OBJECT_TYPE_ID13 in(2542,2546)then CHG_AMOUNT13 else 0 end +
			Case when OBJECT_TYPE_ID14 in(2542,2546)then CHG_AMOUNT14 else 0 end)as float))/100)/88.5 Usage_ZIADA_5000 
,sum(ACTUAL_USAGE)/60 CallDuration,right(CallingPartyNumber,8)MSISDN

Into #TEMP_HANANA
From dbo.OCSREC_NUPGRD with (nolock)
Where ppn_dt=@PPN_DT
Group by PPN_DT,right(CallingPartyNumber,8)

--update #TEMP_HANANA set Usage_ZIADA_100=(Usage_ZIADA_100/100)/88.5
--update #TEMP_HANANA set Usage_ZIADA_250=(Usage_ZIADA_250/100)/88.5
--update #TEMP_HANANA set Usage_ZIADA_500=(Usage_ZIADA_500/100)/88.5
--update #TEMP_HANANA set Usage_ZIADA_1000=(Usage_ZIADA_1000/100)/88.5
--update #TEMP_HANANA set Usage_ZIADA_2000=(Usage_ZIADA_2000/100)/88.5
--update #TEMP_HANANA set Usage_ZIADA_3000=(Usage_ZIADA_3000/100)/88.5
--update #TEMP_HANANA set Usage_ZIADA_5000=(Usage_ZIADA_5000/100)/88.5

Delete from dbo.DAILY_USAGE_ZIADA where ppn_dt=@PPN_DT
Insert into dbo.DAILY_USAGE_ZIADA select * from #TEMP_HANANA

Delete from [192.168.50.148\ANALYTICS].[AnalyticsReporting].[dbo].[DAILY_USAGE_ZIADA] where ppn_dt=@PPN_DT
Insert into [192.168.50.148\ANALYTICS].[AnalyticsReporting].[dbo].[DAILY_USAGE_ZIADA] select * from #TEMP_HANANA

Drop table #TEMP_HANANA
End
GO

/****** Object:  StoredProcedure [dbo].[DAILY_STOCK_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DAILY_STOCK_NAC]
(
	@PPN_DT	DATE
)
AS
BEGIN


------------------------------------------ CREATION EPIN --------------------------------------------



Select a.Ppn_dt,a.Organization_Short_Code Msisdn,left(b.Date_Identity_Created,6)Month,cast(left(Date_Identity_Created,8) as date)created_dt, cast(Balance as float) Stock into #t
From EVC_BALANCE_DUMPS a, Identity_Full_Operator b where cast(Id as varchar)=Organization_Unique_Reference_Details and Organization_Short_Code!='23590000000'

select * into #tloc from Daily_GEO_Location_NEW with(nolock) where PPN_DT=@ppn_dt

Select a.*,b.STT_NM into #DailyCreation
from #t a left outer join #tloc b on a.Msisdn=b.msisdn
where created_dt=@ppn_dt and b.msisdn is not null

Delete from DAILY_POS_CREATION where PPN_DT=@ppn_dt
Insert into DAILY_POS_CREATION
Select * from #DailyCreation

------------------------------------------ STOCK EPIN --------------------------------------------
select @ppn_dt PPN_DT, a.Msisdn ,created_dt
      --,cast(left(last_recharge_dt,8) as date)last_recharge_dt
	  --,cast(left(last_trans_dt,8) as date)  last_trans_dt
      ,Stock,b.STT_NM
into #dailyStock
from #t a with(nolock) left outer join #tloc b on a.Msisdn=b.msisdn
where b.msisdn is not null

Delete from DAILY_POS_STOCK where PPN_DT=@ppn_dt
Insert into DAILY_POS_STOCK
Select PPN_DT,Msisdn,created_dt,'1900-01-01' last_recharge_dt,'1900-01-01'last_trans_dt, Stock,STT_NM from #dailyStock

Drop table #t
Drop table #tloc
Drop table #dailyStock
Drop table #DailyCreation

End

GO

/****** Object:  StoredProcedure [dbo].[HANANA_AIR_TIME_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[HANANA_AIR_TIME_NAC] (
	@PPN_DT	DATE
)
AS
Begin

If object_id('tempdb..#HananaVoiceAirTime') is not null drop table #HananaVoiceAirTime
If object_id('tempdb..#HananaSMS_AirTime') is not null  drop table #HananaSMS_AirTime
If object_id('tempdb..#HananaDATA_AirTime') is not null drop table #HananaDATA_AirTime
If object_id('tempdb..#Sousc_MON_AirTime') is not null  drop table #Sousc_MON_AirTime
If object_id('tempdb..#Sousc_MGR_AirTime') is not null  drop table #Sousc_MGR_AirTime
If object_id('tempdb..#Sousc_COM_AirTime') is not null  drop table #Sousc_COM_AirTime
If object_id('tempdb..#Hanana_AirTime')    is not null  drop table #Hanana_AirTime


--- VOICE HANANA AIR TIME

Select CUST_LOCAL_START_DATE,CallingPartyNumber,CalledPartyNumber,ACTUAL_USAGE,RESULT_CODE,
OBJECT_TYPE_ID,OBJECT_TYPE_ID1,OBJECT_TYPE_ID2,OBJECT_TYPE_ID3,OBJECT_TYPE_ID4,OBJECT_TYPE_ID5,OBJECT_TYPE_ID6,OBJECT_TYPE_ID7,OBJECT_TYPE_ID8,OBJECT_TYPE_ID9,OBJECT_TYPE_ID10,OBJECT_TYPE_ID11,OBJECT_TYPE_ID12,OBJECT_TYPE_ID13,OBJECT_TYPE_ID14,
CHG_AMOUNT,CHG_AMOUNT1,CHG_AMOUNT2,CHG_AMOUNT3,CHG_AMOUNT4,CHG_AMOUNT5,CHG_AMOUNT6,CHG_AMOUNT7,CHG_AMOUNT8,CHG_AMOUNT9,CHG_AMOUNT10,CHG_AMOUNT11,CHG_AMOUNT12,CHG_AMOUNT13,CHG_AMOUNT14 into #trec
from dbo.OCSREC_NUPGRD with (nolock) Where PPN_DT=@PPN_DT

Select cast(CUST_LOCAL_START_DATE as date) PPN_DT,CallingPartyNumber,CalledPartyNumber
		,(sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530 then CHG_AMOUNT1  else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)/1.129 Voice_AirTime
		,sum(ACTUAL_USAGE)/60 CallDuration
		,(sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530 then CHG_AMOUNT1  else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)Voice_AirTime_Without_Tax

Into #HananaVoiceAirTime
From #trec --where RESULT_CODE='0'--dbo.OCSREC_NUPGRD with (nolock) Where PPN_DT=@PPN_DT
Group by cast(CUST_LOCAL_START_DATE as date),CallingPartyNumber,CalledPartyNumber
Drop table #trec

Delete From AnalyticsStaging.dbo.CVAS_HANANA_VOICE_AIRTIME Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_VOICE_AIRTIME
Select PPN_DT,CallingPartyNumber,CalledPartyNumber,sum(Voice_AirTime)Voice_AirTime, sum(CallDuration)CallDuration,sum(Voice_AirTime_Without_Tax)Voice_AirTime_Without_Tax
From #HananaVoiceAirTime
Group by PPN_DT,CallingPartyNumber,CalledPartyNumber

Delete From [dbo].[AGGR_CVAS_HANANA_VOICE_AIRTIME]  Where PPN_DT=@PPN_DT
Insert into [dbo].[AGGR_CVAS_HANANA_VOICE_AIRTIME] 
Select  left(PPN_DT,7)Month,PPN_DT,sum(a.CallDuration)CallDuration,count(distinct CallingPartyNumber)subs,sum(Voice_AirTime)VOICE_AirTime_Without_Tax
        ,sum(Voice_AirTime_Without_Tax)VOICE_With_Tax
		,Case when CalledPartyNumber in('2354040','235255')  THEN 'CALL CENTER'
		      when left(CallingPartyNumber,6) ='235444' THEN 'RBT'
			  when left(CalledPartyNumber,7) = '2358888' then 'MOBILE RADIO IVR'
		      when left(CalledPartyNumber,4)='2359' and len (CalledPartyNumber)='11' then 'VOICE OUTGOING ON NET'
		      when left(CalledPartyNumber,4) in ('2356','2357') and len (CalledPartyNumber)='11' then 'VOICE OUTGOING X NET'
			  when left(CalledPartyNumber,5) in ('23522')  then 'VOICE OUTGOING X NET'
			  else 'VOICE OUTGOING IDD' end CALL_TYPE
From  [dbo].[CVAS_HANANA_VOICE_AIRTIME] a with(nolock)
Where PPN_DT=@PPN_DT
Group by left(PPN_DT,7), PPN_DT,Case when CalledPartyNumber in('2354040','235255')  THEN 'CALL CENTER'
		      when left(CallingPartyNumber,6) ='235444' THEN 'RBT'
			  when left(CalledPartyNumber,7) = '2358888' then 'MOBILE RADIO IVR'
		      when left(CalledPartyNumber,4)='2359' and len (CalledPartyNumber)='11' then 'VOICE OUTGOING ON NET'
		      when left(CalledPartyNumber,4) in ('2356','2357') and len (CalledPartyNumber)='11' then 'VOICE OUTGOING X NET'
			  when left(CalledPartyNumber,5) in ('23522')  then 'VOICE OUTGOING X NET'
			  else 'VOICE OUTGOING IDD' end  


---- SMS HANANA AIR TIME
Select CUST_LOCAL_START_DATE,CallingPartyNumber,CalledPartyNumber,RESULT_CODE,
OBJECT_TYPE_ID,OBJECT_TYPE_ID1,OBJECT_TYPE_ID2,OBJECT_TYPE_ID3,OBJECT_TYPE_ID4,OBJECT_TYPE_ID5,OBJECT_TYPE_ID6,OBJECT_TYPE_ID7,OBJECT_TYPE_ID8,OBJECT_TYPE_ID9,OBJECT_TYPE_ID10,OBJECT_TYPE_ID11,OBJECT_TYPE_ID12,OBJECT_TYPE_ID13,OBJECT_TYPE_ID14,
CHG_AMOUNT,CHG_AMOUNT1,CHG_AMOUNT2,CHG_AMOUNT3,CHG_AMOUNT4,CHG_AMOUNT5,CHG_AMOUNT6,CHG_AMOUNT7,CHG_AMOUNT8,CHG_AMOUNT9,CHG_AMOUNT10,CHG_AMOUNT11,CHG_AMOUNT12,CHG_AMOUNT13,CHG_AMOUNT14 into #tsms
from dbo.OCSSMS_NUPGRD with (nolock) Where PPN_DT=@PPN_DT

Select  cast(CUST_LOCAL_START_DATE as date) PPN_DT,CallingPartyNumber,CalledPartyNumber,(
		sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530then  CHG_AMOUNT1 else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)/1.129 SMS_AirTime
		,count(1)Nbre,(
		sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530then  CHG_AMOUNT1 else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)SMS_AirTime_Without_Tax

into #HananaSMS_AirTime
From #tsms --where RESULT_CODE='0'--dbo.OCSSMS_NUPGRD with (nolock) Where PPN_DT=@PPN_DT
Group by cast(CUST_LOCAL_START_DATE as date),CallingPartyNumber,CalledPartyNumber
Drop table #tsms

Delete From AnalyticsStaging.dbo.CVAS_HANANA_SMS_AIRTIME Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_SMS_AIRTIME
Select PPN_DT,CallingPartyNumber,CalledPartyNumber,sum(SMS_AirTime)SMS_AirTime, sum(Nbre)Nbre,sum(SMS_AirTime_Without_Tax)SMS_AirTime_Without_Tax
From #HananaSMS_AirTime
Group by PPN_DT,CallingPartyNumber,CalledPartyNumber

---- DATA HANANA AIR TIME
Select TIME_STAMP,right(PRI_IDENTITY,8)PRI_IDENTITY,RATE_USAGE2,TotalFlux,RESULT_CODE,
OBJECT_TYPE_ID,OBJECT_TYPE_ID1,OBJECT_TYPE_ID2,OBJECT_TYPE_ID3,OBJECT_TYPE_ID4,OBJECT_TYPE_ID5,OBJECT_TYPE_ID6,OBJECT_TYPE_ID7,OBJECT_TYPE_ID8,OBJECT_TYPE_ID9,OBJECT_TYPE_ID10,OBJECT_TYPE_ID11,OBJECT_TYPE_ID12,OBJECT_TYPE_ID13,OBJECT_TYPE_ID14,
CHG_AMOUNT,CHG_AMOUNT1,CHG_AMOUNT2,CHG_AMOUNT3,CHG_AMOUNT4,CHG_AMOUNT5,CHG_AMOUNT6,CHG_AMOUNT7,CHG_AMOUNT8,CHG_AMOUNT9,CHG_AMOUNT10,CHG_AMOUNT11,CHG_AMOUNT12,CHG_AMOUNT13,CHG_AMOUNT14 into #tdata
from dbo.OCSDATA_NUPGRD with (nolock) Where PPN_DT=@PPN_DT

Select  cast(TIME_STAMP as date) PPN_DT,PRI_IDENTITY,(
		sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530then  CHG_AMOUNT1 else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)/1.129 DATA_AirTime,
		sum(TotalFlux)/(1024*1024)TotalFlux,sum(RATE_USAGE2)/(1024*1024)TotalChargeFlux,(
		sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530then  CHG_AMOUNT1 else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)DATA_AirTime_Without_Tax

Into #HananaDATA_AirTime
From #tdata --where RESULT_CODE='0'--dbo.OCSDATA_NUPGRD with (nolock) Where PPN_DT=@PPN_DT
Group by cast(TIME_STAMP as date),PRI_IDENTITY
Drop table #tdata

Delete From AnalyticsStaging.dbo.CVAS_HANANA_DATA_AIRTIME Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_DATA_AIRTIME
Select PPN_DT,PRI_IDENTITY,sum(DATA_AirTime)DATA_AirTime, sum(TotalFlux)TotalFlux,sum(TotalChargeFlux)TotalChargeFlux,sum(DATA_AirTime_Without_Tax)DATA_AirTime_Without_Tax
From #HananaDATA_AirTime
Group by PPN_DT,PRI_IDENTITY

---- SOUCRIPTION MON

Select TIME_STAMP,right(PRI_IDENTITY,8)PRI_IDENTITY,OfferingID,RESULT_CODE,
OBJECT_TYPE_ID,OBJECT_TYPE_ID1,OBJECT_TYPE_ID2,OBJECT_TYPE_ID3,OBJECT_TYPE_ID4,OBJECT_TYPE_ID5,OBJECT_TYPE_ID6,OBJECT_TYPE_ID7,OBJECT_TYPE_ID8,OBJECT_TYPE_ID9,OBJECT_TYPE_ID10,OBJECT_TYPE_ID11,OBJECT_TYPE_ID12,OBJECT_TYPE_ID13,OBJECT_TYPE_ID14,
CHG_AMOUNT,CHG_AMOUNT1,CHG_AMOUNT2,CHG_AMOUNT3,CHG_AMOUNT4,CHG_AMOUNT5,CHG_AMOUNT6,CHG_AMOUNT7,CHG_AMOUNT8,CHG_AMOUNT9,CHG_AMOUNT10,CHG_AMOUNT11,CHG_AMOUNT12,CHG_AMOUNT13,CHG_AMOUNT14  into #tmon
from dbo.OCSMON_NUPGRD with (nolock) Where PPN_DT=@PPN_DT

Select  cast(TIME_STAMP as date) PPN_DT,PRI_IDENTITY,(
		sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530 then CHG_AMOUNT1  else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)/1.129 Sousc_MON_AirTime,OfferingID,(
		sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530 then CHG_AMOUNT1  else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)Sousc_MON_AirTime_Without_Tax

Into #Sousc_MON_AirTime
From #tmon --where RESULT_CODE='0'--dbo.OCSMON_NUPGRD with (nolock) Where PPN_DT=@PPN_DT
Group by cast(TIME_STAMP as date),PRI_IDENTITY,OfferingID

Delete From AnalyticsStaging.dbo.CVAS_HANANA_MON_AIRTIME Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_MON_AIRTIME
Select PPN_DT,PRI_IDENTITY,OfferingID,sum(Sousc_MON_AirTime)Sousc_MON_AirTime,sum(Sousc_MON_AirTime_Without_Tax)Sousc_MON_AirTime_Without_Tax 
From #Sousc_MON_AirTime
Group by PPN_DT,PRI_IDENTITY,OfferingID
Drop table #tmon

--- SOUCRIPTION MGR
Select CUST_LOCAL_START_DATE,right(PRI_IDENTITY,8)PRI_IDENTITY,Oper_ID,NewOfferingID,OPER_TYPE,RESULT_CODE,
OBJECT_TYPE_ID,OBJECT_TYPE_ID1,OBJECT_TYPE_ID2,OBJECT_TYPE_ID3,OBJECT_TYPE_ID4,OBJECT_TYPE_ID5,OBJECT_TYPE_ID6,OBJECT_TYPE_ID7,OBJECT_TYPE_ID8,OBJECT_TYPE_ID9,OBJECT_TYPE_ID10,OBJECT_TYPE_ID11,OBJECT_TYPE_ID12,OBJECT_TYPE_ID13,OBJECT_TYPE_ID14,
(cast(CHG_AMOUNT as float))/100 CHG_AMOUNT,CHG_AMOUNT1,CHG_AMOUNT2,CHG_AMOUNT3,CHG_AMOUNT4,CHG_AMOUNT5,CHG_AMOUNT6,CHG_AMOUNT7,CHG_AMOUNT8,CHG_AMOUNT9,CHG_AMOUNT10,CHG_AMOUNT11,CHG_AMOUNT12,CHG_AMOUNT13,CHG_AMOUNT14  into #tmgr
From AnalyticsStaging.dbo.OCSMGR_NUPGRD with (nolock) Where PPN_DT=@PPN_DT and STD_EVT_TYPE_ID!='13025'

Select  cast(CUST_LOCAL_START_DATE as date) PPN_DT,PRI_IDENTITY,(
		sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530 then CHG_AMOUNT1  else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)/1.129 Sousc_MGR_AirTime,NewOfferingID,(
		sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
		Case when OBJECT_TYPE_ID1 = 2530 then CHG_AMOUNT1  else 0 end +
		Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
		Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
		Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
		Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
		Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
		Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
		Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
		Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end +
		Case when OBJECT_TYPE_ID10 = 2530 then CHG_AMOUNT10  else 0 end+
		Case when OBJECT_TYPE_ID11 = 2530 then CHG_AMOUNT11  else 0 end+
		Case when OBJECT_TYPE_ID12 = 2530 then CHG_AMOUNT12  else 0 end+
		Case when OBJECT_TYPE_ID13 = 2530 then CHG_AMOUNT13  else 0 end+
		Case when OBJECT_TYPE_ID14 = 2530 then CHG_AMOUNT14  else 0 end)as float))/100)Sousc_MGR_AirTime_Without_Tax

Into #Sousc_MGR_AirTime
From #tmgr
Where Oper_ID<>'332' --and RESULT_CODE='0'
Group by cast(CUST_LOCAL_START_DATE as date),PRI_IDENTITY,NewOfferingID

Delete From AnalyticsStaging.dbo.CVAS_HANANA_MGR_AIRTIME_NEW Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_MGR_AIRTIME_NEW
Select PPN_DT,PRI_IDENTITY,NewOfferingID,sum(Sousc_MGR_AirTime)Sousc_MGR_AirTime,sum(Sousc_MGR_AirTime_Without_Tax)Sousc_MGR_AirTime_Without_Tax 
From #Sousc_MGR_AirTime
Group by PPN_DT,PRI_IDENTITY,NewOfferingID

/*
--- SOUCRIPTION COM 
Select cast(TIME_STAMP as date) PPN_DT,PRI_IDENTITY
,   (sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
Case when OBJECT_TYPE_ID1 = 2530 then CHG_AMOUNT1  else 0 end +
Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end)as float))/100)/1.129 Sousc_COM_AirTime
,   (sum(cast((Case when OBJECT_TYPE_ID = 2530 then CHG_AMOUNT  else 0 end +
Case when OBJECT_TYPE_ID1 = 2530 then CHG_AMOUNT1  else 0 end +
Case when OBJECT_TYPE_ID2 = 2530 then CHG_AMOUNT2  else 0 end +
Case when OBJECT_TYPE_ID3 = 2530 then CHG_AMOUNT3  else 0 end +
Case when OBJECT_TYPE_ID4 = 2530 then CHG_AMOUNT4  else 0 end +
Case when OBJECT_TYPE_ID5 = 2530 then CHG_AMOUNT5  else 0 end +
Case when OBJECT_TYPE_ID6 = 2530 then CHG_AMOUNT6  else 0 end +
Case when OBJECT_TYPE_ID7 = 2530 then CHG_AMOUNT7  else 0 end +
Case when OBJECT_TYPE_ID8 = 2530 then CHG_AMOUNT8  else 0 end +
Case when OBJECT_TYPE_ID9 = 2530 then CHG_AMOUNT9  else 0 end)as float))/100)Sousc_COM_AirTime_Without_Tax
into #Sousc_COM_AirTime
From dbo.OCSCOM_NUPGRD with (nolock)
Where PPN_DT=@PPN_DT
Group by cast(TIME_STAMP as date),PRI_IDENTITY

Delete From AnalyticsStaging.dbo.CVAS_HANANA_COM_AIRTIME Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_COM_AIRTIME
Select PPN_DT,PRI_IDENTITY,sum(Sousc_COM_AirTime)Sousc_COM_AirTime,sum(Sousc_COM_AirTime_Without_Tax)Sousc_COM_AirTime_Without_Tax
From #Sousc_COM_AirTime
Group by PPN_DT,PRI_IDENTITY
*/
--- HANANA AIRTIME 

Select cast(CUST_LOCAL_START_DATE as date)PPN_DT,PRI_IDENTITY,count(1)Nbre,
       Case when ((CHG_AMOUNT*100)/88.2)=200  then 'CFA 200 Airtime'
	        when ((CHG_AMOUNT*100)/88.2)=300  then 'CFA 300 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=500  then 'CFA 500 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=750  then 'CFA 750 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=1000 then 'CFA 1000 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=1500 then 'CFA 1500 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=2000 then 'CFA 2000 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=3000 then 'CFA 3000 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=5000 then 'CFA 5000 Airtime'
		Else 'Other' end Hanana_Air_Time, sum ((CHG_AMOUNT*100)/88.2) Amount

Into #Hanana_AirTime
From #tmgr
Where Oper_ID='332' and  OBJECT_TYPE_ID = 2530 and OPER_TYPE = '2' --and RESULT_CODE='0'
Group by cast(CUST_LOCAL_START_DATE as date),PRI_IDENTITY,
       Case when ((CHG_AMOUNT*100)/88.2)=200  then 'CFA 200 Airtime'
	        when ((CHG_AMOUNT*100)/88.2)=300  then 'CFA 300 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=500  then 'CFA 500 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=750  then 'CFA 750 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=1000 then 'CFA 1000 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=1500 then 'CFA 1500 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=2000 then 'CFA 2000 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=3000 then 'CFA 3000 Airtime'
			when ((CHG_AMOUNT*100)/88.2)=5000 then 'CFA 5000 Airtime'
		Else 'Other' end 

Drop table #tmgr

Delete From AnalyticsStaging.dbo.CVAS_HANANA_AIRTIME Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_AIRTIME
Select PPN_DT,Hanana_Air_Time,PRI_IDENTITY,sum(Nbre)Nbre,sum(Amount)Amount
From #Hanana_AirTime
Group by PPN_DT,Hanana_Air_Time,PRI_IDENTITY

End
GO

/****** Object:  StoredProcedure [dbo].[HANANA_CVAS_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[HANANA_CVAS_NAC] (
	@PPN_DT	DATE
)
AS

Begin

If object_id('tempdb..#tx')   is not null  drop table #tx
If object_id('tempdb..#tmp1') is not null  drop table #tmp1
If object_id('tempdb..#tmp2') is not null  drop table #tmp2
If object_id('tempdb..#tmp3') is not null  drop table #tmp3
If object_id('tempdb..#tmp4') is not null  drop table #tmp4
If object_id('tempdb..#tmp11')is not null  drop table #tmp11
If object_id('tempdb..#tempRepayment')   is not null  drop table #tempRepayment


Select PPN_DT,right(PRI_IDENTITY,8)PRI_IDENTITY,left(EXT_TRANS_ID,18)EXT_TRANS_ID
	  ,(cast(CHG_AMOUNT as float))/100 CHG_AMOUNT,Oper_ID,OBJECT_TYPE_ID,OPER_TYPE,RESULT_CODE
Into #tx
From AnalyticsStaging.dbo.OCSMGR_NUPGRD with (nolock) where PPN_DT=@PPN_DT and STD_EVT_TYPE_ID!='13025'

------------------------------------------------------------ HANANA VAS ------------------------------------------------------------------

Select PPN_DT,PRI_IDENTITY,EXT_TRANS_ID,CHG_AMOUNT/1.129 Hanana_VAS,CHG_AMOUNT Hanana_VAS_With_Tax
Into #tmp1
From #tx where  Oper_ID ='332' and  OBJECT_TYPE_ID =2532 and OPER_TYPE = '2' --and RESULT_CODE='0'

------------------------------------------------------------SOUSCRIPTION KATTIR HANANA ---------------------------------------------------

Select PPN_DT,PRI_IDENTITY,EXT_TRANS_ID,CHG_AMOUNT/1.129 Hanana_Kattir,CHG_AMOUNT Hanana_Kattir_With_Tax
	--,case when (not CHG_AMOUNT like '%0' or CHG_AMOUNT = 4410) then ((CHG_AMOUNT*100)/88.2)/1.129 Else CHG_AMOUNT/1.129 End Hanana_Kattir
	--,case when (not CHG_AMOUNT like '%0' or CHG_AMOUNT = 4410) then (CHG_AMOUNT*100)/88.2 Else CHG_AMOUNT End Hanana_Kattir_With_Tax
Into #tmp11 -- 210418
From #tx where  Oper_ID ='332' and  OBJECT_TYPE_ID = 2531 and OPER_TYPE = '2' --and RESULT_CODE='0'

/*
Select PPN_DT,PRI_IDENTITY,EXT_TRANS_ID,CHG_AMOUNT/1.129 Hanana_Kattir,CHG_AMOUNT Hanana_Kattir_With_Tax
Into #tmp11 -- 210418
From #tx
Where  Oper_ID='332' and  OBJECT_TYPE_ID='2531'
*/
-----------------------------------HANANA REPAYMENT

Select PPN_DT,PRI_IDENTITY,CHG_AMOUNT 
Into #tempRepayment
From #tx where Oper_ID='332' and  OBJECT_TYPE_ID = 2000 --and RESULT_CODE='0'

---------------------------------- EXTRACTION DE PRODUCT ID DE MON ------------------------------------

Select PPN_DT,right(PRI_IDENTITY,8)PRI_IDENTITY,OfferingID,left(RECIPIENT_NUMBER,18)RECIPIENT_NUMBER 
Into #tmp2
From dbo.OCSMON_NUPGRD with (nolock) Where PPN_DT=@PPN_DT --and RESULT_CODE='0'

-------------------- JOINTURE POUR OBTENIR LES TYPES DE KATTIR -------------------

Select a.PPN_DT,a.PRI_IDENTITY,b.OfferingID,a.Hanana_VAS,a.Hanana_VAS_With_Tax
Into #tmp3
From #tmp1 a left outer join #tmp2 b
on a.PPN_DT=b.PPN_DT and a.PRI_IDENTITY=b.PRI_IDENTITY and a.EXT_TRANS_ID=b.RECIPIENT_NUMBER

Select a.PPN_DT,a.PRI_IDENTITY,b.OfferingID,a.Hanana_Kattir,a.Hanana_Kattir_With_Tax
Into #tmp4
From #tmp11 a left outer join #tmp2 b
on a.PPN_DT=b.PPN_DT and a.PRI_IDENTITY=b.PRI_IDENTITY and a.EXT_TRANS_ID=b.RECIPIENT_NUMBER

------------------------------------------------ JOINTURE -----------------------------------------------

Delete From AnalyticsStaging.dbo.CVAS_HANANA_VAS Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_VAS
Select PPN_DT,PRI_IDENTITY,count(1)Nbre,
       case --when OfferingID = 1250 then 'Hanana_Loan_1250'
			--when OfferingID = 1251 then 'Hanana_Loan_1251'
			--when OfferingID = 1252 then 'Hanana_Loan_1252'
			--when OfferingID = 1253 then 'Hanana_Loan_1253'
			when OfferingID = 2125 then 'Hanana150'
	        when OfferingID = 2126 then 'Hanana200'
			when OfferingID = 2127 then 'Hanana400'
			when OfferingID = 2128 then 'Hanana500'
			when OfferingID = 2129 then 'Maxi_1000'--Hanana_MAXI
			when OfferingID = 2130 then 'Hanana_Mix500' --Hanana2000
			when OfferingID = 2131 then 'Hanana_Mix1000' --Hanana3000
			when OfferingID = 2133 then 'Hanana_Data_200MB'
			when OfferingID = 2134 then 'Hanana_Data_1GB'
			when OfferingID = 2163 then 'Ziada_100'
			when OfferingID = 2164 then 'Ziada_250'
			when OfferingID = 2271 then 'Hanana_Data_300MB' --Hanana_data_Illimite
			Else 'Hanana Adjustment' 
		End Hanana_Type
		,sum(Hanana_VAS)Hanana_VAS,sum(Hanana_VAS_With_Tax)Hanana_VAS_With_Tax

From #tmp3 where Hanana_VAS <>0
Group by PPN_DT,PRI_IDENTITY, 
       case --when OfferingID = 1250 then 'Hanana_Loan_1250'
			--when OfferingID = 1251 then 'Hanana_Loan_1251'
			--when OfferingID = 1252 then 'Hanana_Loan_1252'
			--when OfferingID = 1253 then 'Hanana_Loan_1253'
			when OfferingID = 2125 then 'Hanana150'
	        when OfferingID = 2126 then 'Hanana200'
			when OfferingID = 2127 then 'Hanana400'
			when OfferingID = 2128 then 'Hanana500'
			when OfferingID = 2129 then 'Maxi_1000'
			when OfferingID = 2130 then 'Hanana_Mix500'
			when OfferingID = 2131 then 'Hanana_Mix1000'
			when OfferingID = 2133 then 'Hanana_Data_200MB'
			when OfferingID = 2134 then 'Hanana_Data_1GB'
			when OfferingID = 2163 then 'Ziada_100'
			when OfferingID = 2164 then 'Ziada_250'
			when OfferingID = 2271 then 'Hanana_Data_300MB'
			Else 'Hanana Adjustment' End

-- Select * From dbo.CVAS_HANANA_VAS
---------------------------------------------------------------------------------------------------------------
Delete From AnalyticsStaging.dbo.CVAS_HANANA_KATTIR Where ppn_dt=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_KATTIR
Select PPN_DT,PRI_IDENTITY,count(distinct PRI_IDENTITY)Subs,count(1)Nbre,
       case --when OfferingID = 1250 then 'Hanana_Loan_1250'
			--when OfferingID = 1251 then 'Hanana_Loan_1251'
			--when OfferingID = 1252 then 'Hanana_Loan_1252'
			--when OfferingID = 1253 then 'Hanana_Loan_1253'
			when OfferingID = 2125 then 'Hanana150'
	        when OfferingID = 2126 then 'Hanana200'
			when OfferingID = 2127 then 'Hanana400'
			when OfferingID = 2128 then 'Hanana500'
			when OfferingID = 2129 then 'Maxi_1000'
			when OfferingID = 2130 then 'Hanana_Mix500'
			when OfferingID = 2131 then 'Hanana_Mix1000'
			when OfferingID = 2133 then 'Hanana_Data_200MB'
			when OfferingID = 2134 then 'Hanana_Data_1GB'
			when OfferingID = 2163 then 'Ziada_100'
			when OfferingID = 2164 then 'Ziada_250'
			when OfferingID = 2271 then 'Hanana_Data_300MB'
			Else 'Hanana Adjustment'
		End Hanana_Type
		,sum(Hanana_Kattir)Hanana_Kattir,sum(Hanana_Kattir_With_Tax)Hanana_Kattir_With_Tax

From #tmp4 where Hanana_Kattir <>0
Group by PPN_DT,PRI_IDENTITY, 
       case --when OfferingID = 1250 then 'Hanana_Loan_1250'
			--when OfferingID = 1251 then 'Hanana_Loan_1251'
			--when OfferingID = 1252 then 'Hanana_Loan_1252'
			--when OfferingID = 1253 then 'Hanana_Loan_1253'
			when OfferingID = 2125 then 'Hanana150'
	        when OfferingID = 2126 then 'Hanana200'
			when OfferingID = 2127 then 'Hanana400'
			when OfferingID = 2128 then 'Hanana500'
			when OfferingID = 2129 then 'Maxi_1000'
			when OfferingID = 2130 then 'Hanana_Mix500'
			when OfferingID = 2131 then 'Hanana_Mix1000'
			when OfferingID = 2133 then 'Hanana_Data_200MB'
			when OfferingID = 2134 then 'Hanana_Data_1GB'
			when OfferingID = 2163 then 'Ziada_100'
			when OfferingID = 2164 then 'Ziada_250'
			when OfferingID = 2271 then 'Hanana_Data_300MB'
			Else 'Hanana Adjustment' End

-- Select * From AnalyticsStaging.dbo.CVAS_HANANA_KATTIR


-- AGGREGATION REPAYMENT
Delete From AnalyticsStaging.dbo.CVAS_HANANA_REPAYMENT Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.CVAS_HANANA_REPAYMENT
Select PPN_DT ,PRI_IDENTITY Msisdn,count(1)Nbre,sum(CHG_AMOUNT)Repayment
From #tempRepayment
Group by  PPN_DT ,PRI_IDENTITY

-- Select * From AnalyticsStaging.dbo.CVAS_HANANA_REPAYMENT

End
GO

/****** Object:  StoredProcedure [dbo].[LOCALISATION_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LOCALISATION_NAC]
(
@Ppn_dt date
)As

--Declare @Ppn_dt date
--Set @Ppn_dt =dateadd(dd,0,cast(getdate()-1 as date))

--Delete from DailyLocation where Ppn_dt=@Ppn_dt
Insert into DailyLocation
Select Right(CallingPartyNumber,8)Msisdn,CallingCellID
from dbo.OCSREC_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt and ServiceFlow='1' 
and left(right(CallingPartyNumber,8),1)='9' 
and len(right(CallingPartyNumber,8))='8'
and CallingCellID<>'' and  RoamState='0'

Insert into DailyLocation
Select Right(CalledPartyNumber,8)Msisdn,CalledCellID
from dbo.OCSREC_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt and ServiceFlow='2' 
and left(right(CalledPartyNumber,8),1)='9' 
and len(right(CalledPartyNumber,8))='8'
and CalledCellID<>'' and  RoamState='0'

Insert into DailyLocation
Select Right(CallingPartyNumber,8)Msisdn,CallingCellID
from dbo.OCSSMS_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt and ServiceFlow='1' 
and left(right(CallingPartyNumber,8),1)='9' 
and len(right(CallingPartyNumber,8))='8'
and CallingCellID<>'' and  RoamState='0'

Insert into DailyLocation
Select Right(CalledPartyNumber,8)Msisdn,CalledCellID
from dbo.OCSSMS_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt and ServiceFlow='2' 
and left(right(CalledPartyNumber,8),1)='9' 
and len(right(CalledPartyNumber,8))='8'
and CalledCellID<>'' and  RoamState='0'

Insert into DailyLocation
Select Right(CallingPartyNumber,8)Msisdn,case when len (CallingCellID)>15 then right(CallingCellID,15) else CallingCellID end CallingCellID
from dbo.OCSDATA_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt
and left(right(CallingPartyNumber,8),1)='9' 
and len(right(CallingPartyNumber,8))='8'
and CallingCellID<>'' and len (CallingCellID)>='15';

WITH Duplicates 
AS
(
Select *,
 row_number() OVER(PARTITION BY Msisdn,CallingCellID ORDER BY Msisdn DESC) Rn
From AnalyticsStaging.dbo.DailyLocation with (nolock)
)
Delete from Duplicates where rn >= 2;

--Declare @Ppn_dt date
--Set @Ppn_dt =dateadd(dd,0,cast(getdate()-1 as date))

Delete from Daily_GEO_Location_NEW where Ppn_dt=@Ppn_dt
Insert into Daily_GEO_Location_NEW
Select @Ppn_dt Ppn_dt,a.Msisdn,b.STT_NM,b.TRRTRY_NM,b.PRVNC_NM,b.CITY_NM,b.BTSName
from AnalyticsStaging.dbo.DailyLocation a
left outer join dbo.BTS_SITE_NEW b with(nolock) on a.CallingCellID=b.CELLULE

;WITH Duplicates
AS
(
Select *,
 row_number() OVER(PARTITION BY PPN_DT,Msisdn,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTSName ORDER BY PPN_dT DESC) Rn
From AnalyticsStaging.dbo.Daily_GEO_Location_NEW with (nolock)
where ppn_dt =@Ppn_dt
)
Delete from Duplicates where rn >= 2;

Truncate table DailyLocation
/*
Delete from [192.168.50.148\ANALYTICS].[AnalyticsReporting].[dbo].Daily_GEO_Location_NEW where Ppn_dt=@Ppn_dt
Insert into [192.168.50.148\ANALYTICS].[AnalyticsReporting].[dbo].Daily_GEO_Location_NEW
Select Ppn_dt,Msisdn,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTSName
From AnalyticsStaging.dbo.Daily_GEO_Location_NEW where Ppn_dt=@Ppn_dt
*/
GO

/****** Object:  StoredProcedure [dbo].[LOCALISATION_NACN]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LOCALISATION_NACN]
(
@Ppn_dt date
)As

---alter table DailyLocation add Nombre int 
--Declare @Ppn_dt date
--Set @Ppn_dt =dateadd(dd,0,cast(getdate()-1 as date))

--Delete from DailyLocation where Ppn_dt=@Ppn_dt
Insert into DailyLocation
Select Right(CallingPartyNumber,8)Msisdn,CallingCellID, count(*) nbre
from dbo.OCSREC_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt and ServiceFlow='1' 
and left(right(CallingPartyNumber,8),1)='9' 
and len(right(CallingPartyNumber,8))='8'
and CallingCellID<>'' and  RoamState='0'
group by Right(CallingPartyNumber,8),CallingCellID

Insert into DailyLocation
Select Right(CalledPartyNumber,8)Msisdn,CalledCellID, count(*) nbre
from dbo.OCSREC_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt and ServiceFlow='2' 
and left(right(CalledPartyNumber,8),1)='9' 
and len(right(CalledPartyNumber,8))='8'
and CalledCellID<>'' and  RoamState='0'
group by Right(CalledPartyNumber,8),CalledCellID

Insert into DailyLocation
Select Right(CallingPartyNumber,8)Msisdn,CallingCellID, count(*) nbre
from dbo.OCSSMS_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt and ServiceFlow='1' 
and left(right(CallingPartyNumber,8),1)='9' 
and len(right(CallingPartyNumber,8))='8'
and CallingCellID<>'' and  RoamState='0'
group by Right(CallingPartyNumber,8),CallingCellID

Insert into DailyLocation
Select Right(CalledPartyNumber,8)Msisdn,CalledCellID, count(*) nbre
from dbo.OCSSMS_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt and ServiceFlow='2' 
and left(right(CalledPartyNumber,8),1)='9' 
and len(right(CalledPartyNumber,8))='8'
and CalledCellID<>'' and  RoamState='0'
group by Right(CalledPartyNumber,8),CalledCellID

Insert into DailyLocation
Select Right(CallingPartyNumber,8)Msisdn,case when len (CallingCellID)>15 then right(CallingCellID,15) else CallingCellID end CallingCellID, count(*) nbre
from dbo.OCSDATA_NUPGRD with(nolock)
where Ppn_dt=@Ppn_dt
and left(right(CallingPartyNumber,8),1)='9' 
and len(right(CallingPartyNumber,8))='8'
and CallingCellID<>'' and len (CallingCellID)>='15'
group by Right(CallingPartyNumber,8),case when len (CallingCellID)>15 then right(CallingCellID,15) else CallingCellID end ;


WITH Duplicates 
AS
(
Select *,
 row_number() OVER(PARTITION BY Msisdn,CallingCellID ORDER BY Msisdn DESC) Rn
From AnalyticsStaging.dbo.DailyLocation with (nolock)
)
Delete from Duplicates where rn >= 2;

Select MSISDN, CallingCellID, sum(Nombre) Nombre into #t from DailyLocation group by MSISDN, CallingCellID


Select MSISDN, CallingCellID, row_number() OVER(PARTITION BY Msisdn ORDER BY Nombre DESC) RO into #tt
From #t with (nolock)


Delete from Daily_GEO_Location_NEW where Ppn_dt=@Ppn_dt
Insert into Daily_GEO_Location_NEW
Select @Ppn_dt Ppn_dt,a.Msisdn,b.STT_NM,b.TRRTRY_NM,b.PRVNC_NM,b.CITY_NM,b.BTSName
from #tt a
left outer join dbo.BTS_SITE_NEW b with(nolock) on a.CallingCellID=b.CELLULE 
where   RO=1

--Declare @Ppn_dt date
--Set @Ppn_dt =dateadd(dd,0,cast(getdate()-1 as date))
/*
Delete from Daily_GEO_Location_NEW where Ppn_dt=@Ppn_dt
Insert into Daily_GEO_Location_NEW
Select @Ppn_dt Ppn_dt,a.Msisdn,b.STT_NM,b.TRRTRY_NM,b.PRVNC_NM,b.CITY_NM,b.BTSName
from AnalyticsStaging.dbo.DailyLocation a
left outer join dbo.BTS_SITE_NEW b with(nolock) on a.CallingCellID=b.CELLULE

;
*/

;WITH Duplicates
AS
(
Select *,
 row_number() OVER(PARTITION BY PPN_DT,Msisdn,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTSName ORDER BY PPN_dT DESC) Rn
From AnalyticsStaging.dbo.Daily_GEO_Location_NEW with (nolock)
where ppn_dt =@Ppn_dt
)
Delete from Duplicates where rn >= 2;

Truncate table DailyLocation
Truncate table #t
Truncate table #tt
/*
Delete from [192.168.50.148\ANALYTICS].[AnalyticsReporting].[dbo].Daily_GEO_Location_NEW where Ppn_dt=@Ppn_dt
Insert into [192.168.50.148\ANALYTICS].[AnalyticsReporting].[dbo].Daily_GEO_Location_NEW
Select Ppn_dt,Msisdn,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTSName
From AnalyticsStaging.dbo.Daily_GEO_Location_NEW where Ppn_dt=@Ppn_dt
*/

--Select * from Daily_GEO_Location_NEW where ppn_dt ='2021-07-13' AND MSISDN='91585104'
GO

/****** Object:  StoredProcedure [dbo].[MFS_DAILY_TRANSFERT_REPORT_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[MFS_DAILY_TRANSFERT_REPORT_NAC] 
(
	@ppn_dt1 date
)
as

Begin
Declare @ppn_dt date
--declare @ppn_dt1 date
--set @ppn_dt1= dateadd(dd,0,cast(getdate()-1 as date))
Set @ppn_dt= dateadd(dd,1,@PPN_DT1)--dateadd(dd,0,cast(getdate() as date))
--Select @ppn_dt ppn_dt,@ppn_dt1 ppn_dt1

-------------------------------------------------------- TRANSFERT AMOUNT ---------------------------------------------------------
Select PPN_DT,TOMSISDN,FRMSISDN,REFERENCEID,sum(cast(AMOUNT as float))AMOUNT
into #temp
from dbo.TRANSACTIONS_TC_UPGRD with (nolock)
where PPN_DT=@ppn_dt1 and STATUS='0'and Type in ('GIVE','DTHR') and FRMSISDN is not null
      and TOMSISDN in (Select MSISDN
from dbo.[AGENT_DETAILS_TC_UPGRD] with(nolock)
where ppn_dt=@ppn_dt)
	  and FRMSISDN in (Select MSISDN
from dbo.[AGENT_DETAILS_TC_UPGRD] with(nolock)
where ppn_dt=@ppn_dt)
Group by PPN_DT,TOMSISDN,FRMSISDN,REFERENCEID

--Select * from #temp
------------------------------------------------------------ REVENUE TRANSFERT GENERATED -------------------------------------------------
Select PPN_DT,MSISDN,REFERENCEID,sum(cast(CREDIT as float))CREDIT--,TYPE
into #tempRev
from dbo.TRANSACTIONDETAILS_TC_UPGRD with (nolock)
where PPN_DT=@ppn_dt1 and Type='KEYCOST' --and TOMSISDN='REVENUE_p2p'
group by PPN_DT,MSISDN,REFERENCEID--,TYPE

--Select * from #tempRev where TYPE='KEYCOST' --Drop table #tempRev

Alter table #temp add REVENUE float
Alter table #temp add BILL_TYPE nvarchar(4)
Alter table #temp add CREDITOR_AGENT_TYPE nvarchar(55)
Alter table #temp add DEBTOR_AGENT_TYPE nvarchar(55)


update #temp set REVENUE=b.CREDIT
from #temp a 
left outer join
#tempRev b
on a.PPN_DT=b.PPN_DT
and a.REFERENCEID=b.REFERENCEID

update #temp set REVENUE=0
where REVENUE is null

update #temp set BILL_TYPE='Yes'
where REVENUE<>0.0000

update #temp set BILL_TYPE='No'
where BILL_TYPE is null


update #temp set DEBTOR_AGENT_TYPE=b.TYPE_NAME
from #temp a
left outer join
[dbo].[AGENT_DETAILS_TC_UPGRD] b
on a.FRMSISDN=b.MSISDN

update #temp set CREDITOR_AGENT_TYPE=b.TYPE_NAME
from #temp a
left outer join
[dbo].[AGENT_DETAILS_TC_UPGRD] b
on a.TOMSISDN=b.MSISDN

Delete from dbo.Daily_Agent_Transfert where PPN_DT=@ppn_dt1
Insert into dbo.Daily_Agent_Transfert
Select PPN_DT,TOMSISDN,FRMSISDN,AMOUNT,REVENUE,BILL_TYPE,CREDITOR_AGENT_TYPE,DEBTOR_AGENT_TYPE
From #temp

Drop table #temp
Drop table #tempRev
End
GO

/****** Object:  StoredProcedure [dbo].[STAGING_DAILY_INCOMING_XNET_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[STAGING_DAILY_INCOMING_XNET_NAC]
(
	@PPN_DT	DATE
)
AS
Begin

Select PPN_DT Fct_dt,CallingPartyNumber,CalledPartyNumber,sum(cast(ACTUAL_USAGE as float))/60 CallDuration
       ,case when left(CallingPartyNumber,4)='2356' then 'AIRTEL'
	         when left(CallingPartyNumber,4)='2357' then 'SALAM'
			 when left(CallingPartyNumber,6)='235223' then 'TAWALI SEMI MOBILE'
			 when left(CallingPartyNumber,6) in ('235227','235228') then 'TAWALI  MOBILE'
			 when left(CallingPartyNumber,7) in ('2352252','2352251','2352253','2352250','2352268','2352269') then 'SOTEL FIXE'
			 else 'UNKNOWN'
		End Operator

Into #IncomingXnet
From dbo.OCSREC_NUPGRD with (nolock)
Where (PPN_DT=@PPN_DT) and ServiceFlow='2' and RoamState<>'3' --and RESULT_CODE='0' 
and left(CallingPartyNumber,4) in ('2356','2357','2352') and len(right(CallingPartyNumber,8))='8'
Group by PPN_DT,CallingPartyNumber,CalledPartyNumber,
         case when left(CallingPartyNumber,4)='2356' then 'AIRTEL'
			  when left(CallingPartyNumber,4)='2357' then 'SALAM'
			  when left(CallingPartyNumber,6)='235223' then 'TAWALI SEMI MOBILE'
			  when left(CallingPartyNumber,6) in ('235227','235228') then 'TAWALI  MOBILE'
			  when left(CallingPartyNumber,7) in ('2352252','2352251','2352253','2352250','2352268','2352269') then 'SOTEL FIXE'
			  else 'UNKNOWN' End 

Delete From dbo.STAGING_DAILY_INCOMINGXNET Where Fct_dt=@PPN_DT
Insert into dbo.STAGING_DAILY_INCOMINGXNET
Select Fct_dt,right(CalledPartyNumber,8)Msisdn,Operator,sum(CallDuration)CallDuration,
         case when Operator in ('SALAM','AIRTEL') then CallDuration*68
	          when Operator in ('UNKNOWN') then CallDuration*60
	          when Operator in ('SOTEL FIXE','TAWALI SEMI MOBILE','TAWALI  MOBILE') then CallDuration*60
			  else 0 End Rev_IncXnet
From #IncomingXnet
Group by Fct_dt,right(CalledPartyNumber,8),Operator , case when Operator in ('SALAM','AIRTEL') then CallDuration*68
	          when Operator in ('UNKNOWN') then CallDuration*60
	          when Operator in ('SOTEL FIXE','TAWALI SEMI MOBILE','TAWALI  MOBILE') then CallDuration*60
			  else 0 End 

Drop table #IncomingXnet
End
-- Select * From dbo.STAGING_DAILY_INCOMINGXNET
GO

/****** Object:  StoredProcedure [dbo].[STAGING_DAILY_OUTGOING_VOICE_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[STAGING_DAILY_OUTGOING_VOICE_NAC]
(
	@PPN_DT	DATE
)
AS
Begin

Delete from dbo.STAGING_DAILY_OUTGOING where Fct_dt=@PPN_DT
Insert into dbo.STAGING_DAILY_OUTGOING
Select PPN_DT,CallingPartyNumber,CalledPartyNumber
       ,sum(cast(CHARGE_FROM_ACCOUNT as float))/100 Billd_Amnt,sum(cast(ACTUAL_USAGE as float))/60 CallDuration
--into dbo.STAGING_DAILY_OUTGOING
From dbo.OCSREC_NUPGRD with (nolock)
Where (PPN_DT=@PPN_DT) and ServiceFlow='1' --and RESULT_CODE='0'
Group by PPN_DT,CallingPartyNumber,CalledPartyNumber

End
GO

/****** Object:  StoredProcedure [dbo].[STAGING_DATA_OD_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[STAGING_DATA_OD_NAC]
(
	@PPN_DT	DATE
)
as

Begin
Declare @PPN_DT3 date
Set @PPN_DT3=dateadd(dd,0,cast(getdate()-7 as date))
If object_id('tempdb..#tdata')is not null  drop table #tdata

Select CDR_ID,CUST_LOCAL_START_DATE,CUST_LOCAL_END_DATE,TIME_STAMP,PRI_IDENTITY,CHARGE_FROM_ACCOUNT,
OBJECT_TYPE_ID,OBJECT_TYPE_ID1,OBJECT_TYPE_ID2,OBJECT_TYPE_ID3,OBJECT_TYPE_ID4,OBJECT_TYPE_ID5,OBJECT_TYPE_ID6,OBJECT_TYPE_ID7,OBJECT_TYPE_ID8,OBJECT_TYPE_ID9,OBJECT_TYPE_ID10,OBJECT_TYPE_ID11,OBJECT_TYPE_ID12,OBJECT_TYPE_ID13,OBJECT_TYPE_ID14,
CHG_AMOUNT,CHG_AMOUNT1,CHG_AMOUNT2,CHG_AMOUNT3,CHG_AMOUNT4,CHG_AMOUNT5,CHG_AMOUNT6,CHG_AMOUNT7,CHG_AMOUNT8,CHG_AMOUNT9,CHG_AMOUNT10,CHG_AMOUNT11,CHG_AMOUNT12,CHG_AMOUNT13,CHG_AMOUNT14,
ROAMSTATE,CallingCellID,LastEffectOffering,MainOfferingID,RATType,APN,CallingPartyNumber,ACTUAL_USAGE2,UpFlux,DownFlux,RATE_USAGE2,FREE_UNIT_AMOUNT_OF_FLUX,CUR_AMOUNT,CUR_AMOUNT1,
DEBIT_FROM_PREPAID,TOTAL_TAX,REFERENCE,PPN_DT,CURRENT_AMOUNT into #tdata
from OCSDATA_NUPGRD with (nolock) Where PPN_DT = @PPN_DT --and RESULT_CODE='0'

Delete From AnalyticsStaging.dbo.DATA_OD_NAC where PPN_DT<=@PPN_DT3
Delete From AnalyticsStaging.dbo.DATA_OD_NAC where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.DATA_OD_NAC
Select	RIGHT(RTRIM(PRI_IDENTITY),8) MSISDN_DD
		,cast(CDR_ID as VARCHAR(50)) UNQ_CD_SRC_STM1
		,format(TIME_STAMP,'yyyyMMddHHmss') UNQ_CD_SRC_STM2
		,COALESCE(cast(CHARGE_FROM_ACCOUNT as numeric(18, 4)) / 100,0) CHARGE_FROM_ACCOUNT 
		,Case when OBJECT_TYPE_ID   = 2000 then cast(CHG_AMOUNT  as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT
		,Case when OBJECT_TYPE_ID1  = 2000 then cast(CHG_AMOUNT1 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT1
		,Case when OBJECT_TYPE_ID2  = 2000 then cast(CHG_AMOUNT2 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT2
		,Case when OBJECT_TYPE_ID3  = 2000 then cast(CHG_AMOUNT3 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT3
		,Case when OBJECT_TYPE_ID4  = 2000 then cast(CHG_AMOUNT4 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT4
		,Case when OBJECT_TYPE_ID5  = 2000 then cast(CHG_AMOUNT5 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT5
		,Case when OBJECT_TYPE_ID6  = 2000 then cast(CHG_AMOUNT6 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT6
		,Case when OBJECT_TYPE_ID7  = 2000 then cast(CHG_AMOUNT7 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT7
		,Case when OBJECT_TYPE_ID8  = 2000 then cast(CHG_AMOUNT8 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT8
		,Case when OBJECT_TYPE_ID9  = 2000 then cast(CHG_AMOUNT9 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT9
		,Case when OBJECT_TYPE_ID10 = 2000 then cast(CHG_AMOUNT10 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT10
		,Case when OBJECT_TYPE_ID11 = 2000 then cast(CHG_AMOUNT11 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT11
		,Case when OBJECT_TYPE_ID12 = 2000 then cast(CHG_AMOUNT12 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT12
		,Case when OBJECT_TYPE_ID13 = 2000 then cast(CHG_AMOUNT13 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT13
		,Case when OBJECT_TYPE_ID14 = 2000 then cast(CHG_AMOUNT14 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT14
		,Case when ROAMSTATE=3 or CallingCellID IS NULL then '-1'
			  when CallingCellID  like '%[a-z]%' then '-1'
		      else RIGHT(CallingCellID, 9)
	     End as SCTR_KEY_LKP
		,cast(LastEffectOffering as VARCHAR(50)) as PD_KEY_LKP
		,Case [RATType] 
			   when 1 then '1'
			   when 2 then '2'
			   when 3 then '3'
			   when 4 then '4'
			   when 5 then '5'
			   when 6 then '6'
			   when 10 then '10'
		 End as NTW_KEY_LKP
		,DATEDIFF(SS, cast(CUST_LOCAL_START_DATE as datetime),  cast(CUST_LOCAL_END_DATE as datetime)) as DRTN
		,MainOfferingID PLN_KEY_LKP-- TRY_CONVERT(VARCHAR(50), [MainOfferingID]) as PLN_KEY_LKP
		,ACTUAL_USAGE2 as BYTES_USG
		,UpFlux as BYTES_UPLD
		,DownFlux as BYTES_DWLD
		,RATE_USAGE2 as BILLD_BYTES 
		,FREE_UNIT_AMOUNT_OF_FLUX as [BILL_0_W_IDR_REV_BYTES]
		,(Case when OBJECT_TYPE_ID = '0' then RATE_USAGE2 else '0' end) as [BILL_0_WOUT_REV_BYTES]
		,COALESCE(cast(DEBIT_FROM_PREPAID as numeric(18, 4)) / 100, 0) as DEBIT_FROM_PREPAID
		,cast(TOTAL_TAX as numeric(18,4)) / 100 as NEWDAILYTAXE -- New Tax
		,PPN_DT
		,ROW_NUMBER() OVER (PARTITION BY CDR_ID, TIME_STAMP ORDER BY PPN_DT) RN

From #tdata--[dbo].[OCSDATA_NUPGRD] with (nolock)
Where (CDR_ID IS NOT NULL and len(CDR_ID)>=16) AND PRI_IDENTITY IS NOT NULL and CURRENT_AMOUNT>=0.0000
Drop table #tdata

Delete From dbo.AGG_DATA_OD where PPN_DT = @PPN_DT
Insert into dbo.AGG_DATA_OD
Select PPN_DT,count(distinct MSISDN_DD)Subs,sum(CHARGE_FROM_ACCOUNT)Billt_Amnt,sum(NEWDAILYTAXE)DailyTaxe,sum(BILLD_BYTES)/(1024*1024)Traffic
From AnalyticsStaging.dbo.DATA_OD_NAC with(nolock)
Where PPN_DT = @PPN_DT
group by PPN_DT 

Delete From dbo.AGG_DATA_USER where PPN_DT = @PPN_DT
Insert into dbo.AGG_DATA_USER
Select PPN_DT,MSISDN_DD,sum(CHARGE_FROM_ACCOUNT)Billt_Amnt,sum(NEWDAILYTAXE)DailyTaxe,sum(BILLD_BYTES)/(1024*1024)Traffic
From AnalyticsStaging.dbo.DATA_OD_NAC with(nolock)
Where PPN_DT =@PPN_DT
group by PPN_DT,MSISDN_DD

End
GO

/****** Object:  StoredProcedure [dbo].[STAGING_EXPIRED_REV_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[STAGING_EXPIRED_REV_NAC]
(
	@PPN_DT	DATE
)
AS
Begin
Declare @PPN_DT3 date
Set @PPN_DT3=dateadd(dd,0,cast(getdate()-3 as date))

Delete from  dbo.EXPIRED_REV_NAC  where ppn_dt<=@PPN_DT3
Delete from  dbo.EXPIRED_REV_NAC  where ppn_dt=@PPN_DT
Insert into dbo.EXPIRED_REV_NAC
Select  RIGHT(RTRIM(PRI_IDENTITY),8) MSISDN_DD
	   ,CAST(CDR_ID AS VARCHAR(50)) UNQ_CD_SRC_STM1
	   ,format(TIME_STAMP,'yyyyMMddHHmss') UNQ_CD_SRC_STM2
	   ,TRY_CONVERT(VARCHAR(50), PrimaryOfferingID) PLN_KEY_LKP
	   ,Case when OBJECT_TYPE_ID   = 2000 then CAST(CHG_AMOUNT  as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT
	   ,Case when OBJECT_TYPE_ID1  = 2000 then CAST(CHG_AMOUNT1 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT1
	   ,Case when OBJECT_TYPE_ID2  = 2000 then CAST(CHG_AMOUNT2 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT2
	   ,Case when OBJECT_TYPE_ID3  = 2000 then CAST(CHG_AMOUNT3 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT3
	   ,Case when OBJECT_TYPE_ID4  = 2000 then CAST(CHG_AMOUNT4 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT4
	   ,Case when OBJECT_TYPE_ID5  = 2000 then CAST(CHG_AMOUNT5 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT5
	   ,Case when OBJECT_TYPE_ID6  = 2000 then CAST(CHG_AMOUNT6 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT6
	   ,Case when OBJECT_TYPE_ID7  = 2000 then CAST(CHG_AMOUNT7 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT7
	   ,Case when OBJECT_TYPE_ID8  = 2000 then CAST(CHG_AMOUNT8 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT8
	   ,Case when OBJECT_TYPE_ID9  = 2000 then CAST(CHG_AMOUNT9 as numeric(18,4)) / 100 else 0 end AS CHG_AMOUNT9
	   ,Case when OBJECT_TYPE_ID10 = 2000 then CAST(CHG_AMOUNT10 as numeric(18,4))/ 100 else 0 end AS CHG_AMOUNT10
	   ,Case when OBJECT_TYPE_ID11 = 2000 then CAST(CHG_AMOUNT11 as numeric(18,4))/ 100 else 0 end AS CHG_AMOUNT11
	   ,Case when OBJECT_TYPE_ID12 = 2000 then CAST(CHG_AMOUNT12 as numeric(18,4))/ 100 else 0 end AS CHG_AMOUNT12
	   ,Case when OBJECT_TYPE_ID13 = 2000 then CAST(CHG_AMOUNT13 as numeric(18,4))/ 100 else 0 end AS CHG_AMOUNT13
	   ,Case when OBJECT_TYPE_ID14 = 2000 then CAST(CHG_AMOUNT14 as numeric(18,4))/ 100 else 0 end AS CHG_AMOUNT14
	   ,REFERENCE
	   ,PPN_DT
	   ,ROW_NUMBER() OVER (PARTITION BY CDR_ID, TIME_STAMP ORDER BY PPN_DT) RN

From OCSCLR_NUPGRD with (nolock)
Where PPN_DT = @PPN_DT AND TIME_STAMP IS NOT NULL

Delete from AGG_EXPIRED where Fct_dt=@PPN_DT
Insert into AGG_EXPIRED
Select  left(PPN_DT,7)Month,PPN_DT Fct_dt,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5
                       +CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)Expired
        ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5
                       +CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)*0.129 DailyTax
        ,(sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5
                       +CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14) - 
          sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5
                       +CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)*0.129)Expired_With_Tax
        ,count(distinct MSISDN_DD)Subs 
From  [dbo].[EXPIRED_REV_NAC]  with(nolock)
Where PPN_DT=@PPN_DT
Group by left(PPN_DT,7), PPN_DT

End

GO

/****** Object:  StoredProcedure [dbo].[STAGING_GROSS_ADD_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[STAGING_GROSS_ADD_NAC]
(
	@PPN_DT	DATE
)
AS

Begin

Select STATUS_DATE,SUB_IDENTITY,DFT_ACCT_ID,EFF_DATE,ACTIVE_TIME into #tbo from AnalyticsStaging.[dbo].OCS_CBS_SUBSCRIBER_BO_ALL a with(nolock) where PPN_DT=@PPN_DT and STATUS='2' 
Select BALANCE_TYPE_ID,BALANCE/100 BALANCE,Account_ID into #tb from AnalyticsStaging.[dbo].OCS_CBS_CM_ACCT_BALANCE_ALL a with(nolock) where PPN_DT=@PPN_DT and BALANCE_TYPE_ID='2000'

Select STATUS_DATE Activation_dt,count(distinct SUB_IDENTITY)Subs
Into #DailyActivation
From #tbo a, #tb b
Where DFT_ACCT_ID=Account_ID
     and BALANCE in ('0','100','500')
	 and EFF_DATE<@PPN_DT 
     and STATUS_DATE=@PPN_DT
     and (--left(LASTCALLTIME,8)=left(TIMEENTERACTIVE,8) or
	      --left(LASTRECHARGETIME,8)=left(TIMEENTERACTIVE,8) or
		  --left(VALIDDATE,8)=left(TIMEENTERACTIVE,8) or
		  --left(LASTACTIVEDATE,8)=left(TIMEENTERACTIVE,8) or
		  --left(LASTCDRDATE,8)=left(TIMEENTERACTIVE,8) or
		  ACTIVE_TIME=STATUS_DATE
	      )
Group by STATUS_DATE

Delete from DailyGrossAdd where Activation_dt=@PPN_DT
Insert into DailyGrossAdd
Select * --into #DailyGrossAdd
From #DailyActivation with(nolock)

--DROP TABLE #DailyActivation

End

GO

/****** Object:  StoredProcedure [dbo].[STAGING_MFS_SUBS_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[STAGING_MFS_SUBS_NAC]
(
	@PPN_DT1	DATE
)
AS
BEGIN

Declare @PPN_DT date
---declare @PPN_DT1 date
Declare @PPN_DT60 date
---set @PPN_DT1 =dateadd(dd,0,cast(getdate()-1 as date)) 
Set @PPN_DT60 =dateadd(dd,-88,@PPN_DT1)
Set @PPN_DT =dateadd(dd,1,@PPN_DT1) 

Select cast(REGISTRATIONDATE as date)CreateDate,right(MSISDN,8)Msisdn
Into #SubsTC
From dbo.[REG_SUBSCRIBER_TC_UPGRD] with(nolock)
Where  PPN_DT=@PPN_DT and (Msisdn like '2359%' or isnull(Status,'')!='')

--FRMSISDN  drop table #tmpActivities
Select right(FRMSISDN,8) Msisdn,PPN_DT Adate
into #tmpActivities
from  dbo.TRANSACTIONS_TC_UPGRD a with(nolock)
      inner join CODE_DE_TRANSACTION b with(nolock)
      on a.Type=b.KEYY
where (PPN_DT between @PPN_DT60 and @PPN_DT1) --and LEN(rtrim(ltrim(Date)))=8
group by right(FRMSISDN,8),PPN_DT

-- TOMSISDN
Insert into #tmpActivities
Select right(TOMSISDN,8) Msisdn,PPN_DT Adate
--into  #tmpActivities
From  dbo.TRANSACTIONS_TC_UPGRD a with(nolock)
      inner join CODE_DE_TRANSACTION b with(nolock)
      on a.Type=b.KEYY
Where (PPN_DT between @PPN_DT60 and @PPN_DT1) --and LEN(rtrim(ltrim(Date)))=8
Group by right(TOMSISDN,8),PPN_DT

Alter table #SubsTC add Flag_Day nvarchar(4)
Alter table #SubsTC add Lst_dt_Activity date
Alter table #SubsTC add STT_NM nvarchar(55)
Alter table #SubsTC add TRRTRY_NM nvarchar(55)
Alter table #SubsTC add PRVNC_NM nvarchar(55)
Alter table #SubsTC add CITY_NM nvarchar(55)
Alter table #SubsTC add BTS_NM nvarchar(55)

-- select * from #tmpActivities

update a set  Flag_Day='Yes',Lst_dt_activity=b.ppn_dt
from #SubsTC a 
left outer join
(select max(Adate)ppn_dt,msisdn
from #tmpActivities
where (Adate between @PPN_DT60 and @PPN_DT1)
group by msisdn ) b
on a.MSISDN=b.msisdn
where b.msisdn is not null

update #SubsTC set  Flag_Day='No'
where Flag_Day is null

update a set  STT_NM=b.STT_NM, TRRTRY_NM=b.TRRTRY_NM,PRVNC_NM=b.PRVNC_NM
              ,CITY_NM=b.CITY_NM, BTS_NM=b.BTSName
from #SubsTC a 
left outer join
(select max(PPN_DT)PPN_DT,msisdn,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTSName
from Daily_GEO_Location_NEW with(nolock)
where (PPN_DT between @PPN_DT60 and @PPN_DT1)
      and STT_NM is not null 
group by msisdn,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTSName)b
on a.MSISDN=b.msisdn
where b.msisdn is not null

Delete from dbo.MFS_DAILY_SUBS where PPN_DT=@ppn_dt1
Insert into dbo.MFS_DAILY_SUBS
Select @ppn_dt1 PPN_DT,*
From #SubsTC

Delete from dbo.AGG_MFS_DAILY_SUBS where PPN_DT=@PPN_DT1
Insert INTO dbo.AGG_MFS_DAILY_SUBS
Select PPN_DT,CreateDate,Lst_dt_Activity,count(distinct MSISDN)Subs
      ,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTS_NM
From dbo.MFS_DAILY_SUBS with(nolock)
Where PPN_DT=@ppn_dt1 and Flag_Day='Yes'
Group by PPN_DT,CreateDate,Lst_dt_activity
        ,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTS_NM

--delete from  dbo.AGG_MFS_DAILY_ACQ where PPN_DT=@PPN_DT1
--insert INTO dbo.AGG_MFS_DAILY_ACQ
--select PPN_DT,CreateDate,Lst_dt_activity,Flag_Day,count(distinct MSISDN)Subs
--      ,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTS_NM
--from dbo.MFS_DAILY_SUBS with(nolock)
--where PPN_DT=@PPN_DT1 and CreateDate=@PPN_DT1
--group by PPN_DT,CreateDate,Lst_dt_activity,Flag_Day
--        ,STT_NM,TRRTRY_NM,PRVNC_NM,CITY_NM,BTS_NM

Delete from  dbo.AGG_MFS_DAILY_REGISTERED where PPN_DT=@PPN_DT1
Insert INTO dbo.AGG_MFS_DAILY_REGISTERED
Select left(CreateDate,7)Activa_Month,CreateDate,ppn_dt 
       ,case when STT_NM='Kanem' then 'Kanem'
		      when STT_NM='Sud' then 'Sud'
			  when STT_NM in ('Nord_Est','') then 'Nord_Est'
			  else 'NDjamena' End REGION, 
       TRRTRY_NM,PRVNC_NM,CITY_NM,BTS_NM,count(distinct msisdn)Subs
--into AGG_MFS_DAILY_REGISTERED
From  [dbo].[MFS_DAILY_SUBS] with(nolock)
      where PPN_DT=@PPN_DT1
Group by left(CreateDate,7),CreateDate,ppn_dt,
        case when STT_NM='Kanem' then 'Kanem'
		      when STT_NM='Sud' then 'Sud'
			  when STT_NM in ('Nord_Est','') then 'Nord_Est'
			  else 'NDjamena' End, 
       TRRTRY_NM,PRVNC_NM,CITY_NM,BTS_NM

 
 End
GO

/****** Object:  StoredProcedure [dbo].[STAGING_OLD_HANANA_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[STAGING_OLD_HANANA_NAC]
(
	@PPN_DT	DATE
)
as
BEGIN

Delete from dbo.OLD_HANANA where ppn_dt=@PPN_DT
Insert into dbo.OLD_HANANA
Select
	 cast(OPER_DATE as date)as [BGN_EV_DT_KEY_LKP]
	,Convert(varchar(8), (left(right(OPER_DATE,12), 8) ))as [BGN_EV_TM_LKP]
	,Rtrim(RIGHT(PRI_IDENTITY, 8)) as AR_KEY_LKP
	,Convert(varchar(50), DATENAME(WEEKDAY,(cast(OPER_DATE as date)))) as [DayOfWeek]
	,CasT(RIGHT(TIME_STAMP, 6)as varchar(6)) as [PEAK_SEG_LKP]
	,'0' STAGE_AUDIT_KEY
	,CasT(CDR_ID as varchar(50)) 'UNQ_CD_SRC_STM1'
	,CasT(TIME_STAMP as varchar(50)) 'UNQ_CD_SRC_STM2'
	,Rtrim(RIGHT(PRI_IDENTITY, 8)) as CST_KEY_LKP
	,'PREPAID' as BS_LN_KEY_LKP
	,CasT(LTRIM(Rtrim(MainOfferingID)) as varchar(20)) as PLN_KEY_LKP
	,'-2' as CTR_BILL_CYC_KEY_LKP
	,'-2' as INV_PRD_KEY_LKP				-- Invoice Period Dimension is empty so this value won't be used
	,cast(OPER_DATE as date) as FCT_DT_KEY_LKP
	,Case when OPER_TYPE =0 then 
	       (Case when (cast(LOAN_AMT as float))/100 in (150.0,200.0) then '9000'
			     when (cast(LOAN_AMT as float))/100 in (250.0,300.0) then '9005' 
				 when (cast(LOAN_AMT as float))/100 in (600.0)       then '9003'
			     when (cast(LOAN_AMT as float))/100 in (1200.0)      then '9004'
		    End) 
	 Else '0_REPAYMENT' End as PD_KEY_LKP
	,'SC-10200' as SVC_KEY_LKP
	,Case OPER_TYPE
		when 0 then 0
		when 1 then 1
		when 2 then 2
		Else '-1' End as LOAN_TP_KEY_LKP
	--,'-1' as PD_KEY_LKP
	,'NA' as CCY_KEY_LKP
	--,Case LoanMethod
	--	when 0 then 'IVR'
	--	when 1 then 'USSD'
	--	when 2 then 'SMS'
	--	when -1 then 'UNKNOWN'
	--	Else 'UNKNOWN'
	--End	
	,'-1' as ACS_CNL_KEY_LKP
	--,'-1'	as SALE_CNL_KEY_LKP
	,CasT(LOAN_AMT as numeric(18,4)) / 100 as TRX_AMT
	,LOAN_PENALTY as Late_Fee
	,CasT(LOAN_AMT as numeric(18,4)) / 100 + CasT(LOAN_PENALTY as numeric(18,4)) / 100 as DUE_AMT
	,cast(OPER_DATE as date) as FCT_DT
	,CasT(REPAY_POUNDAGE as numeric(18,4)) / 100 as BILLD_AMT
	,RIGHT(Rtrim([PRI_IDENTITY]), 8) as MSISDN_DD
	--duplicate logging (updated : 2/17/2015)
	,Reference FILE_NM
	,'Loan' SourceSystem
	,@PPN_DT as PPN_DT
	,ROW_NUMBER() OVER (PARTITION BY CDR_ID, TIME_STAMP ORDER BY PPN_DT) RN

FROM [dbo].[OCSLOAN_NUPGRD] with (nolock)
WHERE PPN_DT = @PPN_DT AND CDR_ID<>''

End

GO

/****** Object:  StoredProcedure [dbo].[STAGING_RLD_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[STAGING_RLD_NAC]
(
	@PPN_DT	DATE
)
AS
Begin
Declare @PPN_DT3 date
Set @PPN_DT3=dateadd(dd,0,cast(getdate()-3 as date))

Delete From RLD_NAC  where PPN_DT<=@PPN_DT3
Delete From RLD_NAC  where PPN_DT=@PPN_DT
Insert into RLD_NAC 
Select RIGHT(RTRIM(PRI_IDENTITY), 8) MSISDN_DD
	  ,CAST(CDR_ID AS VARCHAR(50)) UNQ_CD_SRC_STM1
	  ,format(TIME_STAMP,'yyyyMMddHHmmss')  UNQ_CD_SRC_STM2
	  ,(Case when Location IS NULL OR Location = '' then '-1'
		     else RIGHT(Location, 9)
	    End) AS [SCTR_CD_KEY_LKP]
	  ,TRY_CONVERT(VARCHAR(50), MainOfferingID) AS PLN_KEY_LKP
      ,Case when TradeType = 0		then '0_RLD'
	--when TradeType in (1,2)		then '2_RLD'
	--when TradeType in (3,4)		then '4_RLD'
	--when TradeType in (5,6)		then '6_RLD'
	--when TradeType = 7		then '7_RLD'
	--when TradeType = 999	then '999_RLD'
	--when TradeType in (1000,1007)	then '11_RLD'
            when TradeType ='1049' and CHG_AMOUNT between 1000 and 100000 then '10_1000_RLD_TC'
			when TradeType ='1049' and CHG_AMOUNT between 100001 and 500000 then '1001_5000_RLD_TC'
			when TradeType ='1049' and CHG_AMOUNT between 500001 and 1000000 then '5001_10000_RLD_TC'
			when TradeType ='1049' and CHG_AMOUNT between 1000001 and 3000000 then '10001_30000_RLD_TC'
			when TradeType ='1049' and CHG_AMOUNT > 3000000 then '30001_RLD_TC'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 100 then '100_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 250 then '250_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 500 then '500_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 750 then '750_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 1000 then '1000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 1250 then '1250_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 1500 then '1500_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 1750 then '1750_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 2000 then '2000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 5000 then '5000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 10000 then '10000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 30000 then '30000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 50000 then '50000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 100000 then '100000_RLD_EP'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 100 then '100_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 250 then '250_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 500 then '500_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 750 then '750_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 1000 then '1000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 1250 then '1250_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 1500 then '1500_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 1750 then '1750_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 2000 then '2000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 5000 then '5000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 10000 then '10000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) = 30000 then '30000_RLD'
	        else 'Airtime Recharge'--Default PD_NM
	   End AS PD_KEY_LKP
	  ,COALESCE(CARD_SEQUENCE, 'N/A') AS SRL_NBR_DD
	  ,COALESCE(CARD_BATCH_NO, 'N/A') AS BTCH_NBR_DD
	  ,(Case when ACCESS_METHOD = 0 then 'IVR'
	         when ACCESS_METHOD = 1 then 'USSD'
			 when ACCESS_METHOD = 2 then 'SMS'
			 when ACCESS_METHOD = 3 then 'WebService'
			 when ACCESS_METHOD = 4 then 'GUI'
			 when ACCESS_METHOD = 5 then 'Task'
			 when ACCESS_METHOD = 6 then 'Automatic'
			 when ACCESS_METHOD = 7 then 'Reserved'
			 --when ACCESS_METHOD = 9 then 'ECare'
			 when ACCESS_METHOD = 999 then 'EVC'
			 --when ACCESS_METHOD = 11 then 'IPCC USSD'
			 --when ACCESS_METHOD = 12 then 'IPCC SMS'
			 --when ACCESS_METHOD = 13 then 'Promotional Recharge'
			 --when ACCESS_METHOD = 99 then 'Others'
			 --when ACCESS_METHOD IS NULL then 'Unknown'
			 else 'Unknown'
        End) ACS_CNL_KEY_LKP
	  ,COALESCE(CAST(CHG_AMOUNT AS MONEY)/100 , 0) AS RLD_VAL
	  ,REFERENCE
	  ,PPN_DT
	  ,ROW_NUMBER() OVER (PARTITION BY CDR_ID, Time_Stamp ORDER BY PPN_DT) RN

From dbo.OCSVOU_NUPGRD  with (nolock)
WHERE PPN_DT = @PPN_DT 
AND TradeTime IS NOT NULL and TradeType <> 1007

Delete From dbo.AGG_RLD where PPN_DT = @PPN_DT 
Insert into dbo.AGG_RLD
select PPN_DT,ACS_CNL_KEY_LKP,PD_KEY_LKP,count(1)Nbre,count(distinct MSISDN_DD)Subs,sum(RLD_VAL)RLD_VAL
From RLD_NAC with(nolock)
where PPN_DT = @PPN_DT 
Group by PPN_DT,ACS_CNL_KEY_LKP,PD_KEY_LKP


Delete From dbo.AGG_RLD_DTL where PPN_DT = @PPN_DT 
Insert into dbo.AGG_RLD_DTL
select PPN_DT,right(MSISDN_DD,8)MSISDN_DD,sum(RLD_VAL)RLD_VAL
From RLD_NAC with(nolock)
where PPN_DT = @PPN_DT 
Group by PPN_DT,MSISDN_DD

End

GO

/****** Object:  StoredProcedure [dbo].[STAGING_TSS_TTL_CVM_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[STAGING_TSS_TTL_CVM_NAC]
(
	@Ppn_dt	DATE
)
AS
BEGIN

Select Ppn_dt,MSISDN_DD,Billt_Amnt,Rld_Val into #Temp from AnalyticsStaging.dbo.TSS_TTL_Outgoing_Rev with(nolock) where Ppn_dt=@Ppn_dt

-- Select * From #Temp

Alter table #Temp add Rev_Data float
Alter table #Temp add Traffic_Data float
Alter table #Temp add Rev_Voice float
Alter table #Temp add TTL_Min_Outgoing float
Alter table #Temp add Rev_Voice_IncXnet float
Alter table #Temp add Min_Voice_IncXnet float
Alter table #Temp add SubCosID nvarchar(20)
Alter table #Temp add Rev_Voice_IDD float
Alter table #Temp add Min_Voice_IDD float
Alter table #Temp add Rev_TSS float

/*Update a set Traffic_Data=b.Traffic
From #Temp a
left outer join
(Select  Ppn_dt,MSISDN_DD,traffic
From dbo.AGG_DATA_USER with(nolock)
where Ppn_dt=@Ppn_dt)b
on a.MSISDN_DD=b.MSISDN_DD
and a.Ppn_dt=b.Ppn_dt
where b.MSISDN_DD is not null */


Select Ppn_dt Ppndt,MSISDN_DD Msisdndd,sum(traffic)Traffic, sum(Billt_Amnt)BilldAmnt into #t
From dbo.AGG_DATA_USER with(nolock) where Ppn_dt=@Ppn_dt and MSISDN_DD is not null and Billt_Amnt>0 group by Ppn_dt,MSISDN_DD

Insert into #t
Select fct_dt,MSISDN_DD,0, BilldAmnt From dbo.AGGR_VAS_SOUSCRIPTION with(nolock) where fct_dt=@Ppn_dt and BilldAmnt>0 and PD_ALT_CODE_1 in ('KATTIR GPRS','TSS')

Update #temp set Rev_Data=BilldAmnt,Traffic_Data=traffic
From(Select ppndt,Msisdndd,sum(traffic)traffic, sum(BilldAmnt)BilldAmnt from #t group by ppndt,Msisdndd)x
where Ppn_dt=PPNDT and MSISDN_DD=Msisdndd
Drop table #t
/*
Update #Temp  set Traffic_Data=b.Traffic
From (Select  Ppn_dt ppndt,MSISDN_DD Msisdndd,traffic From dbo.AGG_DATA_USER with(nolock) where Ppn_dt=@Ppn_dt and MSISDN_DD is not null )b
where MSISDN_DD=Msisdndd and Ppn_dt=ppndt


Update a set Rev_Data=b.Billt_Amnt
From #Temp a
left outer join
(Select x.Ppn_dt,x.MSISDN_DD,sum(x.Billt_Amnt)Billt_Amnt 
From (Select  Ppn_dt,MSISDN_DD,Billt_Amnt
From dbo.AGG_DATA_USER with(nolock)
where Ppn_dt=@Ppn_dt
union all
Select fct_dt,MSISDN_DD,BilldAmnt
From dbo.AGGR_VAS_SOUSCRIPTION with(nolock)
where fct_dt=@Ppn_dt and PD_ALT_CODE_1 in ('KATTIR GPRS','TSS'))x
group by x.Ppn_dt,x.MSISDN_DD)b
on a.MSISDN_DD=b.MSISDN_DD
and a.Ppn_dt=b.Ppn_dt
where b.MSISDN_DD is not null
*/

Select Fct_dt,right(CallingPartyNumber,8)Msisdn,Billd_Amnt,CallDuration into #tx from dbo.STAGING_Daily_Outgoing with(nolock) where fct_dt=@Ppn_dt and right(CallingPartyNumber,8) is not null
Update #Temp set Rev_Voice=Billd_Amnt,TTL_Min_Outgoing=CallDuration From  #tx where MSISDN_DD=Msisdn and Ppn_dt=Fct_dt
Drop table #tx

Select Fct_dt,Msisdn,Rev_IncXnet,CallDuration into #ty From dbo.STAGING_Daily_IncomingXnet with(nolock) where Msisdn is not null and  fct_dt=@Ppn_dt
Update #Temp set Rev_Voice_IncXnet=Rev_IncXnet,Min_Voice_IncXnet=CallDuration from #ty where MSISDN_DD=Msisdn and Ppn_dt=Fct_dt
Drop table #ty

Select SUB_IDENTITY,PRIMARY_OFFERING SUBCOSIDs into #tz from dbo.OCS_CBS_SUBSCRIBER_BO_ALL  with(nolock) where Ppn_dt=@Ppn_dt and STATUS='2' and SUB_IDENTITY is not null
Update #Temp set SubCosID=SUBCOSIDs from #tz where MSISDN_DD=SUB_IDENTITY
Drop table #tz 

Select Date,right(Bparty,8)Msisdn,sum(mins)mins,sum(mins)*186.15 Rev_IDD into #tw from  [192.168.50.148].[AnalyticsReporting].[dbo].[IDD_From_HCDB] with(nolock) where date=@Ppn_dt and right(Bparty,8) is not null group by date,Bparty
Update #Temp set Rev_Voice_IDD=Rev_IDD,Min_Voice_IDD=mins From  #tw where MSISDN_DD=Msisdn and Ppn_dt=date 
Drop table #tw

Select Date,right(MSISDN_DEST,8)Msisdn,sum(REVENUE)REVENUE into #tp from  [192.168.50.148].[AnalyticsReporting].[dbo].[TSS_CDR_DUMP] with(nolock) where Date=@Ppn_dt and STATUS ='Operation succeeded.' and MARKETING_PLAN='EVC_SUBSCRIPTION' and Msisdn is not null group by date,right(MSISDN_DEST,8)
Update #Temp set Rev_TSS=REVENUE From #tp where MSISDN_DD=Msisdn and Ppn_dt=date
Drop table #tp

Delete from dbo.TSS_TTL_CVM  where Ppn_dt=@Ppn_dt
Insert into dbo.TSS_TTL_CVM 
Select Ppn_dt,MSISDN_DD,SubCosID,isnull(Billt_Amnt,0)TTL_Outgoing_Rev,isnull(Rld_Val,0)Reload
      ,isnull(Rev_Data,0)TTL_Rev_Data,isnull(Rev_TSS,0)Rev_TSS,isnull(Traffic_Data,0)Traffic_Data
	  ,isnull(Rev_Voice,0)Rev_Voice,isnull(TTL_Min_Outgoing,0)TTL_Min_Outgoing
	  ,isnull(Rev_Voice_IncXnet,0)Rev_Voice_IncXnet,isnull(Min_Voice_IncXnet,0)Min_Voice_IncXnet
	  ,isnull(Rev_Voice_IDD,0)Rev_Voice_IDD,isnull(Min_Voice_IDD,0)Min_Voice_IDD
From #Temp

Drop table #Temp
End
GO

/****** Object:  StoredProcedure [dbo].[STAGING_TTL_OUTGOING_REV_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[STAGING_TTL_OUTGOING_REV_NAC]
(
	@Ppn_dt	DATE
)
AS
Begin

Delete From TTL_Outgoing_Rev Where Ppn_dt=@Ppn_dt
Insert into TTL_Outgoing_Rev
------------------------------------- VOICE OUTGOING ------------------------------

Select Ppn_dt,Msisdn_dd,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4
						   +CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9
						   +CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)Billt_Amnt
From VOICE_JOUR_NAC with(nolock)
Where Ppn_dt=@Ppn_dt
Group by Ppn_dt,Msisdn_dd


Insert into TTL_Outgoing_Rev
------------------------------------- DATA ON DEMand ------------------------------
Select Ppn_dt,Msisdn_dd,Billt_Amnt 
From AGG_DATA_USER with(nolock)
Where Ppn_dt=@Ppn_dt and Billt_Amnt>0

Insert into TTL_Outgoing_Rev
------------------------------------- EXPIRED REVENUE -----------------------------------
Select Ppn_dt,Msisdn_dd,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4
						   +CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9
						   +CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)Expired
From EXPIRED_REV_NAC a with(nolock)
Where Ppn_dt=@Ppn_dt
Group by Ppn_dt,Msisdn_dd

Insert into TTL_Outgoing_Rev
--------------------------------------- VAS SERVICE --------------------------------------
Select Ppn_dt,Msisdn_dd,sum(CHARGE_FROM_ACCOUNT)ChargeFromPrepaid
From VAS_SMS_SOUSCRIPTION_NAC a with(nolock)
Where Ppn_dt=@Ppn_dt and CHARGE_FROM_ACCOUNT>0
Group by Ppn_dt,Msisdn_dd

Insert into TTL_Outgoing_Rev
--------------------------------------- VAS PURCHASE --------------------------------------
Select FCT_DT,Msisdn_dd,sum(BilldAmnt)BilldAmnt
From AGGR_VAS_SOUSCRIPTION a with(nolock)
Where FCT_DT=@Ppn_dt and BilldAmnt>0  
	  and PD_ALT_CODE_1 in ('B2B','ENTERTAINMENT','KATTIR BUNDLES','KATTIR GPRS','KATTIR IDD','KATTIR SMS','RBT','TSS','ZIADA')
Group by FCT_DT,Msisdn_dd

/*
Insert into TTL_Outgoing_Rev
--------------------------------------- VAS PURCHASE --------------------------------------
Select FCT_DT,Msisdn_dd,sum(BilldAmnt)*0.014182528 BilldAmnt
From AGGR_VAS_SOUSCRIPTION a with(nolock)
Where FCT_DT=@Ppn_dt and PD_ALT_CODE_1='P2P TRANSFER'
Group by FCT_DT,Msisdn_dd
*/

Insert into TTL_Outgoing_Rev
--------------------------------------- HANANA_REPAYMENT --------------------------------------
Select Ppn_dt,msisdn,sum(Repayment)  BilldAmnt
From CVAS_HANANA_REPAYMENT a with(nolock)
Where Ppn_dt=@Ppn_dt and Repayment>0
Group by Ppn_dt,msisdn


Insert into TTL_Outgoing_Rev
--------------------------------------- HANANA_AIRTIME --------------------------------------
Select Ppn_dt,ChargingPartyNumber,sum(Hanana_Kattir_With_Tax)  BilldAmnt
From CVAS_HANANA_KATTIR a with(nolock)
Where Ppn_dt=@Ppn_dt and Hanana_Kattir_With_Tax>0
Group by Ppn_dt,ChargingPartyNumber


Insert into TTL_Outgoing_Rev
--------------------------------------- DATA_AIRTIME --------------------------------------
Select Ppn_dt,ChargingPartyNumber,sum(DATA_AirTime)  BilldAmnt
From CVAS_HANANA_DATA_AIRTIME a with(nolock)
Where Ppn_dt=@Ppn_dt and DATA_AirTime>0
Group by Ppn_dt,ChargingPartyNumber

/*
Insert into TTL_Outgoing_Rev
---------------------------------------MGR_AIRTIME --------------------------------------
Select Ppn_dt,ChargingPartyNumber,sum(Sousc_MGR_AirTime)  BilldAmnt
From [CVAS_HANANA_MGR_AIRTIME_NEW] a with(nolock)
Where Ppn_dt=@Ppn_dt
Group by Ppn_dt,ChargingPartyNumber
*/

Insert into TTL_Outgoing_Rev
---------------------------------------MON_AIRTIME --------------------------------------
Select Ppn_dt,ChargingPartyNumber,sum(Sousc_MON_AirTime)  BilldAmnt
From CVAS_HANANA_MON_AIRTIME a with(nolock)
Where Ppn_dt=@Ppn_dt and Sousc_MON_AirTime>0
Group by Ppn_dt,ChargingPartyNumber


Insert into TTL_Outgoing_Rev
--------------------------------------SMS_AIRTIME --------------------------------------
Select Ppn_dt,CallingPartyNumber,sum(SMS_AirTime_Without_Tax)  BilldAmnt
From CVAS_HANANA_SMS_AIRTIME a with(nolock)
Where Ppn_dt=@Ppn_dt and SMS_AirTime_Without_Tax>0
Group by Ppn_dt,CallingPartyNumber


Insert into TTL_Outgoing_Rev
--------------------------------------VOICE_AIRTIME --------------------------------------
Select Ppn_dt,CallingPartyNumber,sum(Voice_AirTime_Without_Tax)  BilldAmnt
From CVAS_HANANA_VOICE_AIRTIME a with(nolock)
Where Ppn_dt=@Ppn_dt and Voice_AirTime_Without_Tax>0
Group by Ppn_dt,CallingPartyNumber

----------------------------------------- AGGREGATION ------------------------------------
Delete from dbo.TTL_Outgoing_Rev where Ppn_dt=@Ppn_dt and Billt_Amnt=0
Delete from dbo.AGGR_TTL_Outgoing_Rev where Ppn_dt=@Ppn_dt
Insert into dbo.AGGR_TTL_Outgoing_Rev
Select Ppn_dt,right(Msisdn_dd,8)Msisdn_dd,sum(Billt_Amnt)Billt_Amnt
From TTL_Outgoing_Rev with(nolock)
Where Ppn_dt=@Ppn_dt
Group by Ppn_dt,Msisdn_dd

Delete from dbo.TSS_TTL_Outgoing_Rev where Ppn_dt=@Ppn_dt
Insert into dbo.TSS_TTL_Outgoing_Rev
Select Ppn_dt,Msisdn_dd,sum(Billt_Amnt)Billt_Amnt,0 Rld_Val
From dbo.AGGR_TTL_Outgoing_Rev with(nolock)
Where Ppn_dt=@Ppn_dt
Group by Ppn_dt,Msisdn_dd
/*
Select Ppn_dt ppndt ,Msisdn_dd Msisdndd,sum(RLD_VAL)RLDVAL into #Rld from AGG_RLD_DTL with(nolock) where Ppn_dt =@Ppn_dt and RLD_VAL>0  group by Ppn_dt,Msisdn_dd

Update a set Rld_Val=b.RLDVAL
from dbo.TSS_TTL_Outgoing_Rev a 
left outer join #Rld b on a.Msisdn_dd=b.Msisdndd--a.Ppn_dt=b.Ppndt and 
where a.Ppn_dt=@Ppn_dt

Update dbo.TSS_TTL_Outgoing_Rev set Rld_Val=0 where Ppn_dt=@Ppn_dt and Rld_Val is null
Drop table #rld
*/

End



GO

/****** Object:  StoredProcedure [dbo].[STAGING_VAS_MGR_SOUSCRIPTION_NAC]    Script Date: 8/23/2021 12:05:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[STAGING_VAS_MGR_SOUSCRIPTION_NAC]
(
	@PPN_DT	DATE
)
As

Begin
Declare @PPN_DT3 date
Set @PPN_DT3=dateadd(dd,0,cast(getdate()-3 as date))
Select * into #mgr from OCSMGR_NUPGRD where PPN_DT=@PPN_DT --and RESULT_CODE='0'

Delete From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC Where PPN_DT<=@PPN_DT3
Delete From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC Where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC
Select Convert(VARCHAR(50),MainOfferingID) as PLN_KEY_LKP																											
	  ,Case when Oper_ID ='322' and AdditionalInfo like 'u2opia%' and CHARGE_FROM_ACCOUNT in (2500,13000,31500) then 'MOOV FOOT'
		    when AdditionalInfo ='A1000XDEXCharging' and EXT_TRANS_ID like 'DE_191%' then 'HOURLY BUNDLES'
			when AdditionalInfo ='A1000XDEXCharging' and EXT_TRANS_ID like 'DE_146%' then 'MBB'
			when AdditionalInfo ='A1000XLive_mw_TigoLoveXCharging' and CHARGE_FROM_ACCOUNT != 0 then 'MOOVLOVE'
			when AdditionalInfo like 'MoovRede%' then 'MOOVLOVE'
			when AdditionalInfo like 'MOBILE_RADIO%'  then 'MOBILE RADIO'
			when AdditionalInfo like 'IS_PORTAL%' then 'DINIYAT PORTAL'
		    when AdditionalInfo like 'Hosana%' then 'HOSANA'
		    when AdditionalInfo ='A1000XTIGO_QUIZXCharging' then 'MOOV QUIZZ'--Dans SMS
		    when Oper_ID ='322' and AdditionalInfo like 'u2opia_sms_fun%' then 'SMS FUN'
		    when Oper_ID ='365' and EXT_TRANS_ID like 'MAGIC%' then 'MAGIC VOICE'
			when Oper_ID ='365' and EXT_TRANS_ID like 'LEARN%' then 'LEARN ENGLISH'
		    when Oper_ID ='332' and OBJECT_TYPE_ID=2532 and OPER_TYPE ='2' and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'CVAS_LOAN SOUSCRIPTION'
		    when Oper_ID ='332' and OBJECT_TYPE_ID=2000   and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'CVAS_LOAN REPAYMENT'
		    when Oper_ID ='332' then 'CVAS_LOAN OPERATION'
		    --when OperationID ='4052100'  and Oper_ID ='411' and OperationType='999' and left(EXT_TRANS_ID,10)!=  'TSS_REFUND' then 'CC_TSS'
		    when Oper_ID ='325'  and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'T&T TargetedSales'
		    --when OperationID ='4052100' and left(AdditionalInfo,3)not in ('tag','tig')   and left(EXT_TRANS_ID,10)!=  'TSS_REFUND' and Oper_ID ='PRAYER_TargetedSaleSys' then 'PRIERE RAMADAN'
		    when Oper_ID ='383' and EXT_TRANS_ID like 'HYBRID_%'  and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'HYBRID MIDDLEWARE'
		    when OperationID ='4052101'  and OBJECT_TYPE_ID=2000 then 'P2P TRANSFER'
		    --when Oper_ID in ('330','340') then 'RBT'
			when AdditionalInfo like '%RBT%' then 'RBT'
		    when Oper_ID ='10310' and OPER_TYPE=2 then 'BATCH ADJUST BALANCE'
		    when OperationID ='4052100' and Oper_ID not in ('325','332','411','10428','383','330','340','10367','325') then 'ADJUST BALANCE'
            else Convert(VARCHAR(50),NewOfferingID)
	   End PD_KEY_LKP
	  ,Cast(CDR_ID as VARCHAR(50)) UNQ_CD_SRC_STM1
	  ,format(TIME_STAMP,'yyyyMMddHHmmss') UNQ_CD_SRC_STM2
	  ,'SC-10203' SVC_KEY
	  ,Case when OBJECT_TYPE_ID   =2000 then Cast(CHG_AMOUNT  as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT
	  ,Case when OBJECT_TYPE_ID1  =2000 then Cast(CHG_AMOUNT1 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT1
	  ,Case when OBJECT_TYPE_ID2  =2000 then Cast(CHG_AMOUNT2 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT2
	  ,Case when OBJECT_TYPE_ID3  =2000 then Cast(CHG_AMOUNT3 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT3
	  ,Case when OBJECT_TYPE_ID4  =2000 then Cast(CHG_AMOUNT4 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT4
	  ,Case when OBJECT_TYPE_ID5  =2000 then Cast(CHG_AMOUNT5 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT5
	  ,Case when OBJECT_TYPE_ID6  =2000 then Cast(CHG_AMOUNT6 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT6
	  ,Case when OBJECT_TYPE_ID7  =2000 then Cast(CHG_AMOUNT7 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT7
	  ,Case when OBJECT_TYPE_ID8  =2000 then Cast(CHG_AMOUNT8 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT8
	  ,Case when OBJECT_TYPE_ID9  =2000 then Cast(CHG_AMOUNT9 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT9
	  ,Case when OBJECT_TYPE_ID10 =2000 then Cast(CHG_AMOUNT10 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT10
	  ,Case when OBJECT_TYPE_ID11 =2000 then Cast(CHG_AMOUNT11 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT11
	  ,Case when OBJECT_TYPE_ID12 =2000 then Cast(CHG_AMOUNT12 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT12
	  ,Case when OBJECT_TYPE_ID13 =2000 then Cast(CHG_AMOUNT13 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT13
	  ,Case when OBJECT_TYPE_ID14 =2000 then Cast(CHG_AMOUNT14 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT14
	  ,CHARGE_FROM_ACCOUNT/100  CHARGE_FROM_ACCOUNT
	  ,RIGHT(RTRIM(PRI_IDENTITY), 8) ORIG_NMB_DD
	  ,RIGHT(RTRIM(PRI_IDENTITY), 8) MSISDN_DD
	  ,REFERENCE
	  ,PPN_DT
	  ,ROW_NUMBER() OVER (PARTITION BY CDR_ID, TIME_STAMP ORDER BY PPN_DT) RN

From  #mgr--AnalyticsStaging.dbo.OCSMGR_NUPGRD with (nolock) Where PPN_DT = @PPN_DT and RESULT_CODE='0'--and (NewOfferingID <> 0 or OperationID <> 0)
Drop table #mgr

Delete From AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION Where FCT_DT = @PPN_DT
Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select PPN_DT,MSISDN_DD,b.PD_ALT_CODE_1,b.PD_TP_NM
	  ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)BilldAmnt

From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC a with(nolock)
left outer join [192.168.50.148\ANALYTICS].[AnalyticsCHAD].[dbo].[PD_DIM] b on PD_KEY_LKP=b.UNQ_CD_SRC_STM
Where PPN_DT = @PPN_DT and a.PD_KEY_LKP not in('ADJUST BALANCE','BATCH ADJUST BALANCE','CC_TSS','LEARN ENGLISH',
											   'CVAS_LOAN REPAYMENT','CVAS_LOAN SOUSCRIPTION','CVAS_LOAN OPERATION',
											   'DINIYAT PORTAL','HOSANA','HOURLY BUNDLES','HYBRID MIDDLEWARE',
											   'MAGIC VOICE','MBB','MOBILE RADIO','P2P TRANSFER','RBT','SMS FUN',
											   'T&T TargetedSales','MOOV FOOT','MOOV QUIZZ','MOOVLOVE') 
Group by PPN_DT,MSISDN_DD,b.PD_ALT_CODE_1,b.PD_TP_NM

---------------------------------------Souscription via MOOV MONEY avec les nouveaux dump de MFS------------------------

--Delete From AGGR_VAS_MGR_SOUSCRIPTION Where FCT_DT = @PPN_DT
Select PPN_DT [FCT_DT],right(PRI_IDENTITY,8)MSISDN_DD,OfferingID,CHG_AMOUNT,RECIPIENT_NUMBER into #t
From AnalyticsStaging.dbo.OCSMON_NUPGRD (nolock) Where PPN_DT=@PPN_DT--and PRI_IDENTITY ='92396343'

Select PPN_DT,REFERENCEID,SUM(Cast(AMOUNT as float))/100 AMOUNT,substring(EXTENDEDDATA,4,8)EXTENDEDDATA,b.PD_TP_NM,b.PD_ALT_CODE_1 into #ttrans
From [AnalyticsStaging].[dbo].TRANSACTIONS_TC_UPGRD (nolock) a, [192.168.50.148\ANALYTICS].[AnalyticsCHAD].[dbo].[PD_DIM] b
Where substring(a.REMARKS,10,6)=b.UNQ_CD_SRC_STM and ppn_dt=@PPN_DT and STATUS=0 --and FRMSISDN='23591585104'
Group by PPN_DT,REFERENCEID,EXTENDEDDATA,PD_NM,PD_TP_NM,b.PD_ALT_CODE_1

Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select FCT_DT,MSISDN_DD,b.PD_ALT_CODE_1,b.PD_TP_NM,AMOUNT BilldAmnt
From #t a, #ttrans (nolock) b
Where a.RECIPIENT_NUMBER=b.REFERENCEID

Drop table #t
Drop table #ttrans
--------------------------------------------------Fin--------------------------------

Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select PPN_DT,MSISDN_DD,'ADJUST BALANCE'PD_ALT_CODE_1,PD_KEY_LKP PD_TP_NM
	  ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)BilldAmnt
From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC a with(nolock)
Where PPN_DT = @PPN_DT and a.PD_KEY_LKP in('ADJUST BALANCE','BATCH ADJUST BALANCE') 
Group by PPN_DT,MSISDN_DD,PD_KEY_LKP

Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select PPN_DT,MSISDN_DD,'CVAS_LOAN' PD_ALT_CODE_1,PD_KEY_LKP PD_TP_NM
	  ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)BilldAmnt
From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC a with(nolock)
Where PPN_DT = @PPN_DT and  a.PD_KEY_LKP in('CVAS_LOAN REPAYMENT','CVAS_LOAN SOUSCRIPTION','CVAS_LOAN OPERATION') 
Group by PPN_DT,MSISDN_DD,PD_KEY_LKP

Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select PPN_DT,MSISDN_DD,'KATTIR GPRS'PD_ALT_CODE_1,PD_KEY_LKP PD_TP_NM
	  ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)BilldAmnt
From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC a with(nolock)
Where PPN_DT = @PPN_DT and  a.PD_KEY_LKP in('HOURLY BUNDLES','MBB') 
Group by PPN_DT,MSISDN_DD,PD_KEY_LKP
/*
Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select x.PPN_DT,x.MSISDN_DD,x.PD_ALT_CODE_1,x.PD_TP_NM,sum(x.CHARGE_FROM_ACCOUNT)BilldAmnt
From (Select  PPN_DT,MSISDN_DD,'P2P TRANSFER' PD_ALT_CODE_1,PD_KEY_LKP PD_TP_NM
			 ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)BilldAmnt
			 ,Case when CHARGE_FROM_ACCOUNT<=0 then 'Envois'
		           else 'Reception'
			  End Transaction_Type
			 ,sum(CHARGE_FROM_ACCOUNT)CHARGE_FROM_ACCOUNT
	  From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC a with(nolock)
	  Where PPN_DT = @PPN_DT and  a.PD_KEY_LKP in('P2P TRANSFER') 
      group by PPN_DT,PD_KEY_LKP,MSISDN_DD
		     ,Case when CHARGE_FROM_ACCOUNT<=0 then 'Envois'
				   else 'Reception' 
		      End)x
Where x.Transaction_Type in ('Envois','Reception')
Group by x.PPN_DT,x.MSISDN_DD,x.PD_ALT_CODE_1,x.PD_TP_NM
*/
Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select PPN_DT,MSISDN_DD,'ENTERTAINMENT'PD_ALT_CODE_1,PD_KEY_LKP PD_TP_NM
	  ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)BilldAmnt
From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC a with(nolock)
Where PPN_DT = @PPN_DT and  a.PD_KEY_LKP in('DINIYAT PORTAL','HOSANA','MAGIC VOICE','MOBILE RADIO','SMS FUN','MOOV FOOT','MOOV QUIZZ','MOOVLOVE','LEARN ENGLISH') 
Group by PPN_DT,MSISDN_DD,PD_KEY_LKP

Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select PPN_DT,MSISDN_DD,'TSS'PD_ALT_CODE_1,PD_KEY_LKP PD_TP_NM,sum(CHARGE_FROM_ACCOUNT)BilldAmnt
From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC a with(nolock)
Where  PPN_DT = @PPN_DT and a.PD_KEY_LKP in('CC_TSS','T&T TargetedSales') 
Group by PPN_DT,MSISDN_DD,PD_KEY_LKP

Insert into AnalyticsStaging.dbo.AGGR_VAS_MGR_SOUSCRIPTION
Select PPN_DT,MSISDN_DD,'RBT'PD_ALT_CODE_1,PD_KEY_LKP PD_TP_NM
	  ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4+CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7+CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)BilldAmnt
From AnalyticsStaging.dbo.VAS_MGR_SOUSCRIPTION_NAC a with(nolock)
Where PPN_DT = @PPN_DT and  a.PD_KEY_LKP in('RBT') 
Group by PPN_DT,MSISDN_DD,PD_KEY_LKP

Delete From AnalyticsStaging.dbo.AGGR_VAS_SOUSCRIPTION Where FCT_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.AGGR_VAS_SOUSCRIPTION
Select * from AGGR_VAS_MGR_SOUSCRIPTION
Where FCT_DT=@PPN_DT --and BilldAmnt>0.00000000

Insert into AnalyticsStaging.dbo.AGGR_VAS_SOUSCRIPTION
Select * from AnalyticsStaging.dbo.AGG_VAS_MON_SOUSCRIPTION
Where FCT_DT=@PPN_DT

Delete From AnalyticsStaging.dbo.AGGR_VIEW_VAS_SOUSCRIPTION Where fct_dt=@PPN_DT
Insert into AnalyticsStaging.dbo.AGGR_VIEW_VAS_SOUSCRIPTION
Select left(FCT_DT,7)Month,FCT_DT,PD_ALT_CODE_1,PD_TP_NM,count(distinct MSISDN_DD)Subs,sum(BilldAmnt)Bill_Amnt
       ,(sum(BilldAmnt)-sum(BilldAmnt)*0.129)Bill_Amnt_Without_Tax
From  AnalyticsStaging.dbo.AGGR_VAS_SOUSCRIPTION with(nolock) Where fct_dt=@PPN_DT
Group by left(FCT_DT,7), FCT_DT,PD_ALT_CODE_1,PD_TP_NM


End

GO

/****** Object:  StoredProcedure [dbo].[STAGING_VAS_MON_SOUSCRIPTION_NAC]    Script Date: 8/23/2021 12:05:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[STAGING_VAS_MON_SOUSCRIPTION_NAC]
(
	@PPN_DT	DATE
)
AS
Begin
Declare @PPN_DT3 date
Set @PPN_DT3=dateadd(dd,0,cast(getdate()-3 as date))

Delete from AnalyticsStaging.dbo.VAS_MON_SOUSCRIPTION_NAC where PPN_DT<=@PPN_DT3
Delete from AnalyticsStaging.dbo.VAS_MON_SOUSCRIPTION_NAC where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.VAS_MON_SOUSCRIPTION_NAC
Select 
	  Convert(VARCHAR(50),MainOfferingID) PLN_KEY_LKP
	 ,OfferingID AS PD_KEY_LKP
	 ,Cast(CDR_ID AS VARCHAR(50)) UNQ_CD_SRC_STM1
	 ,format(TIME_STAMP,'yyyyMMddHHmmss') UNQ_CD_SRC_STM2
	 ,Cast(CHARGE_FROM_ACCOUNT as numeric(18, 0)) / 100 AS BILL_AMT
	 ,Case when OBJECT_TYPE_ID   = 2000 then Cast(CHG_AMOUNT  as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT
	 ,Case when OBJECT_TYPE_ID1  = 2000 then Cast(CHG_AMOUNT1 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT1
	 ,Case when OBJECT_TYPE_ID2  = 2000 then Cast(CHG_AMOUNT2 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT2
	 ,Case when OBJECT_TYPE_ID3  = 2000 then Cast(CHG_AMOUNT3 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT3
	 ,Case when OBJECT_TYPE_ID4  = 2000 then Cast(CHG_AMOUNT4 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT4
	 ,Case when OBJECT_TYPE_ID5  = 2000 then Cast(CHG_AMOUNT5 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT5
	 ,Case when OBJECT_TYPE_ID6  = 2000 then Cast(CHG_AMOUNT6 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT6
	 ,Case when OBJECT_TYPE_ID7  = 2000 then Cast(CHG_AMOUNT7 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT7
	 ,Case when OBJECT_TYPE_ID8  = 2000 then Cast(CHG_AMOUNT8 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT8
	 ,Case when OBJECT_TYPE_ID9  = 2000 then Cast(CHG_AMOUNT9 as numeric(18,4)) / 100 else 0 end as CHG_AMOUNT9
	 ,Case when OBJECT_TYPE_ID10 = 2000 then cast(CHG_AMOUNT10 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT10
	 ,Case when OBJECT_TYPE_ID11 = 2000 then cast(CHG_AMOUNT11 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT11
	 ,Case when OBJECT_TYPE_ID12 = 2000 then cast(CHG_AMOUNT12 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT12
	 ,Case when OBJECT_TYPE_ID13 = 2000 then cast(CHG_AMOUNT13 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT13
	 ,Case when OBJECT_TYPE_ID14 = 2000 then cast(CHG_AMOUNT14 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT14
	 ,RIGHT(RTRIM(PRI_IDENTITY), 8) ORIG_NMB_DD
	 ,RIGHT(RTRIM(PRI_IDENTITY), 8) MSISDN_DD
	 ,REFERENCE
	 ,PPN_DT
	 ,ROW_NUMBER() OVER (PARTITION BY CDR_ID, TIME_STAMP ORDER BY PPN_DT) RN

FROM AnalyticsStaging.dbo.OCSMON_NUPGRD with (nolock) WHERE PPN_DT = @PPN_DT 

Delete from AnalyticsStaging.dbo.AGG_VAS_MON_SOUSCRIPTION where FCT_DT = @PPN_DT 
Insert into AnalyticsStaging.dbo.AGG_VAS_MON_SOUSCRIPTION
Select PPN_DT,a.MSISDN_DD,PD_ALT_CODE_1,PD_TP_NM,sum(BILL_AMT)BILL_AMT
From AnalyticsStaging.dbo.VAS_MON_SOUSCRIPTION_NAC a with(nolock)
left outer join [192.168.50.148\ANALYTICS].[AnalyticsCHAD].[dbo].[PD_DIM] b on Convert(VARCHAR(50), a.PD_KEY_LKP)=b.UNQ_CD_SRC_STM
Where PPN_DT = @PPN_DT and BILL_AMT>0.000000
Group by PPN_DT,a.MSISDN_DD,PD_ALT_CODE_1,PD_TP_NM

End

GO

/****** Object:  StoredProcedure [dbo].[STAGING_VAS_SMS_SOUSCRIPTION_NAC]    Script Date: 8/23/2021 12:05:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[STAGING_VAS_SMS_SOUSCRIPTION_NAC]
(
	@PPN_DT	DATE
)
AS

Begin

Declare @PPN_DT3 date
Set @PPN_DT3=dateadd(dd,0,cast(getdate()-3 as date))

Select CDR_ID,CUST_LOCAL_START_DATE,ServiceFlow,OnNetIndicator,RoamState,CallingPartyNumber,CalledPartyNumber,CallingCellID,CalledCellID,PRI_IDENTITY,DEBIT_FROM_PREPAID,CHARGE_FROM_ACCOUNT,TOTAL_TAX,PPN_DT,
OBJECT_TYPE_ID,OBJECT_TYPE_ID1,OBJECT_TYPE_ID2,OBJECT_TYPE_ID3,OBJECT_TYPE_ID4,OBJECT_TYPE_ID5,OBJECT_TYPE_ID6,OBJECT_TYPE_ID7,OBJECT_TYPE_ID8,OBJECT_TYPE_ID9,OBJECT_TYPE_ID10,OBJECT_TYPE_ID11,OBJECT_TYPE_ID12,OBJECT_TYPE_ID13,OBJECT_TYPE_ID14,
CHG_AMOUNT,CHG_AMOUNT1,CHG_AMOUNT2,CHG_AMOUNT3,CHG_AMOUNT4,CHG_AMOUNT5,CHG_AMOUNT6,CHG_AMOUNT7,CHG_AMOUNT8,CHG_AMOUNT9,CHG_AMOUNT10,CHG_AMOUNT11,CHG_AMOUNT12,CHG_AMOUNT13,CHG_AMOUNT14 into #tsms
from [dbo].[OCSSMS_NUPGRD] with (nolock) where PPN_DT = @PPN_DT and CDR_ID IS NOT NULL

Delete from AnalyticsStaging.dbo.VAS_SMS_SOUSCRIPTION_NAC where PPN_DT<=@PPN_DT3
Delete from AnalyticsStaging.dbo.VAS_SMS_SOUSCRIPTION_NAC where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.VAS_SMS_SOUSCRIPTION_NAC 
Select
	  ServiceFlow
	 ,Cast(isnull(CDR_ID,0) AS VARCHAR(50)) UNQ_CD_SRC_STM1
     ,Format([CUST_LOCAL_START_DATE],'yyyyMMddHHmmss')UNQ_CD_SRC_STM2
	 ,RIGHT(RTRIM([PRI_IDENTITY]), 8)MSISDN_DD
	 ,Case when RoamState<>'3' then
			(Case when (CallingCellID = '' or CallingCellID is null)and (CalledCellID = '' or CalledCellID is null) then '-1'
				  when (CallingCellID IS NULL or CallingCellID = '') then RIGHT(CalledCellID, 9)
				  else RIGHT(CallingCellID, 9)
		 	 End) else '-1'
	  End  AS SCTR_KEY_LKP
	 ,(Case
			when OnNetIndicator<>'2' and (LEFT(CalledPartyNumber,4) = '2359' or  CalledPartyNumber = '235142' or CalledPartyNumber = '235150')    then 'MOOV'
			when OnNetIndicator<>'2' and  LEFT(CalledPartyNumber,4) = '2356'  then 'AIRTEL'
			when OnNetIndicator<>'2' and  LEFT(CalledPartyNumber,4) = '2357' then 'SALAM'
			when RoamState='0' and  CalledPartyNumber in ('235555','555') then 'MOOV PROMO'
			when OnNetIndicator<>'2' and  CalledPartyNumber= '235420'  then 'MISS TCHAD'
			when OnNetIndicator<>'2' and len(CalledPartyNumber) = 11 and LEFT(CalledPartyNumber,6) = '235223' then 'TAWALI SEMI MOBILE'
			when OnNetIndicator<>'2' and len(CalledPartyNumber) = 11 and LEFT(CalledPartyNumber,6) in ('235227','235228') then 'TAWALI MOBILE'
			when OnNetIndicator<>'2' and len(CalledPartyNumber) = 11 and LEFT(CalledPartyNumber,7) in ('2352252','2352251','2352253','2352250','2352268','2352269') then 'SOTEL FIXE'
			when OnNetIndicator='2' and RoamState<>'3' then 'IDD'
			when OnNetIndicator='1' and RoamState='3' then 'ONNET ROAMING'
			when OnNetIndicator='2' AND RoamState='3' then 'IDD ROAMING'
			when ServiceFlow='2' and OnNetIndicator ='1'  and  left(CalledPartyNumber,4) = '2359' and CHARGE_FROM_ACCOUNT=0 then 'MOOV'
		    else 'MOOV'
      End) as 'HSP_SHRT_NM_LKP'
	 ,Case	when ServiceFlow = '1' then 'SMS-ROAMING_MO'
			when ServiceFlow = '2' then 'SMS-ROAMING_MT'
      END AS SVC_TP_NM
	 ,COALESCE(DEBIT_FROM_PREPAID / 100, 0) DEBIT_FROM_PREPAID
	 ,COALESCE(CHARGE_FROM_ACCOUNT/ 100,0) CHARGE_FROM_ACCOUNT
	 ,Case when OBJECT_TYPE_ID   = 2000 then CHG_AMOUNT   / 100 else 0 End AS CHG_AMOUNT
	 ,Case when OBJECT_TYPE_ID1  = 2000 then CHG_AMOUNT1  / 100 else 0 End AS CHG_AMOUNT1
	 ,Case when OBJECT_TYPE_ID2  = 2000 then CHG_AMOUNT2  / 100 else 0 End AS CHG_AMOUNT2
	 ,Case when OBJECT_TYPE_ID3  = 2000 then CHG_AMOUNT3  / 100 else 0 End AS CHG_AMOUNT3
	 ,Case when OBJECT_TYPE_ID4  = 2000 then CHG_AMOUNT4  / 100 else 0 End AS CHG_AMOUNT4
	 ,Case when OBJECT_TYPE_ID5  = 2000 then CHG_AMOUNT5  / 100 else 0 End AS CHG_AMOUNT5
	 ,Case when OBJECT_TYPE_ID6  = 2000 then CHG_AMOUNT6  / 100 else 0 End AS CHG_AMOUNT6
	 ,Case when OBJECT_TYPE_ID7  = 2000 then CHG_AMOUNT7  / 100 else 0 End AS CHG_AMOUNT7
	 ,Case when OBJECT_TYPE_ID8  = 2000 then CHG_AMOUNT8  / 100 else 0 End AS CHG_AMOUNT8
	 ,Case when OBJECT_TYPE_ID9  = 2000 then CHG_AMOUNT9  / 100 else 0 End AS CHG_AMOUNT9
	 ,Case when OBJECT_TYPE_ID10 = 2000 then CHG_AMOUNT10 / 100 else 0 End AS CHG_AMOUNT10
	 ,Case when OBJECT_TYPE_ID11 = 2000 then CHG_AMOUNT11 / 100 else 0 End AS CHG_AMOUNT11
	 ,Case when OBJECT_TYPE_ID12 = 2000 then CHG_AMOUNT12 / 100 else 0 End AS CHG_AMOUNT12
	 ,Case when OBJECT_TYPE_ID13 = 2000 then CHG_AMOUNT13 / 100 else 0 End AS CHG_AMOUNT13
	 ,Case when OBJECT_TYPE_ID14 = 2000 then CHG_AMOUNT14 / 100 else 0 End AS CHG_AMOUNT14
	 ,CalledPartyNumber as TERMINATING_NUMBER
	 ,CallingPartyNumber as ORIGINATING_NUMBER
	 ,TOTAL_TAX / 100 as NEWDAILYTAXE -- New TOTAL_TAX
	 ,PPN_DT
	 ,ROW_NUMBER() OVER (PARTITION BY CDR_ID, CUST_LOCAL_START_DATE ORDER BY PPN_DT) RN

From #tsms--[dbo].[OCSSMS_NUPGRD] with (nolock)
Drop table #tsms
--WHERE PPN_DT = @PPN_DT and CDR_ID IS NOT NULL --AND  RESULT_CODE='0'

Delete from dbo.AGG_VAS_SMS_SOUSCRIPTION where PPN_DT = @PPN_DT
Insert into dbo.AGG_VAS_SMS_SOUSCRIPTION
Select PPN_DT,HSP_SHRT_NM_LKP,count(1)Nbre,count(distinct MSISDN_DD)Subs,sum(CHARGE_FROM_ACCOUNT)CHARGE_FROM_ACCOUNT,sum(NEWDAILYTAXE)DailyTaxe
       ,Case when ServiceFlow='1' then 'Outgoing'
			 when ServiceFlow='2' then 'Incoming'
	         else 'Other' 
		End SVC_TYPE

From AnalyticsStaging.dbo.VAS_SMS_SOUSCRIPTION_NAC with(nolock)
Where PPN_DT = @PPN_DT
Group by PPN_DT,HSP_SHRT_NM_LKP 
	   ,Case when ServiceFlow='1' then 'Outgoing'
			 when ServiceFlow='2' then 'Incoming'
	         else 'Other' 
		End

End
GO

/****** Object:  StoredProcedure [dbo].[STAGING_VOICE_NAC]    Script Date: 8/23/2021 12:05:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[STAGING_VOICE_NAC]
(
	@PPN_DT	DATE
)
AS

Begin
Declare @PPN_DT3 date
Set @PPN_DT3=dateadd(dd,0,cast(getdate()-3 as date))

Select CDR_ID,TIME_STAMP,ACTUAL_USAGE,RATE_USAGE,CallingPartyNumber,CalledPartyNumber,CallingCellID,CalledCellID,RoamState,CallType,ServiceFlow,CallingHomeCountryCode,PRI_IDENTITY,CHARGE_FROM_ACCOUNT,DEBIT_FROM_PREPAID,TOTAL_TAX,PPN_DT,Reference,
OBJECT_TYPE_ID,OBJECT_TYPE_ID1,OBJECT_TYPE_ID2,OBJECT_TYPE_ID3,OBJECT_TYPE_ID4,OBJECT_TYPE_ID5,OBJECT_TYPE_ID6,OBJECT_TYPE_ID7,OBJECT_TYPE_ID8,OBJECT_TYPE_ID9,OBJECT_TYPE_ID10,OBJECT_TYPE_ID11,OBJECT_TYPE_ID12,OBJECT_TYPE_ID13,OBJECT_TYPE_ID14,
CHG_AMOUNT,CHG_AMOUNT1,CHG_AMOUNT2,CHG_AMOUNT3,CHG_AMOUNT4,CHG_AMOUNT5,CHG_AMOUNT6,CHG_AMOUNT7,CHG_AMOUNT8,CHG_AMOUNT9,CHG_AMOUNT10,CHG_AMOUNT11,CHG_AMOUNT12,CHG_AMOUNT13,CHG_AMOUNT14 into #trec
From OCSREC_NUPGRD (nolock) where PPN_DT=@PPN_DT --and RESULT_CODE='0'

Delete from AnalyticsStaging.dbo.VOICE_JOUR_NAC where PPN_DT<=@PPN_DT3
Delete from AnalyticsStaging.dbo.VOICE_JOUR_NAC where PPN_DT=@PPN_DT
Insert into AnalyticsStaging.dbo.VOICE_JOUR_NAC
Select Cast(CDR_ID as varchar(50)) UNQ_CD_SRC_STM
      ,Cast(format(TIME_STAMP,'yyyyMMddHHmmss') as varchar(14)) UNQ_CD_SRC_STM2
	  ,ACTUAL_USAGE REAL_DRTN
	  ,RATE_USAGE BILL_DRTN
	  ,CallingPartyNumber ORIG_NBR_DD
	  ,CalledPartyNumber TMT_NBR_DD
	  ,Case when RoamState<>'3' then
		(Case when (CallingCellID = '' or CallingCellID is null) and (CalledCellID = '' or CalledCellID is null) then '-1'
			  when (CallingCellID IS NULL or CallingCellID = '') then RIGHT(CalledCellID,9)
              else RIGHT(CallingCellID,9)
         end)
		else '-1'
	   End  as [SCTR_CD_KEY_LKP]
	  ,(Case  when CallType<>'3' and len(CalledPartyNumber)>7 and (left(CalledPartyNumber,4)='2359' and left(CallingPartyNumber,4)='2359') then 'MOOV'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2356') then 'AIRTEL'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2357') then 'SALAM'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,6) = '235223') then 'TAWALI SEMI MOBILE'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,6) in ('235227','235228')) then 'TAWALI MOBILE'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,7) in ('2352250','2352251','2352252','2352253','2352268','2352269')) then 'SOTEL FIXE'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,4)  = '2356') then 'AIRTEL'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,4) = '2357') then 'SALAM'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,6) = '235223') then 'TAWALI SEMI MOBILE'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,6) in ('235227','235228')) then 'TAWALI MOBILE'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,7) in ('2352250','2352251','2352252','2352253','2352268','2352269')) then 'SOTEL FIXE'
			  when CallType ='3' and RoamState <>'3' then 'IDD'
			  when CallType ='0' and RoamState='3' then 'ONNET ROAMING'
			  when CallType ='3' and RoamState='3' then 'IDD ROAMING'
			  when(CallType ='0' and ServiceFlow ='2' and RoamState='0' and  CallingHomeCountryCode in('235','-1')) and (( left(CallingPartyNumber,4) not in ('2359','2356','2357') and 
										left(CallingPartyNumber,6) not in ('235223','235227','235228','235555') and 
										left(CallingPartyNumber,7) not in ('2352252','2352251','2352253','2352250','2352268','2352269'))) then 'MOOV'
			  when(CallType ='0' and ServiceFlow ='2' and RoamState ='0' and  CallingHomeCountryCode not in ('235','-1')) and (( left(CallingPartyNumber,4) not in ('2359','2356','2357') and 
										left(CallingPartyNumber,6) not in ('235223','235227','235228','235555') and 
										left(CallingPartyNumber,7) not in ('2352252','2352251','2352253','2352250','2352268','2352269'))) then 'IDD'
			  when ServiceFlow ='1' and (left(CalledPartyNumber,6) = '235444' or left(CalledPartyNumber,3) = '444') then 'MOOV'
			  when ServiceFlow ='2' and  left(CallingPartyNumber,6) ='235444' then 'MOOV'
			  when ServiceFlow ='1' and (left(CalledPartyNumber,7) = '2358888' or left(CalledPartyNumber,4) = '8888') then 'MOOV'
			  when ServiceFlow ='1' and  CalledPartyNumber = '235223'  then 'MOBILE RADIO'
			  when ServiceFlow ='1' and  CalledPartyNumber in('2354040','235255')  then 'CALL CENTER'
			  when ServiceFlow ='1' and  CalledPartyNumber = '2351101'  then 'FONDATION GRAND COEUR'
			  when ServiceFlow ='2' and  left(CallingPartyNumber,7)='2358888' then 'MOOV'when (ServiceFlow ='2' and CallType ='0' and RoamState ='0') and left(CallingPartyNumber,6)='235555' then 'MOOV'
			  when(ServiceFlow ='1' and  CallType ='0' and RoamState ='0') and (left(CalledPartyNumber,6)='235555' and left(CallingPartyNumber,4)='2359') then 'MOOV'
			  else 'HOME SERVICE - OTHERS'
		End) as HSP_SHRT_NM_LKP
	  ,SERVICEFLOW
	  ,Case	when ServiceFlow ='1' and RoamState ='3' then 'VOICE-ROAMING_MO'
			when ServiceFlow ='2' and RoamState ='3' then 'VOICE-ROAMING_MT'
			when (CallType ='0' and RoamState ='0' and ServiceFlow ='2' )  and  CallingHomeCountryCode not in ('235','-1') then 'VOICE INCOMING IDD'
	   End as SVC_TP_NM
	  ,RIGHT(RTRIM(PRI_IDENTITY),8) as MSISDN_DD
	  ,Case when ServiceFlow ='1' then 'Voice-Outgoing'
		    when ServiceFlow ='2' then 'Voice-Incoming'
			when ServiceFlow ='3' then 'Transit Calls Outgoing'
			else '-1'
	   End as SERVICEUSAGEACTIVITY
	  ,COALESCE(Cast(CHARGE_FROM_ACCOUNT as numeric(18,4))/ 100,0) CHARGE_FROM_ACCOUNT
	  ,Case when OBJECT_TYPE_ID   =2000 then Cast(CHG_AMOUNT   as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT
	  ,Case when OBJECT_TYPE_ID1  =2000 then Cast(CHG_AMOUNT1  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT1
	  ,Case when OBJECT_TYPE_ID2  =2000 then Cast(CHG_AMOUNT2  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT2
	  ,Case when OBJECT_TYPE_ID3  =2000 then Cast(CHG_AMOUNT3  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT3
	  ,Case when OBJECT_TYPE_ID4  =2000 then Cast(CHG_AMOUNT4  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT4
	  ,Case when OBJECT_TYPE_ID5  =2000 then Cast(CHG_AMOUNT5  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT5
	  ,Case when OBJECT_TYPE_ID6  =2000 then Cast(CHG_AMOUNT6  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT6
	  ,Case when OBJECT_TYPE_ID7  =2000 then Cast(CHG_AMOUNT7  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT7
	  ,Case when OBJECT_TYPE_ID8  =2000 then Cast(CHG_AMOUNT8  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT8
	  ,Case when OBJECT_TYPE_ID9  =2000 then Cast(CHG_AMOUNT9  as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT9
	  ,Case when OBJECT_TYPE_ID10 =2000 then cast(CHG_AMOUNT10 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT10
	  ,Case when OBJECT_TYPE_ID11 =2000 then cast(CHG_AMOUNT11 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT11
	  ,Case when OBJECT_TYPE_ID12 =2000 then cast(CHG_AMOUNT12 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT12
	  ,Case when OBJECT_TYPE_ID13 =2000 then cast(CHG_AMOUNT13 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT13
	  ,Case when OBJECT_TYPE_ID14 =2000 then cast(CHG_AMOUNT14 as numeric(18,4))/ 100 else 0 end as CHG_AMOUNT14
	  ,COALESCE(Cast(DEBIT_FROM_PREPAID as numeric(18,4)) / 100,0) DEBIT_FROM_PREPAID
	  ,TOTAL_TAX / 100 DAILYTAXE 
	  ,REFERENCE
	  ,PPN_DT
	  ,ROW_NUMBER() OVER (PARTITION BY CDR_ID,TIME_STAMP ORDER BY PPN_DT) RN --into AnalyticsStaging.dbo.VOICE_JOUR_NAC

From #trec--AnalyticsStaging.dbo.OCSREC_NUPGRD with (nolock)
Where CDR_ID IS NOT NULL --and CDR_ID<>''
Drop table #trec

Delete From dbo.AGG_VOICE Where PPN_DT = @PPN_DT
Insert into dbo.AGG_VOICE
Select PPN_DT,SERVICEUSAGEACTIVITY,HSP_SHRT_NM_LKP,count(distinct MSISDN_DD)Subs
	  ,sum(CHG_AMOUNT+CHG_AMOUNT1+CHG_AMOUNT2+CHG_AMOUNT3+CHG_AMOUNT4 +CHG_AMOUNT5+CHG_AMOUNT6+CHG_AMOUNT7
	  +CHG_AMOUNT8+CHG_AMOUNT9+CHG_AMOUNT10+CHG_AMOUNT11+CHG_AMOUNT12+CHG_AMOUNT13+CHG_AMOUNT14)Billt_Amnt
      ,sum(DAILYTAXE)DAILYTAXE,sum(REAL_DRTN)/60 Duration
      ,Case when ServiceFlow ='1' then 'Outgoing'
	        when ServiceFlow ='2' then 'Incoming'
			else 'Other'
	   End TRAFFIC_TYPE
From AnalyticsStaging.dbo.VOICE_JOUR_NAC with(nolock)
Where PPN_DT = @PPN_DT --and  ServiceUsageCompletionStatus='Successful' 
Group by PPN_DT,SERVICEUSAGEACTIVITY,HSP_SHRT_NM_LKP
      ,Case when ServiceFlow ='1' then 'Outgoing'
	        when ServiceFlow ='2' then 'Incoming'
			else 'Other'
	   End 

End

GO


