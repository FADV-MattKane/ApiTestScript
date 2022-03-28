. "..\include\_Public_Api.ps1";
Select-Target -Deployment "localhost"; # blue, red, cyan, releasetest etc

$tok = Get-SsoToken -LoginAs Kyp -Username "GbgProductManager@product.int" -Password "P@55w0rd"; 

#HttpPost -Path "/api/branding/initialise" -Body "{}";
HttpPost -Path "/api/branding/regenerate?hostname=_all_" -Body "{}";
