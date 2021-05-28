. "..\include\_Public_Api.ps1";

Select-Target -Deployment "localhost"; # blue, red, cyan, releasetest etc
Get-SsoToken -LoginAs IronGiant;
HttpGet -Path "/api/retention/run"; # should succeed