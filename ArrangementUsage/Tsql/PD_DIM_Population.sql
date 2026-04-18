--- MGR

select  DISTINCT 'INSERT INTO [AnalyticsTD].[dbo].[PD_DIM]([AUDT_KEY]
      ,[STAGE_AUDT_KEY]
      ,[SRC_OBJ_KEY]
      ,[UNQ_CD_SRC_STM]
      ,[CONTROL_MD5]
	  ,[CTY_KEY]
	  ,[CCY_KEY]
      ,[PD_NM])
       VALUES(-1,-1,252,-1,CAST(HASHBYTES(''MD5'',''' +  Case when Oper_ID ='322' and AdditionalInfo like 'u2opia%' and (CHARGE_FROM_ACCOUNT1 in (2500,13000,31500)
  OR CHARGE_FROM_ACCOUNT2 in (2500,13000,31500)
   OR CHARGE_FROM_ACCOUNT3 in (2500,13000,31500)
    OR CHARGE_FROM_ACCOUNT4 in (2500,13000,31500)
	 OR CHARGE_FROM_ACCOUNT5 in (2500,13000,31500)
	  ) then 'MOOV FOOT'
		    when AdditionalInfo ='A1000XDEXCharging' and EXT_TRANS_ID like 'DE_191%' then 'HOURLY BUNDLES'
			when AdditionalInfo ='A1000XDEXCharging' and EXT_TRANS_ID like 'DE_146%' then 'MBB'
			when AdditionalInfo ='A1000XLive_mw_TigoLoveXCharging' and 
			(CHARGE_FROM_ACCOUNT1 != 0
			OR CHARGE_FROM_ACCOUNT2 != 0
			OR CHARGE_FROM_ACCOUNT3 != 0
			OR CHARGE_FROM_ACCOUNT4 != 0
			OR CHARGE_FROM_ACCOUNT5 != 0
			)then 'MOOVLOVE'
			when AdditionalInfo like 'MoovRede%' then 'MOOVLOVE'
			when AdditionalInfo like 'MOBILE_RADIO%'  then 'MOBILE RADIO'
			when AdditionalInfo like 'IS_PORTAL%' then 'DINIYAT PORTAL'
		    when AdditionalInfo like 'Hosana%' then 'HOSANA'
		    when AdditionalInfo ='A1000XTIGO_QUIZXCharging' then 'MOOV QUIZZ'--Dans SMS
		    when Oper_ID ='322' and AdditionalInfo like 'u2opia_sms_fun%' then 'SMS FUN'
		    when Oper_ID ='365' and EXT_TRANS_ID like 'MAGIC%' then 'MAGIC VOICE'
			when Oper_ID ='365' and EXT_TRANS_ID like 'LEARN%' then 'LEARN ENGLISH'
			when Oper_ID ='418'  and AdditionalInfo like 'Karaoke_%' then 'MOOV KARAOKE'
			when Oper_ID ='102'  and EXT_TRANS_ID like 'MoovEcole%' then 'MOOV ECOLE'
		    when Oper_ID ='332' and ((OBJECT_TYPE_ID1=2532 and OPER_TYPE1 ='2')
			OR (OBJECT_TYPE_ID2=2532 and OPER_TYPE2 ='2')
			OR (OBJECT_TYPE_ID3=2532 and OPER_TYPE3 ='2')
			OR (OBJECT_TYPE_ID4=2532 and OPER_TYPE4 ='2')
			OR (OBJECT_TYPE_ID5=2532 and OPER_TYPE5 ='2')
			OR (OBJECT_TYPE_ID6=2532 and OPER_TYPE6 ='2')
			OR (OBJECT_TYPE_ID7=2532 and OPER_TYPE7 ='2')
			OR (OBJECT_TYPE_ID8=2532 and OPER_TYPE8 ='2')
			OR (OBJECT_TYPE_ID9=2532 and OPER_TYPE9 ='2')
			OR (OBJECT_TYPE_ID10=2532 and OPER_TYPE10 ='2')
			OR (OBJECT_TYPE_ID11=2532 and OPER_TYPE11 ='2')
			OR (OBJECT_TYPE_ID12=2532 and OPER_TYPE12 ='2')
			OR (OBJECT_TYPE_ID13=2532 and OPER_TYPE13 ='2')
			OR (OBJECT_TYPE_ID14=2532 and OPER_TYPE14 ='2')
			OR (OBJECT_TYPE_ID15=2532 and OPER_TYPE15 ='2')
			) and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'CVAS_LOAN SOUSCRIPTION'
		    when Oper_ID ='332' and (OBJECT_TYPE_ID1=2000
			OR OBJECT_TYPE_ID2=2000
			OR OBJECT_TYPE_ID3=2000
			OR OBJECT_TYPE_ID4=2000
			OR OBJECT_TYPE_ID5=2000
			OR OBJECT_TYPE_ID6=2000
			OR OBJECT_TYPE_ID7=2000
			OR OBJECT_TYPE_ID8=2000
			OR OBJECT_TYPE_ID9=2000
			OR OBJECT_TYPE_ID10=2000
			OR OBJECT_TYPE_ID11=2000
			OR OBJECT_TYPE_ID12=2000
			OR OBJECT_TYPE_ID13=2000
			OR OBJECT_TYPE_ID14=2000
			OR OBJECT_TYPE_ID15=2000) and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'CVAS_LOAN REPAYMENT'
		    when Oper_ID ='332' then 'CVAS_LOAN OPERATION'
		    --when OperationID ='4052100'  and Oper_ID ='411' and OperationType='999' and left(EXT_TRANS_ID,10)!=  'TSS_REFUND' then 'CC_TSS'
		    when Oper_ID ='325'  and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'T&T TargetedSales'
		    --when OperationID ='4052100' and left(AdditionalInfo,3)not in ('tag','tig')   and left(EXT_TRANS_ID,10)!=  'TSS_REFUND' and Oper_ID ='PRAYER_TargetedSaleSys' then 'PRIERE RAMADAN'
		    when Oper_ID ='383' and EXT_TRANS_ID like 'HYBRID_%'  and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'HYBRID MIDDLEWARE'
		    when OperationID ='4052101'  and (OBJECT_TYPE_ID1=2000
			OR OBJECT_TYPE_ID2=2000
			OR OBJECT_TYPE_ID3=2000
			OR OBJECT_TYPE_ID4=2000
			OR OBJECT_TYPE_ID5=2000
			OR OBJECT_TYPE_ID6=2000
			OR OBJECT_TYPE_ID7=2000
			OR OBJECT_TYPE_ID8=2000
			OR OBJECT_TYPE_ID9=2000
			OR OBJECT_TYPE_ID10=2000
			OR OBJECT_TYPE_ID11=2000
			OR OBJECT_TYPE_ID12=2000
			OR OBJECT_TYPE_ID13=2000
			OR OBJECT_TYPE_ID14=2000
			OR OBJECT_TYPE_ID15=2000) then 'P2P TRANSFER'
		    --when Oper_ID in ('330','340') then 'RBT'
			when AdditionalInfo like '%RBT%' then 'RBT'
		    when Oper_ID ='10310' and (OPER_TYPE1=2
			OR OPER_TYPE2=2
			OR OPER_TYPE3=2
			OR OPER_TYPE4=2
			OR OPER_TYPE5=2
			OR OPER_TYPE6=2
			OR OPER_TYPE7=2
			OR OPER_TYPE8=2
			OR OPER_TYPE9=2
			OR OPER_TYPE10=2
			OR OPER_TYPE11=2
			OR OPER_TYPE12=2
			OR OPER_TYPE13=2
			OR OPER_TYPE14=2
			OR OPER_TYPE15=2) then 'BATCH ADJUST BALANCE'
		    when OperationID ='4052100' and Oper_ID not in ('325','332','411','10428','383','330','340','10367','325') then 'ADJUST BALANCE'
            else Convert(VARCHAR(50),NewOfferingID)
	   End + ''') AS BINARY(20)),-1,-1,''' + Case when Oper_ID ='322' and AdditionalInfo like 'u2opia%' and (CHARGE_FROM_ACCOUNT1 in (2500,13000,31500)
  OR CHARGE_FROM_ACCOUNT2 in (2500,13000,31500)
   OR CHARGE_FROM_ACCOUNT3 in (2500,13000,31500)
    OR CHARGE_FROM_ACCOUNT4 in (2500,13000,31500)
	 OR CHARGE_FROM_ACCOUNT5 in (2500,13000,31500)
	  ) then 'MOOV FOOT'
		    when AdditionalInfo ='A1000XDEXCharging' and EXT_TRANS_ID like 'DE_191%' then 'HOURLY BUNDLES'
			when AdditionalInfo ='A1000XDEXCharging' and EXT_TRANS_ID like 'DE_146%' then 'MBB'
			when AdditionalInfo ='A1000XLive_mw_TigoLoveXCharging' and 
			(CHARGE_FROM_ACCOUNT1 != 0
			OR CHARGE_FROM_ACCOUNT2 != 0
			OR CHARGE_FROM_ACCOUNT3 != 0
			OR CHARGE_FROM_ACCOUNT4 != 0
			OR CHARGE_FROM_ACCOUNT5 != 0
			)then 'MOOVLOVE'
			when AdditionalInfo like 'MoovRede%' then 'MOOVLOVE'
			when AdditionalInfo like 'MOBILE_RADIO%'  then 'MOBILE RADIO'
			when AdditionalInfo like 'IS_PORTAL%' then 'DINIYAT PORTAL'
		    when AdditionalInfo like 'Hosana%' then 'HOSANA'
		    when AdditionalInfo ='A1000XTIGO_QUIZXCharging' then 'MOOV QUIZZ'--Dans SMS
		    when Oper_ID ='322' and AdditionalInfo like 'u2opia_sms_fun%' then 'SMS FUN'
		    when Oper_ID ='365' and EXT_TRANS_ID like 'MAGIC%' then 'MAGIC VOICE'
			when Oper_ID ='365' and EXT_TRANS_ID like 'LEARN%' then 'LEARN ENGLISH'
			when Oper_ID ='418'  and AdditionalInfo like 'Karaoke_%' then 'MOOV KARAOKE'
			when Oper_ID ='102'  and EXT_TRANS_ID like 'MoovEcole%' then 'MOOV ECOLE'
		    when Oper_ID ='332' and ((OBJECT_TYPE_ID1=2532 and OPER_TYPE1 ='2')
			OR (OBJECT_TYPE_ID2=2532 and OPER_TYPE2 ='2')
			OR (OBJECT_TYPE_ID3=2532 and OPER_TYPE3 ='2')
			OR (OBJECT_TYPE_ID4=2532 and OPER_TYPE4 ='2')
			OR (OBJECT_TYPE_ID5=2532 and OPER_TYPE5 ='2')
			OR (OBJECT_TYPE_ID6=2532 and OPER_TYPE6 ='2')
			OR (OBJECT_TYPE_ID7=2532 and OPER_TYPE7 ='2')
			OR (OBJECT_TYPE_ID8=2532 and OPER_TYPE8 ='2')
			OR (OBJECT_TYPE_ID9=2532 and OPER_TYPE9 ='2')
			OR (OBJECT_TYPE_ID10=2532 and OPER_TYPE10 ='2')
			OR (OBJECT_TYPE_ID11=2532 and OPER_TYPE11 ='2')
			OR (OBJECT_TYPE_ID12=2532 and OPER_TYPE12 ='2')
			OR (OBJECT_TYPE_ID13=2532 and OPER_TYPE13 ='2')
			OR (OBJECT_TYPE_ID14=2532 and OPER_TYPE14 ='2')
			OR (OBJECT_TYPE_ID15=2532 and OPER_TYPE15 ='2')
			) and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'CVAS_LOAN SOUSCRIPTION'
		    when Oper_ID ='332' and (OBJECT_TYPE_ID1=2000
			OR OBJECT_TYPE_ID2=2000
			OR OBJECT_TYPE_ID3=2000
			OR OBJECT_TYPE_ID4=2000
			OR OBJECT_TYPE_ID5=2000
			OR OBJECT_TYPE_ID6=2000
			OR OBJECT_TYPE_ID7=2000
			OR OBJECT_TYPE_ID8=2000
			OR OBJECT_TYPE_ID9=2000
			OR OBJECT_TYPE_ID10=2000
			OR OBJECT_TYPE_ID11=2000
			OR OBJECT_TYPE_ID12=2000
			OR OBJECT_TYPE_ID13=2000
			OR OBJECT_TYPE_ID14=2000
			OR OBJECT_TYPE_ID15=2000) and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'CVAS_LOAN REPAYMENT'
		    when Oper_ID ='332' then 'CVAS_LOAN OPERATION'
		    --when OperationID ='4052100'  and Oper_ID ='411' and OperationType='999' and left(EXT_TRANS_ID,10)!=  'TSS_REFUND' then 'CC_TSS'
		    when Oper_ID ='325'  and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'T&T TargetedSales'
		    --when OperationID ='4052100' and left(AdditionalInfo,3)not in ('tag','tig')   and left(EXT_TRANS_ID,10)!=  'TSS_REFUND' and Oper_ID ='PRAYER_TargetedSaleSys' then 'PRIERE RAMADAN'
		    when Oper_ID ='383' and EXT_TRANS_ID like 'HYBRID_%'  and left(EXT_TRANS_ID,10)!='TSS_REFUND' then 'HYBRID MIDDLEWARE'
		    when OperationID ='4052101'  and (OBJECT_TYPE_ID1=2000
			OR OBJECT_TYPE_ID2=2000
			OR OBJECT_TYPE_ID3=2000
			OR OBJECT_TYPE_ID4=2000
			OR OBJECT_TYPE_ID5=2000
			OR OBJECT_TYPE_ID6=2000
			OR OBJECT_TYPE_ID7=2000
			OR OBJECT_TYPE_ID8=2000
			OR OBJECT_TYPE_ID9=2000
			OR OBJECT_TYPE_ID10=2000
			OR OBJECT_TYPE_ID11=2000
			OR OBJECT_TYPE_ID12=2000
			OR OBJECT_TYPE_ID13=2000
			OR OBJECT_TYPE_ID14=2000
			OR OBJECT_TYPE_ID15=2000) then 'P2P TRANSFER'
		    --when Oper_ID in ('330','340') then 'RBT'
			when AdditionalInfo like '%RBT%' then 'RBT'
		    when Oper_ID ='10310' and (OPER_TYPE1=2
			OR OPER_TYPE2=2
			OR OPER_TYPE3=2
			OR OPER_TYPE4=2
			OR OPER_TYPE5=2
			OR OPER_TYPE6=2
			OR OPER_TYPE7=2
			OR OPER_TYPE8=2
			OR OPER_TYPE9=2
			OR OPER_TYPE10=2
			OR OPER_TYPE11=2
			OR OPER_TYPE12=2
			OR OPER_TYPE13=2
			OR OPER_TYPE14=2
			OR OPER_TYPE15=2) then 'BATCH ADJUST BALANCE'
		    when OperationID ='4052100' and Oper_ID not in ('325','332','411','10428','383','330','340','10367','325') then 'ADJUST BALANCE'
            else Convert(VARCHAR(50),NewOfferingID)
	   End + ''')'																												
	   AS PD_KEY_LKP
	   FROm CBSMGR with (nolock)
	   where ppn_dt = '2/16/2025'



