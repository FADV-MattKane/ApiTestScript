. "..\include\_Public_Api.ps1";
Select-Target -Deployment "localhost"; # blue, red, cyan, releasetest etc

#Get-SsoToken -LoginAs Kyp -Username "ace.rimmer@reddwarf.co.uk" -Password "Smegma123!";
Get-SsoToken -LoginAs Kyp -Username "bill.bloggs@test.com" -Password "Smegma123!";

$call = HttpPost -Path "/api/application/search" -Body "{ filter: { myApplications: true }, includeTotalCount: true }";

Write-Output "Status Code: HTTP $($call.statusCode)";
Write-Output "Count returned: $($call.result.results.Length) results (of $($call.result.total) total)";
Write-Output "Results" $call.result.results | Select-Object ;
