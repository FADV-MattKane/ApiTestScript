. "..\include\_Public_Api.ps1";
Select-Target -Deployment "localhost"; # blue, red, cyan, releasetest etc

Get-SsoToken -LoginAs Kyp -Username "ace.rimmer@reddwarf.co.uk" -Password "Smegma123!";
#$tok = Get-SsoToken -LoginAs Kyp -Username "fred.bloggs@test.com" -Password "Smegma123!"; # fails authorisation: Fred Bloggs is not a MomCorp customer

#$tok = Get-SsoToken -LoginAs Kyp -Username "GbgProductManager@product.int" -Password "P@55w0rd"; 
#$tok = Get-SsoToken -LoginAs Kyp -Username "Manager@product.int" -Password "P@55w0rd"; 

$call = HttpPost -Path "/api/application/search" -Body "{ filter: {} }";
Write-Output "Status Code: HTTP $($call.statusCode)";
Write-Output "Count returned: $($call.result.results.Length) results";
Write-Output "Results" $call.result.results | Select-Object ;
