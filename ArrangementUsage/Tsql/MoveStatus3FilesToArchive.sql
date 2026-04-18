select a.dateentered,a.filepath ,a.status,'move /Y ' + Filepath + ' ' +  b.archivedirectory + '\' + convert(varchar(10),a.datecompleted,121) + '\'
from etl.TaskQueue a inner join etl.SourcesystemProcessing b on a.sourcesystem = b.sourcesystem
where a.sourcesystem = 'CBS-clr'
and a.status = 3
--and a.ppn_dt >= '8/1/2021'
and a.filepath like '%clr_107_172_00101_20210730000711_28460.unl%'