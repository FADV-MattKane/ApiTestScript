. "..\include\_http.ps1";
. "..\include\_kyp.ps1";

Select-Target -Deployment "localhost"; # blue, red, cyan, releasetest etc
$global:_CustomerId = "A914A2CE-51B5-E511-9AAD-C4D987A1F292"; # localhost KwikEMart
Get-SsoToken -LoginAs kyp -Username "apu@kwikemart.com" -Password "Smegma123";

$httpResponse = HttpPost -Path "/api/payments/search" -Body "{}";

$httpResponse.result.results;
$httpResponse.result.results.Length;