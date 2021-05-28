. "..\include\_Public_Api.ps1";
. "..\include\_Internal_Api.ps1";
. "..\include\_TestTools.ps1";

# Ensure KYP is running locally if connecting to localhost!
Select-Target -Deployment "localhost"; #"indigo"; 

# Login as GBG Product Manager
Get-SsoToken -LoginAs Kyp -Username "GbgProductManager@product.int" -Password "P@55w0rd";

$timecode = Get-Timecode;
$firstName = 'John';
$lastName = 'Smith';
$email = "$firstName$lastname$timecode@test.com".ToLower();

$response = Create-User -FirstName $firstName -LastName $lastName -Email $email -IsInternal 0 -CustomerShortcode 'CUS-CMBF0143';
Assert-Response -StdResponseData $response -ExpectedResponseCode 201;
