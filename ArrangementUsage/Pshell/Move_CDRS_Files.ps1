$source = 'A:\CDR'

$serverInstanceParam = 'SrvBI01'
$databaseParam = 'AnalyticsStaging'
$pref = 'CBS-'

$streams = @{
                REC = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\REC"
                SMS = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\SMS"
                DATA = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\DATA"
                MON = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\MON"
                MGR = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\MGR"
                VOU = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\VOU"
               #COM = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\COM"
               #CLR = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\CLR"
               #LOAN = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\LOAN"
                SCT = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\SCT"
              <#MMS = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\MMS"
                EVCNDISTRIBUTE = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\EVCDISTRIBUTE"
                EVCNTRA = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\EVCTRA"
                EVCNREC = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\EVCREC"
                EVCMODEVENT = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\EVCEVENT"
                EVCIDFULLOP = "D:\SRC_DATA\WORK_FOLDER\CBS\CDR\EVCIDFULLOP"
                EVCBALANCE = "D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\EVCBALANCE"#>

            }

$streams.keys | %{
                       $queryParam ="SELECT reverse(LEFT(reverse(FilePath),charindex('\',reverse(FilePath))-1)) Filename
                                    FROM AnalyticsStaging.etl.TaskQueue WHERE sourcesystem = '$pref$_' and status = 3"
                   
                       $SQLOutput_Hash =  Invoke-Sqlcmd -ServerInstance $serverInstanceParam -Database $databaseParam -Query $queryParam -QueryTimeout 900 | Select -ExcludeProperty FileName,cbp

                       $Destination = $streams[$_]
                       $filter = "*" + $_.ToString().ToLower() + "*.unl"
                   
                           Get-ChildItem $source -Recurse -Filter $filter  |
                           %{
                                if ($SQLOutput_Hash -notcontains $_.Name )
                                    {
                                        Move-Item -Path $_.FullName -Destination $Destination -Force
                                        #Write-Host $_.FullName
                                    }
                             }
                 }

