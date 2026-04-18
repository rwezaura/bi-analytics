@Echo off

FOR /L %%i IN (1, 1, %1) DO (
	Echo Spawning thread %%i
	START "Worker%%i" /Min DTEXEC /ISSERVER "\SSISDB\Analytics\Staging\Stage_OCS_CBE_SUBSCRIBER_DYN.dtsx" /SERVER "10.1.5.175" /Par "$Package::ETLBatchID(int32)";%2 /Par "$Package::PPN_DT(DateTime)";%3 /Par "$ServerOption::SYNCHRONIZED(Boolean)";True
	Timeout 5


)