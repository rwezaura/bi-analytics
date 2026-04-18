
select 
(CASE 
			WHEN CallType = 3 THEN
			(CASE 
				WHEN LEFT(LTRIM(CalledHomeCountryCode), 1) = 1 THEN CAST(LEFT(CalledPartyNumber, 4) AS INT)
				WHEN LEFT(LTRIM(CalledHomeCountryCode), 1) = 7 THEN CAST(LEFT(CalledPartyNumber, 2) AS INT)
				ELSE CAST(LTRIM(CalledHomeCountryCode) AS INT)
				END) 
	  END) AS 'CTY_LKP',
	  CONVERT(varchar(30),(Case  when CallType<>'3' and len(CalledPartyNumber)>7 and (left(CalledPartyNumber,4)='2359' and left(CallingPartyNumber,4)='2359') then 'MOOV'
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
			  --when CallType ='3' and RoamState <>'3' then 'IDD'
			  when CallType ='0' and RoamState='3' then 'ONNET ROAMING'
			  --when CallType ='3' and RoamState='3' then 'IDD ROAMING'
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
		End)) AS HSP_SHRT_NM_LKP,
CONVERT(varchar(20),(CASE 
		WHEN RoamState = 3 THEN
			(CASE
				WHEN serviceFlow = 1 
				THEN CAST(
						CASE 
							WHEN CallingRoamCountryCode = '1' THEN '1201' 
							WHEN CallingRoamCountryCode = '7' THEN '71'
							ELSE CallingRoamCountryCode
						END AS VARCHAR)
				WHEN serviceFlow = 2 
				THEN CAST(
						CASE
							WHEN CalledRoamCountryCode = '1' THEN '1201'
							WHEN CalledRoamCountryCode = '7' THEN '71'
							ELSE CalledRoamCountryCode
						END AS VARCHAR)
					END)
			 ELSE

		(CASE WHEN CallForwardIndicator = 0 THEN
	  (CASE WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,4) = '2359' THEN 'SC-0000'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,4) = '2356'	THEN 'SC-0001'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,4) = '2357'	THEN 'SC-0002'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,6) = '235223'	THEN 'SC-0003'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,6) IN ('235227','235228')	THEN 'SC-0004'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,6) IN ('2352250','2352251','2352252','2352253','2352268','2352269')	THEN 'SC-0005'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,4) = '2359' THEN 'SC-0006'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,4) = '2356'	THEN 'SC-0007'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,4) = '2357'	THEN 'SC-0008'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,6) = '235223'	THEN 'SC-0009'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,6) IN ('235227','235228')	THEN 'SC-0010'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,6) IN ('2352250','2352251','2352252','2352253','2352268','2352269')	THEN 'SC-0011'
			--when ServiceFlow = '2' and CallType ='3' and RoamState <>'3' then 'SC-0012'
			--when ServiceFlow = '2' and CallType ='0' and RoamState = '3' then 'SC-0013'
			--when ServiceFlow = '2' and CallType ='3' and RoamState = '3' then 'SC-0014'
			--when ServiceFlow = '1' and CallType ='3' and RoamState <>'3' then 'SC-0015'
			--when ServiceFlow = '1' and CallType ='0' and RoamState = '3' then 'SC-0016'
			--when ServiceFlow = '1' and CallType ='3' and RoamState = '3' then 'SC-0017'
			  END)																								
	  ELSE
	  (CASE WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,4) = '2359' THEN 'SC-0018'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,4) = '2356'	THEN 'SC-0019'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,4) = '2357'	THEN 'SC-0020'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,6) = '235223'	THEN 'SC-0021'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,6) IN ('235227','235228')	THEN 'SC-0022'
			WHEN ServiceFlow = '2' and CallType = 0 and left(CalledPartyNumber,6) IN ('2352250','2352251','2352252','2352253','2352268','2352269')	THEN 'SC-0023'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,4) = '2359' THEN 'SC-0024'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,4) = '2356'	THEN 'SC-0025'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,4) = '2357'	THEN 'SC-0026'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,6) = '235223'	THEN 'SC-0027'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,6) IN ('235227','235228')	THEN 'SC-0028'
			WHEN ServiceFlow = '1' and CallType = 0 and left(CalledPartyNumber,6) IN ('2352250','2352251','2352252','2352253','2352268','2352269')	THEN 'SC-0029'
			--when ServiceFlow = '2' and CallType ='3' and RoamState <>'3' then 'SC-0030'
			--when ServiceFlow = '2' and CallType ='0' and RoamState = '3' then 'SC-0031'
			--when ServiceFlow = '2' and CallType ='3' and RoamState = '3' then 'SC-0032'
			--when ServiceFlow = '1' and CallType ='3' and RoamState <>'3' then 'SC-0033'
			--when ServiceFlow = '1' and CallType ='0' and RoamState = '3' then 'SC-0034'
			--when ServiceFlow = '1' and CallType ='3' and RoamState = '3' then 'SC-0035'
			  END)
	  END)END)) AS SVC_KEY_LKP,
		*
		into #hsp300
		from cbsrec
		where ppn_dt = '7/1/2021'

		select * from #hsp200

