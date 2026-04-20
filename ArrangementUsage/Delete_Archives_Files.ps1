
Get-ChildItem D:\SRC_DATA\ARC_FOLDER\CBS\CDR -Recurse -File -Filter "*.unl"  | %{ Remove-Item $_.FullName }

Get-ChildItem D:\SRC_DATA\ARC_FOLDER\CBS\DUMP -Recurse -File -Filter "*.unl"  | %{ Remove-Item $_.FullName }