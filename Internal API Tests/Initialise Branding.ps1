. "..\include\_http.ps1";
. "..\include\_kyp.ps1";

Select-Target -Deployment "localhost"; # blue, red, cyan, releasetest etc

# Login as GBG Product Manager
Get-SsoToken -LoginAs Kyp -Username "GbgProductManager@product.int" -Password "P@55w0rd";

HttpPost -Path "/api/branding/initialise" -Body "{}";

HttpPost -Path "/api/branding/regenerate?hostname=_all_" -Body "{}";
