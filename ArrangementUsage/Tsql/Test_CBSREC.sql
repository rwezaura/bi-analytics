USE [AnalyticsStaging]
GO

--  EXEC dbo.VOICE_SVC_FCT_Source_CBS_IL '7/1/2021', '1900-01-01 00:00:00.000', '2021-08-25 15:22:43.247'

	declare @PPN_DT DATE='7/1/2021'
	declare @LastLoadDate  datetime2='1900-01-01 00:00:00.000'
	declare @SystemStartTime datetime2='2021-08-25 15:22:43.247'


SELECT 
	--CAST(innerCDRSequence AS VARCHAR(50))  AS 'UNQ_CD_SRC_STM1'
	CAST(CDR_ID AS VARCHAR(25))+':'+ CAST(CDR_SUB_ID AS VARCHAR(24)) AS 'UNQ_CD_SRC_STM1'
  , CONVERT(VARCHAR(50),replace(replace(replace(convert(varchar(30),[CREATE_DATE], 20),'-',''),':',''),' ','')) AS 'UNQ_CD_SRC_STM2'
  ,FileName FILE_NM
	,'rec' SourceSystem
	,@PPN_DT AS PPN_DT

/* 
	The below SCTR_NM is used in the package to perform a lookup and retrieve both the BTS and SCTR Unknown Keys.  
    These keys are used if the SCTR and BTS lookups fail to find a valid match.
*/
	, 'VOICE - UNKNOWN SCTR' AS SCTR_NM -- Added By Mitchell on 5/27 to fix the incorrect hardcoding of keys in the SSIS Packages.

  , ROW_NUMBER() OVER (PARTITION BY CAST(CDR_ID AS VARCHAR(25))+':'+ CAST(CDR_SUB_ID AS VARCHAR(25)), replace(replace(replace(convert(varchar(30),[CREATE_DATE], 20),'-',''),':',''),' ','') ORDER BY PPN_DT) RN
  ,	CAST([ACTUAL_USAGE] AS NUMERIC(18, 4)) AS REAL_DRTN
  , CAST([RATE_USAGE] AS NUMERIC(18, 4)) AS BILL_DRTN
  , ROUND([ACTUAL_USAGE], 0) AS RND_DRTN
  , [CallingPartyNumber] AS ORIG_NBR_DD
  , [RECIPIENT_NUMBER] AS TMT_NBR_DD
  , [STAGE_AUDIT_KEY]

 
  ,PayType
 ,CAST(DATENAME(WEEKDAY,
			 CONVERT(datetime,LEFT(CUST_LOCAL_START_DATE,4) + '-' + RIGHT(LEFT(CUST_LOCAL_START_DATE,6),2) + '-' + RIGHT(LEFT(CUST_LOCAL_START_DATE,8),2)
			+ ' ' + RIGHT(LEFT(CUST_LOCAL_START_DATE,10),2) + ':' + RIGHT(LEFT(CUST_LOCAL_START_DATE,12),2) + ':' +  RIGHT(CUST_LOCAL_START_DATE,2))) AS VARCHAR(9)) AS [DayOfWeek]
  , CONVERT(DATE, CONVERT(datetime,LEFT(CUST_LOCAL_START_DATE,4) + '-' + RIGHT(LEFT(CUST_LOCAL_START_DATE,6),2) + '-' + RIGHT(LEFT(CUST_LOCAL_START_DATE,8),2)
			+ ' ' + RIGHT(LEFT(CUST_LOCAL_START_DATE,10),2) + ':' + RIGHT(LEFT(CUST_LOCAL_START_DATE,12),2) + ':' +  RIGHT(CUST_LOCAL_START_DATE,2)), 103) AS [FCT_DT]
  , CONVERT(DATE, CONVERT(datetime,LEFT(CUST_LOCAL_START_DATE,4) + '-' + RIGHT(LEFT(CUST_LOCAL_START_DATE,6),2) + '-' + RIGHT(LEFT(CUST_LOCAL_START_DATE,8),2)
			+ ' ' + RIGHT(LEFT(CUST_LOCAL_START_DATE,10),2) + ':' + RIGHT(LEFT(CUST_LOCAL_START_DATE,12),2) + ':' +  RIGHT(CUST_LOCAL_START_DATE,2)), 103) AS [RTG_DT]

/* BTS is defined from a user defined function, Function is been replaced by query*/

