@Echo off

FOR /L %%i IN (1, 1, %1) DO (
	Echo Spawning thread %%i
	START "Worker%%i" /Min DTEXEC /ISSERVER "\SSISDB\Analytics\Staging\Stage_CBSTAG.dtsx" /SERVER "%2" /Par "$Package::ETLBatchID(int32)";%3 /Par "$Package::PPN_DT(DateTime)";%4 /Par "$ServerOption::SYNCHRONIZED(Boolean)";True
	Timeout 1


)