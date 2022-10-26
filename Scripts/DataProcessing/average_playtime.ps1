(   
Import-Csv -Header 'datetime','username','action','playtime' -Path .\player_time.log | 
Select-Object playtime | 
Where-Object playtime -gt 0 | 
Measure-Object playtime -Average
).Average
