. "..\include\_Public_Api.ps1";
. "..\include\_Internal_Api.ps1";
. "..\include\_TestTools.ps1";

Select-Target -Deployment "blue"; #"localhost"; 

$ssoToken = Get-SsoToken -LoginAs IronGiant; # ; # has been granted the dbsscreenscrape scope

##$data = HttpGet -Path "/api/tracking/standard-enhanced?page=3&pageSize=1";
$data = HttpGet -Path "/api/tracking/standard-enhanced?pageSize=50";

$data.result.results;
$data.result.results.Length;
