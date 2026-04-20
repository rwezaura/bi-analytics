gci D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\VERF -File -Recurse -Filter "*_20221*.verf" | 
        %{ 
            if (-not(Test-Path D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\VERF_ARCHIVES\$_.BaseName))
                { Move-Item $_.FullName -Destination D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\VERF_ARCHIVES -Force  }
            }