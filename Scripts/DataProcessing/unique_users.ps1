$uu=Import-Csv -Header 'datetime','username','action','playtime' -Path .\player_time.log |
    Select-Object -Unique username | 
    Format-Table -HideTableHeaders | 
    Out-String; 
$uu.Trim()
