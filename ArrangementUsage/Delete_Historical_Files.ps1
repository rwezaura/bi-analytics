get-childitem D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\ -File -Filter "*_all_202603*_*.unl" -Recurse | %{ Remove-Item $_.FullName}

get-childitem D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\ -File -Filter "*_20260415*.unl" -Recurse | %{ Move-Item -Path $_.FullName -Destination A:\archived-files\ -Force }

get-childitem D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\ -File -Filter "*_2024*.csv" -Recurse | %{ Move-Item -Path $_.FullName -Destination A:\archived-files\ -Force}

get-childitem D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\ -File -Filter "*_all_202603*_*.unl.gz" -Recurse | %{ Remove-Item $_.FullName}

get-childitem D:\SRC_DATA\WORK_FOLDER\CBS\CDR\ -File -Filter "*_20260410*.unl" -Recurse | %{ Move-Item -Path $_.FullName -Destination A:\archived-files\ -Force}

get-childitem D:\SRC_DATA\WORK_FOLDER\CBS\CDR\ -File -Filter "*_20260410*.csv" -Recurse | %{ Move-Item -Path $_.FullName -Destination A:\archived-files\ -Force}


get-childitem D:\SRC_DATA\WORK_FOLDER\CBS\CDR\ -File -Filter "*_202601*.unl" -Recurse | %{ Remove-Item $_.FullName }