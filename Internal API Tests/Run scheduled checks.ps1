. "..\include\_http.ps1";
. "..\include\_kyp.ps1";

Select-Target -Deployment "localhost"; # blue, red, cyan, releasetest etc

# Login as IronGiant. This login has the scheduling scope and is what will call the API endpoint
Get-SsoToken -LoginAs IronGiant;

HttpPost -Path "/api/scheduling/runchecks" -Body "{}";

