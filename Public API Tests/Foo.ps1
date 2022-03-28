. "..\include\_Public_Api.ps1";
Select-Target -Deployment "indigo"; # blue, red, cyan, releasetest etc

$tok = Get-SsoToken -LoginAs Kyp -Username "GbgProductManager@product.int" -Password "P@55w0rd"; 

# $call = HttpGet -Path "/api/organisations/ORG-QAORGB99/payments";
# Write-Output "Status Code: HTTP $($call.statusCode)";
# Write-Output "Results" $call.result | Select-Object;

$call = HttpGet -Path "/api/organisations/ORG-QAORGB/payments";
Write-Output "Status Code: HTTP $($call.statusCode)";
Write-Output "Results" $call.result | Select-Object;
