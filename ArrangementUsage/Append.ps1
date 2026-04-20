$SourceFolder = 'D:\SRC_DATA\WORK_FOLDER\CBS\DUMP\UVC_SUPPLY'
$ListOfDates = Get-ChildItem $SourceFolder -Filter "*.verf" | %{ 
                                    $BaseName = $_.BaseName
                                    $Date = $BaseName.Substring($BaseName.Length -8)
                                    echo $Date
                                 } | Sort-Object | Get-Unique

$ListOfDates = $ListOfDates.Split('`n')

    For ( $i=0;$i -lt $ListOfDates.Count; $i++ ) 
                { 
                    $Filter = "\uvc_supply*" + $ListOfDates[$i] + ".verf"
                    $Contents = Get-Content $SourceFolder$Filter
                    $DestFile = $SourceFolder + "\uvc_supply_" + $ListOfDates[$i] + ".verf"
                    Add-Content -Path $DestFile -Value $Contents
                    }