/*Calling Cellid SECTOR*/
	, CONVERT(varchar(20),CASE WHEN roamstate = 3 THEN '8'
	  --WHEN ((calledpartynumber = '255387') or (calledpartynumber = '25515050')
			--or (calledpartynumber = '25515007') or (calledpartynumber = '255901656564')
			--or (calledpartynumber = '255901656565') or (calledpartynumber = '255901901901') or (calledpartynumber = '0901901901')
			--or (calledpartynumber = '255901900000') or (calledpartynumber = '0901900000') or (calledpartynumber = '255901999999')
			--or (calledpartynumber = '255901904444') or (calledpartynumber = '255901905555')
			--or (CalledPartyNumber = '255901652222'	or CalledPartyNumber = '255901653333')
			--or (CalledPartyNumber = '255901900900' or CalledPartyNumber = '255901656667'))  
	  --THEN '6'
	  ELSE
	  
	  
	 CAST(COALESCE(LTRIM(RTRIM(
		CASE 
			WHEN LEFT(CallingCellID, 5) = '62203'
			THEN  
				LEFT(CallingCellID, 5) + RIGHT(CallingCellID, 9)
			ELSE CallingCellID					 -- IF THE RESULT IS NULL WE COALESCE TO 'UNKNOWN'. Note: Unknown will not find a match 
				    							 -- in the sector dimension. This is by design. We have a seperate lookup and a derived column
		END)), 'Unknown') AS VARCHAR(50))   	 --	in the ssis package that handles unknowns.
 END) AS [SCTR_KEY_LKP]


	  
	 -- CAST(COALESCE(LTRIM(RTRIM(
		--case
		--	when (LEN('')=0  OR '' IS NULL) 
		--	then  
		--		case '64002'+SUBSTRING(substring(CallingCellID ,6,len(CallingCellID)),
		--			PATINDEX('%[^0]%', substring(CallingCellID ,6,len(CallingCellID))),
		--			LEN(substring(CallingCellID ,6,len(CallingCellID))))
		--			when '64002'
		--			then null
		--			else '64002'+SUBSTRING(substring(CallingCellID ,6,len(CallingCellID)),
		--				PATINDEX('%[^0]%', substring(CallingCellID ,6,len(CallingCellID))),
		--				LEN(substring(CallingCellID ,6,len(CallingCellID))))
		--		end
    
		--	else 
		--		case '64002'+SUBSTRING(substring('' ,6,len('')),
		--			PATINDEX('%[^0]%', substring('' ,6,len(''))),
		--			LEN(substring('' ,6,len(''))))
		--			when '64002' 
		--			then null
		--			else '64002'+SUBSTRING(substring('' ,6,len('')),
		--				PATINDEX('%[^0]%', substring('' ,6,len(''))),
		--				LEN(substring('' ,6,len(''))))
		--		end   
     
  --  end)), '7') AS VARCHAR(50)) end  AS [SECTOR_KEY_LKP]

	/*Called Cellid SECTOR*/
	, case when roamstate = 3 then '8'
	  --WHEN ((calledpartynumber = '255387') or (calledpartynumber = '25515050')
			--or (calledpartynumber = '25515007') or (calledpartynumber = '255901656564')
			--or (calledpartynumber = '255901656565') or (calledpartynumber = '255901901901') or (calledpartynumber = '0901901901')
			--or (calledpartynumber = '255901900000') or (calledpartynumber = '0901900000') or (calledpartynumber = '255901999999')
			--or (calledpartynumber = '255901904444') or (calledpartynumber = '255901905555')
			--or (CalledPartyNumber = '255901652222'	or CalledPartyNumber = '255901653333')
			--or (CalledPartyNumber = '255901900900' or CalledPartyNumber = '255901656667'))  then '6'
	   
	  ELSE CAST(COALESCE(LTRIM(RTRIM(
		CASE 
			WHEN LEFT(CalledCellID, 5)  = '62203'
			THEN LEFT(CalledCellID, 5) + RIGHT(CalledCellID, 9)
			
    
			ELSE CalledCellID					 -- IF THE RESULT IS NULL WE COALESCE TO 'UNKNOWN'. Note: Unknown will not find a match 
				    							 -- in the sector dimension. This is by design. We have a seperate lookup and a derived column
		END)), 'Unknown') AS VARCHAR(50))   	 --	in the ssis package that handles unknowns.
 END AS [SCTR_KEY_LKP_CALLED]

	 -- CAST(COALESCE(LTRIM(RTRIM(
		--case
		--	when (LEN('')=0  OR '' IS NULL) 
		--	then  
		--		case '64002'+SUBSTRING(substring(CalledCellID ,6,len(CalledCellID)),
		--			PATINDEX('%[^0]%', substring(CalledCellID ,6,len(CalledCellID))),
		--			LEN(substring(CalledCellID ,6,len(CalledCellID))))
		--			when '64002'
		--			then null
		--			else '64002'+SUBSTRING(substring(CalledCellID ,6,len(CalledCellID)),
		--				PATINDEX('%[^0]%', substring(CalledCellID ,6,len(CalledCellID))),
		--				LEN(substring(CalledCellID ,6,len(CalledCellID))))
		--		end
    
		--	else 
		--		case '64002'+SUBSTRING(substring('' ,6,len('')),
		--			PATINDEX('%[^0]%', substring('' ,6,len(''))),
		--			LEN(substring('' ,6,len(''))))
		--			when '64002' 
		--			then null
		--			else '64002'+SUBSTRING(substring('' ,6,len('')),
		--				PATINDEX('%[^0]%', substring('' ,6,len(''))),
		--				LEN(substring('' ,6,len(''))))
		--		end   
     
  --  end)), '7') AS VARCHAR(50)) end  AS [SCTR_KEY_LKP_CALLED]


  --BTS KEYs now come from the SECTOR Dimension lookup so this is commented out.
  --, CASE WHEN roamstate = 3 THEN '8' 
		--	  ELSE (CASE WHEN CallingCellID IS NULL
		--	   OR CallingCellID = '' THEN NULL
		--	   WHEN ((calledpartynumber = '255387') or (calledpartynumber = '25515050')
		--	or (calledpartynumber = '25515007') or (calledpartynumber = '255901656564')
		--	or (calledpartynumber = '255901656565') or (calledpartynumber = '255901901901') or (calledpartynumber = '0901901901')
		--	or (calledpartynumber = '255901900000') or (calledpartynumber = '0901900000') or (calledpartynumber = '255901999999')
		--	or (calledpartynumber = '255901904444') or (calledpartynumber = '255901905555')
		--	or (CalledPartyNumber = '255901652222'	or CalledPartyNumber = '255901653333')
		--	or (CalledPartyNumber = '255901900900' or CalledPartyNumber = '255901656667')) THEN '6'
		--  ELSE LEFT(RIGHT(CallingCellID,9) ,4) + '' + RIGHT(CallingCellID,4)
	 --END) end AS [BTS_KEY_LKP]

	 /*Called BTS*/
	--, case when roamstate = 3 then '8' else (CASE WHEN CalledCellID IS NULL
	--		   OR CalledCellID = '' THEN NULL
	--		   WHEN ((calledpartynumber = '255387') or (calledpartynumber = '25515050')
	--		or (calledpartynumber = '25515007') or (calledpartynumber = '255901656564')
	--		or (calledpartynumber = '255901656565') or (calledpartynumber = '255901901901') or (calledpartynumber = '0901901901')
	--		or (calledpartynumber = '255901900000') or (calledpartynumber = '0901900000') or (calledpartynumber = '255901999999')
	--		or (calledpartynumber = '255901904444') or (calledpartynumber = '255901905555')
	--		or (CalledPartyNumber = '255901652222'	or CalledPartyNumber = '255901653333')
	--		or (CalledPartyNumber = '255901900900' or CalledPartyNumber = '255901656667')) THEN '6'
	--	  ELSE LEFT(RIGHT(CalledCellID,9) ,4) + '' + RIGHT(CalledCellID,4)
	-- END) end AS [BTS_KEY_LKP_CALLED]

	 /*HOME SERVICE PROVIDER KEY
	 The case statement below determines the Home Service Provider Short Name using the columns 
	 NPFLAG, CalledPartyNumber, NPPrefix, CallType, NPFlag, OpposeNumberType and DailedNumber. 
	 The value returned is then looked up against [dbo].[HM_SVC_PVDR_DIM] on HSP_SVC_PVDR_SH_NM to return
	 the HM_SVC_PVDER_KEY*/

   ,CONVERT(varchar(30),(Case  
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2359') then 'MOOV'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2356') then 'AIRTEL'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2357') then 'SALAM'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,6) = '235223') then 'TAWALI SEMI MOBILE'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,6) in ('235227','235228')) then 'TAWALI MOBILE'
			  when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,7) in ('2352250','2352251','2352252','2352253','2352268','2352269')) then 'SOTEL FIXE'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,4)  = '2359') then 'MOOV'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,4)  = '2356') then 'AIRTEL'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,4) = '2357') then 'SALAM'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,6) = '235223') then 'TAWALI SEMI MOBILE'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,6) in ('235227','235228')) then 'TAWALI MOBILE'
			  when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,7) in ('2352250','2352251','2352252','2352253','2352268','2352269')) then 'SOTEL FIXE'
			  --when CallType ='3' and RoamState <>'3' then 'IDD'
			  --when CallType ='0' and RoamState='3' then 'ONNET ROAMING'
			  --when CallType ='3' and RoamState='3' then 'IDD ROAMING'
			  when(CallType ='0' and ServiceFlow ='2' and RoamState='0' and  CallingHomeCountryCode in('235','-1')) and (( left(CallingPartyNumber,4) not in ('2359','2356','2357') and 
										left(CallingPartyNumber,6) not in ('235223','235227','235228','235555') and 
										left(CallingPartyNumber,7) not in ('2352252','2352251','2352253','2352250','2352268','2352269'))) then 'MOOV'
			  --when(CallType ='0' and ServiceFlow ='2' and RoamState ='0' and  CallingHomeCountryCode not in ('235','-1')) and (( left(CallingPartyNumber,4) not in ('2359','2356','2357') and 
					--					left(CallingPartyNumber,6) not in ('235223','235227','235228','235555') and 
					--					left(CallingPartyNumber,7) not in ('2352252','2352251','2352253','2352250','2352268','2352269'))) then 'IDD'
			  when ServiceFlow ='1' and (left(CalledPartyNumber,6) = '235444' or left(CalledPartyNumber,3) = '444') then 'MOOV'
			  when ServiceFlow ='2' and  left(CallingPartyNumber,6) ='235444' then 'MOOV'
			  when ServiceFlow ='1' and (left(CalledPartyNumber,7) = '2358888' or left(CalledPartyNumber,4) = '8888') then 'MOOV'
			  when ServiceFlow ='1' and  CalledPartyNumber = '235223'  then 'MOBILE RADIO'
			  when ServiceFlow ='1' and  CalledPartyNumber in('2354040','235255')  then 'CALL CENTER'
			  when ServiceFlow ='1' and  CalledPartyNumber = '2351101'  then 'FONDATION GRAND COEUR'
			  when ServiceFlow ='2' and  left(CallingPartyNumber,7)='2358888' then 'MOOV'when (ServiceFlow ='2' and CallType ='0' and RoamState ='0') and left(CallingPartyNumber,6)='235555' then 'MOOV'
			  when(ServiceFlow ='1' and  CallType ='0' and RoamState ='0') and (left(CalledPartyNumber,6)='235555' and left(CallingPartyNumber,4)='2359') then 'MOOV'
			  else 'HOME SERVICE - OTHERS'
		End)) AS HSP_SHRT_NM_LKP

	/*SERVICE KEY
	The case statement below determines the Service code using the columns 
	NPPFLAG, CalledPartyNumber, NPPrefix, CallType, OpposeNumberType and Dialed Number.
	The value returned is then looked up against [dbo].[SVC_DIM] on UNQ_CD_SRC_STM
	to return the SVC_KEY*/
  
		,CONVERT(varchar(20),(CASE 
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
	  (CASE when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,4) = '2359') THEN 'SC-2'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,4) = '2356') THEN 'SC-3'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,4) = '2357') THEN 'SC-5'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,6) = '235223')THEN 'SC-9'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,6) in ('235227','235228'))THEN 'SC-6'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,7) in ('2352250','2352251','2352252','2352253','2352268','2352269'))	THEN 'SC-8'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2359') THEN 'SC-1'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2356')	THEN 'SC-4'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2357')	THEN 'SC-14'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,6) = '235223')	THEN 'SC-30'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,6) in ('235227','235228'))	THEN 'SC-7'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber)> 7 and left(CalledPartyNumber,7) in ('2352250','2352251','2352252','2352253','2352268','2352269'))	THEN 'SC-29'
			--when ServiceFlow = '2' and CallType ='3' and RoamState <>'3' then 'SC-0012'
			--when ServiceFlow = '2' and CallType ='0' and RoamState = '3' then 'SC-0013'
			--when ServiceFlow = '2' and CallType ='3' and RoamState = '3' then 'SC-0014'
			--when ServiceFlow = '1' and CallType ='3' and RoamState <>'3' then 'SC-0015'
			--when ServiceFlow = '1' and CallType ='0' and RoamState = '3' then 'SC-0016'
			--when ServiceFlow = '1' and CallType ='3' and RoamState = '3' then 'SC-0017'
			  END)																								
	  ELSE
	  (CASE when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,4) = '2359') THEN 'SC-4133'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,4) = '2356') THEN 'SC-301'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,4) = '2357') THEN 'SC-13'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,6) = '235223')THEN 'SC-307'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber) > 7 and left(CallingPartyNumber,6) in ('235227','235228'))THEN 'SC-11'
			when CallType<>'3' and ServiceFlow ='2' and (len(CallingPartyNumber)> 7 and left(CallingPartyNumber,7) in ('2352250','2352251','2352252','2352253','2352268','2352269'))	THEN 'SC-306'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2359') THEN 'SC-4133'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2356')	THEN 'SC-301'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,4) = '2357')	THEN 'SC-13'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,6) = '235223')	THEN 'SC-307'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber) > 7 and left(CalledPartyNumber,6) in ('235227','235228'))	THEN 'SC-11'
			when CallType<>'3' and ServiceFlow ='1' and (len(CalledPartyNumber)> 7 and left(CalledPartyNumber,7) in ('2352250','2352251','2352252','2352253','2352268','2352269'))	THEN 'SC-306'
			--when ServiceFlow = '2' and CallType ='3' and RoamState <>'3' then 'SC-0012'
			--when ServiceFlow = '2' and CallType ='0' and RoamState = '3' then 'SC-0013'
			--when ServiceFlow = '2' and CallType ='3' and RoamState = '3' then 'SC-0014'
			--when ServiceFlow = '1' and CallType ='3' and RoamState <>'3' then 'SC-0015'
			--when ServiceFlow = '1' and CallType ='0' and RoamState = '3' then 'SC-0016'
			--when ServiceFlow = '1' and CallType ='3' and RoamState = '3' then 'SC-0017'
			  END)
	  END)END)) AS 'SVC_KEY_LKP'

	  ,serviceFlow ChargePartyIndicator
			  ,Case	when ServiceFlow ='1' and RoamState ='3' then 'VOICE-ROAMING_MO'
			when ServiceFlow ='2' and RoamState ='3' then 'VOICE-ROAMING_MT'
			when (CallType ='0' and RoamState ='0' and ServiceFlow ='2' )  and  CallingHomeCountryCode not in ('235','-1') then 'VOICE INCOMING IDD' 
	   End AS																		SVC_TP_NM
			  
