$toDay =  (get-date).AddDays(-1).ToString("yyyyMMdd")
$yesterDay = (get-date).AddDays(-2).ToString("yyyyMMdd")
$dayBeforeyesterDay = (get-date).AddDays(-3).ToString("yyyyMMdd")

gci -path D:\SRC_DATA\WORK_FOLDER\CBS\DUMP -File -Recurse -Filter "*.verf"  | ?{$_ -like "*$toDay*" -or $_ -like "*$yesterDay*" -or $_ -like "*$dayBeforeyesterDay*" } |
        %{ 
            $destinationFileCheck = @(gci D:\SRC_DATA\ARC_FOLDER\CBS\DUMP\VERF -File -Recurse -Filter $_ )
           if ($destinationFileCheck.Length -eq 0) {
                   Copy-Item -Path $_.FullName -Destination D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\VERF -Force -ErrorAction SilentlyContinue
           }    
             }
