$serverInstanceParam = 'SrvBI01'
$databaseParam = 'AnalyticsAuditing'

$queryParam = "SELECT DISTINCT process_id,kill_operation FROM [master].[dbo].[vw_Running_Operations] where DATEDIFF(MI,created_time,getdate()) > 30 and package_name = 'Stage_Zip_Extract_GZ.dtsx'"

$sqlOutput = Invoke-Sqlcmd -ServerInstance $serverInstanceParam -Database $databaseParam -Query $queryParam -QueryTimeout 900

if ( $sqlOutput -ne $null )
    {

$sqlOutput.process_id | %{ Stop-Process $_ }
Stop-Process -Name 'WinRaR' -Force

$sqlOutput.kill_operation | %{ Invoke-Sqlcmd -ServerInstance $serverInstanceParam -Database $databaseParam -Query $_ -QueryTimeout 900 }

    }