--- VOU

	 select  DISTINCT 'INSERT INTO [AnalyticsTD].[dbo].[PD_DIM]([AUDT_KEY]
      ,[STAGE_AUDT_KEY]
      ,[SRC_OBJ_KEY]
      ,[UNQ_CD_SRC_STM]
      ,[CONTROL_MD5]
	  ,[CTY_KEY]
	  ,[CCY_KEY]
      ,[PD_NM])
       VALUES(-1,-1,263,-1,CAST(HASHBYTES(''MD5'',''' +  upper(Case when TradeType = 0		then '0_RLD'
	--when TradeType in (1,2)		then '2_RLD'
	--when TradeType in (3,4)		then '4_RLD'
	--when TradeType in (5,6)		then '6_RLD'
	--when TradeType = 7		then '7_RLD'
	--when TradeType = 999	then '999_RLD'
	--when TradeType in (1000,1007)	then '11_RLD'
            when TradeType ='1049' and RECHARGE_AMT between 1000 and 100000 then '10_1000_RLD_TC'
			when TradeType ='1049' and RECHARGE_AMT between 100001 and 500000 then '1001_5000_RLD_TC'
			when TradeType ='1049' and RECHARGE_AMT between 500001 and 1000000 then '5001_10000_RLD_TC'
			when TradeType ='1049' and RECHARGE_AMT between 1000001 and 3000000 then '10001_30000_RLD_TC'
			when TradeType ='1049' and RECHARGE_AMT > 3000000 then '30001_RLD_TC'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 100 then '100_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 250 then '250_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 500 then '500_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 750 then '750_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1000 then '1000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1250 then '1250_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1500 then '1500_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1750 then '1750_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 2000 then '2000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 5000 then '5000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 10000 then '10000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 30000 then '30000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 50000 then '50000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 100000 then '100000_RLD_EP'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 100 then '100_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 250 then '250_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 500 then '500_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 750 then '750_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1000 then '1000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1250 then '1250_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1500 then '1500_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1750 then '1750_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 2000 then '2000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 5000 then '5000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 10000 then '10000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 30000 then '30000_RLD'
	        else 'Airtime Recharge'--Default PD_NM
	   End)  + ''') AS BINARY(20)),-1,-1,''' + upper(Case when TradeType = 0		then '0_RLD'
	--when TradeType in (1,2)		then '2_RLD'
	--when TradeType in (3,4)		then '4_RLD'
	--when TradeType in (5,6)		then '6_RLD'
	--when TradeType = 7		then '7_RLD'
	--when TradeType = 999	then '999_RLD'
	--when TradeType in (1000,1007)	then '11_RLD'
            when TradeType ='1049' and RECHARGE_AMT between 1000 and 100000 then '10_1000_RLD_TC'
			when TradeType ='1049' and RECHARGE_AMT between 100001 and 500000 then '1001_5000_RLD_TC'
			when TradeType ='1049' and RECHARGE_AMT between 500001 and 1000000 then '5001_10000_RLD_TC'
			when TradeType ='1049' and RECHARGE_AMT between 1000001 and 3000000 then '10001_30000_RLD_TC'
			when TradeType ='1049' and RECHARGE_AMT > 3000000 then '30001_RLD_TC'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 100 then '100_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 250 then '250_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 500 then '500_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 750 then '750_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1000 then '1000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1250 then '1250_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1500 then '1500_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1750 then '1750_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 2000 then '2000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 5000 then '5000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 10000 then '10000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 30000 then '30000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 50000 then '50000_RLD_EP'
			when TradeType ='7'  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 100000 then '100000_RLD_EP'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 100 then '100_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 250 then '250_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 500 then '500_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 750 then '750_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1000 then '1000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1250 then '1250_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1500 then '1500_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 1750 then '1750_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 2000 then '2000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 5000 then '5000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 10000 then '10000_RLD'
			when TradeType not in ('7','0','1049')  and COALESCE(CAST(RECHARGE_AMT AS MONEY)/100 , 0) = 30000 then '30000_RLD'
	        else 'Airtime Recharge'--Default PD_NM
	   End) + ''')'																												
	   AS PD_KEY_LKP
	   FROm CBSVOU with (nolock)
	   where ppn_dt = '7/1/2021'
	   

	--- TSS

	 select TOP 1  'INSERT INTO [AnalyticsTD].[dbo].[PD_DIM]([AUDT_KEY]
      ,[STAGE_AUDT_KEY]
      ,[SRC_OBJ_KEY]
      ,[UNQ_CD_SRC_STM]
      ,[CONTROL_MD5]
	  ,[CTY_KEY]
	  ,[CCY_KEY]
      ,[PD_NM])
       VALUES(-1,-1,263,-1,CAST(HASHBYTES(''MD5'',''EVC_SUBSCRIPTION'') AS BINARY(20)),-1,-1,''EVC_SUBSCRIPTION'')'																												
	   AS PD_KEY_LKP
	   FROm TSS with (nolock)
	   where ppn_dt = '5/2/2021'
	   