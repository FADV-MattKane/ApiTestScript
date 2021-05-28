. "..\include\_Public_Api.ps1";
. "..\include\_Internal_Api.ps1";
. "..\include\_TestTools.ps1";

# Login as GBG Product Manager
Select-Target -Deployment "localhost";
$token = Get-SsoToken -LoginAs Kyp -Username "GbgProductManager_Matt@product.int" -Password "Smegma123";

$data = Create-Application -Body @"
{
    "person": "$global:_PersonId",
    
    "checks": [
        "overseas-criminal-record",
        "uk-ni-number"
    ],
    "completedBy": "Me"    
}
"@;

$shortcode = $data.result.shortcode;
$data = Submit-Application -ShortCode $shortcode -Body @"
{
    "shared": {
        "name": {
            "firstName": "Derek",
            "lastName": "Smalls"
        },
        "title": "Mr",
        "dateOfBirth": "1955-01-01",
        "gender": "Male",
        "address": {
            "country": "GB",
            "buildingNumber": "123",
            "street": "Acacia Avenue",
            "town": "Somerset",
            "postcode": "BA1 1AB"
        }
    },
    "checks": {
        "nationalInsurance": {
            "number": "AB 12 34 56 C"
        }
    }
}
"@;

# Login as MomCorp customer manager
$token = Get-SsoToken -LoginAs Kyp -Username "Manager@product.int" -Password "P@55w0rd";
# filename: "United States Overseas CR Check.pdf" id: "c3bb4518-91de-4fff-9f2d-306206016f17"
# filename: "Demo Passport.jpg" id: "85d19d1f-0463-463c-b391-cd514af14351"
$data = Verify-Application -ShortCode $shortcode -Body @"
{
    "shortcode": "$ShortCode",
    "verify": [
        {
            "id": "overseas-criminal-record",
            "accepted": "true",
            "documentIds": [
                "c3bb4518-91de-4fff-9f2d-306206016f17",
                "85d19d1f-0463-463c-b391-cd514af14351"
            ]
        }
    ]
}
"@;

# Login as GBG Product Manager
$token = Get-SsoToken -LoginAs Kyp -Username "GbgProductManager_Matt@product.int" -Password "Smegma123";
$data = Countersign-Application -ShortCode $shortcode -Body @"
{
  "shortcode" : "$ShortCode",
  "countersign" : [{
    "id" : "overseas-criminal-record",
    "accepted" : true
  }]
}
"@;

$data = Enter-OverseasCrCheck-Results -ShortCode $shortcode -Body @"
{
  "details" : "This is a test",
  "result" : "Pass"
}
"@;
