. "..\include\_Public_Api.ps1";
Select-Target -Deployment "magenta"; # blue, red, cyan, releasetest etc
$tok = Get-SsoToken -LoginAs Kyp -Username "all@test.com" -Password "P@55w0rd"; 

$call = HttpPost -Path "/api/application/search" -Body "{ filter: { myApplications: true }, includeTotalCount: true }";

Write-Output "Status Code: HTTP $($call.statusCode)";
Write-Output "Count returned: $($call.result.results.Length) results (of $($call.result.total) total)";
Write-Output "Results:" $call.result.results | Select-Object ;