/*==================================================IVR==================================================*/

			  /* The below logic is the begining of the logic to implement for IVR */

			   ,CalledPartyNumber  SVC_IVR_LKP
			   ,CallType
			   			   
/*==================================================IVR==================================================*/

	/*SERVICE KEY (INTERNATIONAL CALLS)
	The case statement below returns the left 2 or left 4 digits of the CalledPartyNumber 
	for International Calls. The value returned is then looked up against [dbo].[COUNTRY_CODES]
	on AREA_CODE and returns the Country. The Country is then looked up against the 
	[dbo].[SVC_DIM] on SVC_NM to return the SVC_KEY*/
    ,(CASE 
			WHEN CallType = 3 THEN
			(CASE 
				WHEN LEFT(LTRIM(CalledHomeCountryCode), 1) = 1 THEN CAST(LEFT(CalledPartyNumber, 4) AS INT)
				WHEN LEFT(LTRIM(CalledHomeCountryCode), 1) = 7 THEN CAST(LEFT(CalledPartyNumber, 2) AS INT)
				ELSE CAST(LTRIM(CalledHomeCountryCode) AS INT)
				END) 
			ELSE
			(CASE
				WHEN (CallType ='0' and RoamState ='0' and ServiceFlow ='2' )  and  CallingHomeCountryCode not in ('235','-1') THEN CAST(LTRIM(CallingHomeCountryCode) AS INT)
			END)
	  END) AS 'CTY_LKP'
  ,RIGHT(RTRIM(PRI_IDENTITY),8) AS MSISDN_DD,
  OBJ_ID AS SubscriberKey
  , TRY_CONVERT(VARCHAR(50), [MainOfferingID]) AS Pln_Key_Lkp
  , LastEffectOffering AS Prd_Key_Lkp
  , Case when ServiceFlow ='1' then 'Voice-Outgoing'
		    when ServiceFlow ='2' then 'Voice-Incoming'
			when ServiceFlow ='3' then 'Transit Calls Outgoing'
			else 'Unknown'
	   End AS ServiceUsageActivity
  , CAST((CASE WHEN [TerminationReason] = '0' THEN 'Successful'
		  ELSE 'Failure'
	 END) AS VARCHAR(10)) AS ServiceUsageCompletionStatus
  , '-1' AS MSC_ID
  , (CASE   WHEN [TerminationReason] = '0' THEN 'Successful'
		    WHEN [TerminationReason] = '1' THEN 'Unallocated (unassigned) number'
		    WHEN [TerminationReason] = '2' THEN 'No route to specified transit network'
		    WHEN [TerminationReason] = '3' THEN 'No route to destination'
		    WHEN [TerminationReason] = '4' THEN 'Send special information tone'
		    WHEN [TerminationReason] = '5' THEN 'Misdia lled trunk prefix'
		    WHEN [TerminationReason] = '6' THEN 'Channel unacceptable'
		    WHEN [TerminationReason] = '7' THEN 'Call awarded and being delivered in an established channel'
		    WHEN [TerminationReason] = '8' THEN 'Preemption'
		    WHEN [TerminationReason] = '9' THEN 'Preemption - circuit reserved for reuse'
		    WHEN [TerminationReason] = '16' THEN 'Normal call clearing'
		    WHEN [TerminationReason] = '16' THEN 'Normal call clearing'
			WHEN [TerminationReason] = '17' THEN 'User busy'
			WHEN [TerminationReason] = '18' THEN 'No user responding'
			WHEN [TerminationReason] = '19' THEN 'No answer from user (user alerted)'
			WHEN [TerminationReason] = '20' THEN 'Subscriber absent'
			WHEN [TerminationReason] = '21' THEN 'Call rejected'
			WHEN [TerminationReason] = '22' THEN 'Number changed'
			WHEN [TerminationReason] = '23' THEN 'Redirection to new destination'
			WHEN [TerminationReason] = '25' THEN 'Exchange routing error'
			WHEN [TerminationReason] = '26' THEN 'Non-selected user clearing'
			WHEN [TerminationReason] = '27' THEN 'Destination out of order'
			WHEN [TerminationReason] = '28' THEN 'Invalid number format (address incomplete)'
			WHEN [TerminationReason] = '29' THEN 'Facility rejected'
			WHEN [TerminationReason] = '30' THEN 'Response to STATUS ENQUIRY'
			WHEN [TerminationReason] = '31' THEN 'Normal, unspecified'
			WHEN [TerminationReason] = '34' THEN 'No circuit/channel available'
			WHEN [TerminationReason] = '38' THEN 'Network out of order'
			WHEN [TerminationReason] = '39' THEN 'Permanent frame mode connection out of service'
			WHEN [TerminationReason] = '40' THEN 'Permanent frame mode connection operational'
			WHEN [TerminationReason] = '41' THEN 'Temporary failure'
			WHEN [TerminationReason] = '42' THEN 'Switching equipment congestion'
			WHEN [TerminationReason] = '43' THEN 'Access information discarded'
			WHEN [TerminationReason] = '44' THEN 'Requested circuit/channel not available'
			WHEN [TerminationReason] = '46' THEN 'Precedence call blocked'
			WHEN [TerminationReason] = '47' THEN 'Resource unavailable, unspecified'
			WHEN [TerminationReason] = '49' THEN 'Quality of service not available'
			WHEN [TerminationReason] = '50' THEN 'Requested facility not subscribed'
			WHEN [TerminationReason] = '53' THEN 'Outgoing calls barred within CUG'
			WHEN [TerminationReason] = '55' THEN 'Incoming calls barred within CUG'
			WHEN [TerminationReason] = '57' THEN 'Bearer capability not authorized'
			WHEN [TerminationReason] = '58' THEN 'Bearer capability not presently available'
			WHEN [TerminationReason] = '62' THEN 'Inconsistency in designated outgoing access information and subscriber class'
			WHEN [TerminationReason] = '63' THEN 'Service or option not available, unspecified'
			WHEN [TerminationReason] = '65' THEN 'Bearer capability not implemented'
			WHEN [TerminationReason] = '66' THEN 'Channel type not implemented'
			WHEN [TerminationReason] = '69' THEN 'Requested facility not implemented'
			WHEN [TerminationReason] = '70' THEN 'Only restricted digital information bearer capability is available'
			WHEN [TerminationReason] = '79' THEN 'Service or option not implemented, unspecified'
			WHEN [TerminationReason] = '81' THEN 'Invalid call reference value'
			WHEN [TerminationReason] = '82' THEN 'Identified channel does not exist'
			WHEN [TerminationReason] = '83' THEN 'A suspended call exists, but this call identity does not'
			WHEN [TerminationReason] = '84' THEN 'Call identity in use'
			WHEN [TerminationReason] = '85' THEN 'No call suspended'
			WHEN [TerminationReason] = '86' THEN 'Call having the requested call identity has been cleared'
			WHEN [TerminationReason] = '87' THEN 'User not member of CUG'
			WHEN [TerminationReason] = '88' THEN 'Incompatible destination'
			WHEN [TerminationReason] = '90' THEN 'Non-existent CUG'
			WHEN [TerminationReason] = '91' THEN 'Invalid transit network selection'
			WHEN [TerminationReason] = '95' THEN 'Invalid message, unspecified'
			WHEN [TerminationReason] = '96' THEN 'Mandatory information element is missing'
			WHEN [TerminationReason] = '97' THEN 'Message type non-existent or not implemented'
			WHEN [TerminationReason] = '98' THEN 'Message not compatible with call state or message type non-existent or not implemented'
			WHEN [TerminationReason] = '99' THEN 'Information element /parameter nonexistent or not implemented'
			WHEN [TerminationReason] = '100' THEN 'Invalid information element contents'
			WHEN [TerminationReason] = '101' THEN 'Message not compatible with call state'
			WHEN [TerminationReason] = '102' THEN 'Recovery on timer expiry'
			WHEN [TerminationReason] = '103' THEN 'Parameter non-existent or not implemented, passed on'
			WHEN [TerminationReason] = '110' THEN 'Message with unrecognized parameter, discarded'
			WHEN [TerminationReason] = '111' THEN 'Protocol error, unspecified'
			WHEN [TerminationReason] = '127' THEN 'Interworking, unspecified'
			WHEN [TerminationReason] = '128' THEN 'EDP oNotRechable'
			WHEN [TerminationReason] = '129' THEN 'case of MF'
		  ELSE 'UNKNOWN'
	 END) AS ServiceUsageCompletionReason
  , case when paytype = 0 then 'PREPAID'
		 when paytype = 1 then 'POSTPAID'
		 when paytype = 2 then 'HYBRID' end AS BS_LN_KEY_LKP
 
	 , CAST(
		CASE	WHEN  LTRIM(RTRIM(replace(replace(replace(convert(varchar(30),[CUST_LOCAL_START_DATE], 20),'-',''),':',''),' ',''))) = '' THEN '19000101'
				ELSE LEFT(replace(replace(replace(convert(varchar(30),[CUST_LOCAL_START_DATE], 20),'-',''),':',''),' ',''), 8) 
		END	AS VARCHAR(8))														 AS BGN_EV_DT_KEY_LKP  
  , CAST(
		CASE	WHEN LTRIM(RTRIM(replace(replace(replace(convert(varchar(30),[CUST_LOCAL_START_DATE], 20),'-',''),':',''),' ',''))) = '' THEN '-1'
				ELSE RIGHT(REPLACE(convert(varchar(20), CUST_LOCAL_START_DATE,108),':',''),6)
		END AS VARCHAR(6))														AS BGN_EV_TM_KEY_LKP

		,CAST(
		CASE	WHEN  LTRIM(RTRIM(replace(replace(replace(convert(varchar(30),[CUST_LOCAL_END_DATE], 20),'-',''),':',''),' ',''))) = '' THEN '19000101'
				ELSE LEFT(replace(replace(replace(convert(varchar(30),[CUST_LOCAL_END_DATE], 20),'-',''),':',''),' ',''), 8) 
		END	AS VARCHAR(8))														AS END_EV_DT_KEY_LKP
  
  , CAST(
		CASE	WHEN LTRIM(RTRIM(replace(replace(replace(convert(varchar(30),[CUST_LOCAL_END_DATE], 20),'-',''),':',''),' ',''))) = '' THEN '-1'
				ELSE RIGHT(REPLACE(convert(varchar(20), [CUST_LOCAL_END_DATE],108),':',''),6)
		END AS VARCHAR(6))																												AS END_EV_TM_KEY_LKP
  , COALESCE(CAST(DEBIT_FROM_PREPAID AS NUMERIC(18, 4)) / 100,0) AS ChargeFromPrepaid

  /*BILL AMOUNT
  The case statements below determine the value of each ChargeAmount column.
  If the AccountType is equal to 2001 we take the value of the ChargeAmount column,
  if the AccountType is not equal to 2001 we take a value of $0. Inside the SSIS 
  package these values are added together with the ChargedFromPrepaid Column
  to determine the total BillAmount.*/
  , CASE WHEN OBJECT_TYPE_ID1  = '2000' THEN CAST(CHG_AMOUNT1 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount1,
    CASE WHEN OBJECT_TYPE_ID2  = '2000' THEN CAST(CHG_AMOUNT2 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount2,
	CASE WHEN OBJECT_TYPE_ID3  = '2000' THEN CAST(CHG_AMOUNT3 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount3,
	CASE WHEN OBJECT_TYPE_ID4  = '2000' THEN CAST(CHG_AMOUNT4 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount4,
	CASE WHEN OBJECT_TYPE_ID5  = '2000' THEN CAST(CHG_AMOUNT5 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount5,
	CASE WHEN OBJECT_TYPE_ID6  = '2000' THEN CAST(CHG_AMOUNT6 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount6,
	CASE WHEN OBJECT_TYPE_ID7  = '2000' THEN CAST(CHG_AMOUNT7 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount7,
	CASE WHEN OBJECT_TYPE_ID8  = '2000' THEN CAST(CHG_AMOUNT8 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount8,
	CASE WHEN OBJECT_TYPE_ID9  = '2000' THEN CAST(CHG_AMOUNT9 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount9,
	CASE WHEN OBJECT_TYPE_ID10 = '2000' THEN CAST(CHG_AMOUNT10 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount10,
	CASE WHEN OBJECT_TYPE_ID11  = '2000' THEN CAST(CHG_AMOUNT11 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount11,
	CASE WHEN OBJECT_TYPE_ID12  = '2000' THEN CAST(CHG_AMOUNT12 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount12,
	CASE WHEN OBJECT_TYPE_ID13  = '2000' THEN CAST(CHG_AMOUNT13 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount13,
	CASE WHEN OBJECT_TYPE_ID14 = '2000' THEN CAST(CHG_AMOUNT14 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount14,
	CASE WHEN OBJECT_TYPE_ID15 = '2000' THEN CAST(CHG_AMOUNT15 AS NUMERIC(18,4)) / 100 ELSE 0 END AS ChargeAmount15
  , COALESCE(CAST(DEBIT_AMOUNT AS NUMERIC(18, 4)) / 100, 0) AS ChargeOfFundAccounts
  , CONVERT(NUMERIC(18, 4), 0) AS [BILL_0_W_IDR_REV_DRTN]
  , (CASE WHEN OBJECT_TYPE_ID1 = 0
			   AND RATE_USAGE = 0
		  THEN CAST(ACTUAL_USAGE AS NUMERIC(18, 4))
		  ELSE '0'
	 END) AS [BILL_0_WOUT_REV_DRTN],
	 
	 /* Revenue is defined based on the Paytype to differentiate Prepaid/Postpaid/Hybrid revenue */

	 case paytype 
 when 0 then -- CAST(DEBIT_FROM_PREPAID as numeric(18,4))/100 + 
       (case WHEN OBJECT_TYPE_ID1 in ('2000') then CAST(CHG_AMOUNT1 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID2 in ('2000') then CAST(CHG_AMOUNT2 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID3 in ('2000') then CAST(CHG_AMOUNT3 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID4 in ('2000') then CAST(CHG_AMOUNT4 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID5 in ('2000') then CAST(CHG_AMOUNT5 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID6 in ('2000') then CAST(CHG_AMOUNT6 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID7 in ('2000') then CAST(CHG_AMOUNT7 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID8 in ('2000') then CAST(CHG_AMOUNT8 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID9 in ('2000') then CAST(CHG_AMOUNT9 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID10 in ('2000') then CAST(CHG_AMOUNT10 AS NUMERIC(18,4)) / 100 else 0 end +
		 case WHEN OBJECT_TYPE_ID11 in ('2000') then CAST(CHG_AMOUNT11 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID12 in ('2000') then CAST(CHG_AMOUNT12 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID13 in ('2000') then CAST(CHG_AMOUNT13 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID14 in ('2000') then CAST(CHG_AMOUNT14 AS NUMERIC(18,4)) / 100 else 0 end +
		case WHEN OBJECT_TYPE_ID15 in ('2000') then CAST(CHG_AMOUNT15 AS NUMERIC(18,4)) / 100 else 0 end)
 when 1 then CAST(DEBIT_FROM_POSTPAID as numeric(18,4))/100 
 when 2 then --CAST(DEBIT_FROM_PREPAID as numeric(18,4))/100 +
	    case WHEN OBJECT_TYPE_ID1 in('2000') then CAST(CHG_AMOUNT1 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID2 in('2000') then CAST(CHG_AMOUNT2 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID3 in('2000') then CAST(CHG_AMOUNT3 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID4 in('2000') then CAST(CHG_AMOUNT4 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID5 in('2000') then CAST(CHG_AMOUNT5 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID6 in('2000') then CAST(CHG_AMOUNT6 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID7 in('2000') then CAST(CHG_AMOUNT7 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID8 in('2000') then CAST(CHG_AMOUNT8 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID9 in('2000') then CAST(CHG_AMOUNT9 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID10 in('2000') then CAST(CHG_AMOUNT10 AS NUMERIC(18,4)) / 100 else 0 end +
		case WHEN OBJECT_TYPE_ID11 in('2000') then CAST(CHG_AMOUNT11 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID12 in('2000') then CAST(CHG_AMOUNT12 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID13 in('2000') then CAST(CHG_AMOUNT13 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID14 in('2000') then CAST(CHG_AMOUNT14 AS NUMERIC(18,4)) / 100 else 0 end +
		case WHEN OBJECT_TYPE_ID15 in('2000') then CAST(CHG_AMOUNT15 AS NUMERIC(18,4)) / 100 else 0 end
	end as REVENUE

	/*Wallet Amount 1 is the  core wallet of all hte business line*/
	,case paytype 
	when 0 then 
		case WHEN OBJECT_TYPE_ID1 in('2530') then CAST(CHG_AMOUNT1 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID2 in('2530') then CAST(CHG_AMOUNT2 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID3 in('2530') then CAST(CHG_AMOUNT3 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID4 in('2530') then CAST(CHG_AMOUNT4 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID5 in('2530') then CAST(CHG_AMOUNT5 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID6 in('2530') then CAST(CHG_AMOUNT6 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID7 in('2530') then CAST(CHG_AMOUNT7 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID8 in('2530') then CAST(CHG_AMOUNT8 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID9 in('2530') then CAST(CHG_AMOUNT9 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID10 in('2530') then CAST(CHG_AMOUNT10 AS NUMERIC(18,4)) / 100 else 0 end +
		case WHEN OBJECT_TYPE_ID11 in('2530') then CAST(CHG_AMOUNT11 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID12 in('2530') then CAST(CHG_AMOUNT12 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID13 in('2530') then CAST(CHG_AMOUNT13 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID14 in('2530') then CAST(CHG_AMOUNT14 AS NUMERIC(18,4)) / 100 else 0 end +
		case WHEN OBJECT_TYPE_ID15 in('2530') then CAST(CHG_AMOUNT15 AS NUMERIC(18,4)) / 100 else 0 end

	when 1 then CAST(DEBIT_FROM_POSTPAID as numeric(18,4))/100
	 
	when 2 then CAST(DEBIT_FROM_PREPAID as numeric(18,4))/100 +
	    case WHEN OBJECT_TYPE_ID1 in('2530') then CAST(CHG_AMOUNT1 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID2 in('2530') then CAST(CHG_AMOUNT2 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID3 in('2530') then CAST(CHG_AMOUNT3 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID4 in('2530') then CAST(CHG_AMOUNT4 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID5 in('2530') then CAST(CHG_AMOUNT5 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID6 in('2530') then CAST(CHG_AMOUNT6 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID7 in('2530') then CAST(CHG_AMOUNT7 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID8 in('2530') then CAST(CHG_AMOUNT8 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID9 in('2530') then CAST(CHG_AMOUNT9 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID10 in('2530') then CAST(CHG_AMOUNT10 AS NUMERIC(18,4)) / 100 else 0 end +
		case WHEN OBJECT_TYPE_ID11 in('2530') then CAST(CHG_AMOUNT11 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID12 in('2530') then CAST(CHG_AMOUNT12 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID13 in('2530') then CAST(CHG_AMOUNT13 AS NUMERIC(18,4)) / 100 else 0 end +
        case WHEN OBJECT_TYPE_ID14 in('2530') then CAST(CHG_AMOUNT14 AS NUMERIC(18,4)) / 100 else 0 end +
		case WHEN OBJECT_TYPE_ID15 in('2530') then CAST(CHG_AMOUNT15 AS NUMERIC(18,4)) / 100 else 0 end
	end as WLT_AMNT1

	/*Wallet Amount 2 is the  other wallet amount apart from the core wallet of all hte business line*/
	,case paytype 
		when 0 then 
			case WHEN OBJECT_TYPE_ID1 not in ('2000','2530') then CAST(CHG_AMOUNT1 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID2 not in ('2000','2530') then CAST(CHG_AMOUNT2 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID3 not in ('2000','2530') then CAST(CHG_AMOUNT3 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID4 not in ('2000','2530') then CAST(CHG_AMOUNT4 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID5 not in ('2000','2530') then CAST(CHG_AMOUNT5 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID6 not in ('2000','2530') then CAST(CHG_AMOUNT6 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID7 not in ('2000','2530') then CAST(CHG_AMOUNT7 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID8 not in ('2000','2530') then CAST(CHG_AMOUNT8 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID9 not in ('2000','2530') then CAST(CHG_AMOUNT9 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID10 not in ('2000','2530') then CAST(CHG_AMOUNT10 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID11 not in ('2000','2530') then CAST(CHG_AMOUNT11 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID12 not in ('2000','2530') then CAST(CHG_AMOUNT12 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID13 not in ('2000','2530') then CAST(CHG_AMOUNT13 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID14 not in ('2000','2530') then CAST(CHG_AMOUNT14 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID15 not in ('2000','2530') then CAST(CHG_AMOUNT15 AS NUMERIC(18,4)) / 100 else 0 end

		when 1 then 0
	 
		when 2 then 
			case WHEN OBJECT_TYPE_ID1 not in ('2000','2530') then CAST(CHG_AMOUNT1 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID2 not in ('2000','2530') then CAST(CHG_AMOUNT2 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID3 not in ('2000','2530') then CAST(CHG_AMOUNT3 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID4 not in ('2000','2530') then CAST(CHG_AMOUNT4 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID5 not in ('2000','2530') then CAST(CHG_AMOUNT5 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID6 not in ('2000','2530') then CAST(CHG_AMOUNT6 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID7 not in ('2000','2530') then CAST(CHG_AMOUNT7 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID8 not in ('2000','2530') then CAST(CHG_AMOUNT8 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID9 not in ('2000','2530') then CAST(CHG_AMOUNT9 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID10 not in ('2000','2530') then CAST(CHG_AMOUNT10 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID11 not in ('2000','2530') then CAST(CHG_AMOUNT11 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID12 not in ('2000','2530') then CAST(CHG_AMOUNT12 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID13 not in ('2000','2530') then CAST(CHG_AMOUNT13 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID14 not in ('2000','2530') then CAST(CHG_AMOUNT14 AS NUMERIC(18,4)) / 100 else 0 end +
			case WHEN OBJECT_TYPE_ID15 not in ('2000','2530') then CAST(CHG_AMOUNT15 AS NUMERIC(18,4)) / 100 else 0 end
		end as WLT_AMNT2
	, CONVERT(VARCHAR(20),CallingCellID) AS CallingCellID_DD
	, CONVERT(VARCHAR(20),CalledCellID) AS CalledCellID_DD
into #cbsrec
FROM
	dbo.CBSREC with (nolock)
WHERE
	 PPN_DT = @PPN_DT
	 AND RATE_USAGE IS NOT NULL
	 AND (DateEntered is NULL OR (DateEntered >=@LastLoadDate and DateEntered < @SystemStartTime))


	 select * from #cbsrec
	 where SVC_KEY_LKP is null
	 and ChargePartyIndicator = 1
	 and calltype <> 3
	 and HSP_SHRT_NM_LKP NOT IN ('MOBILE RADIO','CALL CENTER')
	 and SVC_TP_NM is null
	 and ORIG_NBR_DD <> TMT_NBR_DD
	 and REVENUE > 0