select DISTINCT CASE 
WHEN HSP_SHRT_NM_LKP = 'MOOV' THEN 'SC-1'
WHEN HSP_SHRT_NM_LKP = 'MOOV' THEN 'SC-2'
WHEN HSP_SHRT_NM_LKP = 'AIRTEL' THEN 'SC-3'
WHEN HSP_SHRT_NM_LKP = 'AIRTEL' THEN 'SC-4'
WHEN HSP_SHRT_NM_LKP = 'SOTEL FIXE' THEN 'SC-8'
WHEN HSP_SHRT_NM_LKP = 'TAWALI SEM' THEN 'SC-9'
WHEN HSP_SHRT_NM_LKP = 'MOOV' THEN 'SC-12'
WHEN HSP_SHRT_NM_LKP = 'AIRTEL' THEN 'SC-19'
WHEN HSP_SHRT_NM_LKP = 'AIRTEL' THEN 'SC-24'
WHEN HSP_SHRT_NM_LKP = 'SOTEL FIXE' THEN 'SC-29'
WHEN HSP_SHRT_NM_LKP = 'TAWALI SEM' THEN 'SC-30'
WHEN HSP_SHRT_NM_LKP = 'TAWALI SEM' THEN 'SC-307'
END 'Proc',SVC_KEY_LKP from #hsp300
where SVC_KEY_LKP LIKE 'SC%'
















		;with cte
		as
		(
		select  *,ROW_NUMBER() OVER (PARTITION BY ServiceUsageCompletionReason order by [STAGE_AUDIT_KEY]) RN
		from #hsp7
		)
		--insert into [AnalyticsTD].[dbo].[HM_SVC_PVDR_DIM]
  --([AUDT_KEY]
  --    ,[STAGE_AUDT_KEY]
  --    ,[SRC_OBJ_KEY]
  --    ,[UNQ_CD_SRC_STM]
  --    ,[CONTROL_MD5]
  --    ,[HM_SVC_PVDR_NM]
  --    ,[HM_SVC_PVDR_SH_NM]
  --    ,[CTY_KEY])
		select 'insert into [AnalyticsTD].[dbo].[SVC_USG_COMPL_RSN_DIM]
  ([AUDT_KEY]
      ,[STAGE_AUDT_KEY]
      ,[SRC_OBJ_KEY]
      ,[UNQ_CD_SRC_STM]
      ,[SVC_USG_COMPL_RSN_NM]
	  ,[CONTROL_MD5]) values (' + cast(AUDIT_KEY as varchar(10)) + 
		',' + cast(STAGE_AUDIT_KEY as varchar(10)) + ',' + cast(SRC_OBJ_KEY as varchar(10)) + ',''' + SVC_USG_COMPL_RSN_NM + 
		 ''','''  + cast(CAST(HASHBYTES('MD5', SVC_USG_COMPL_RSN_NM) AS BINARY(20))  as varchar(50)) + ''')'
		from cte
		where RN=1

		insert into [AnalyticsTD].[dbo].[HM_SVC_PVDR_DIM]([AUDT_KEY]        ,[STAGE_AUDT_KEY]        ,[SRC_OBJ_KEY]        ,[UNQ_CD_SRC_STM]        ,[HM_SVC_PVDR_NM]        ,[HM_SVC_PVDR_SH_NM]        ,[CTY_KEY]     ,[CONTROL_MD5]) 
		values (372,3320,248,'TAWALI SEMI MOBILE','TBU','TBU',-1,'k¶;{Î 1ÚWMÑØ,ˆ