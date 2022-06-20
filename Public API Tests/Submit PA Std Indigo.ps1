. "..\include\_Public_Api.ps1";
. "..\include\_Internal_Api.ps1";
. "..\include\_TestTools.ps1";

# app must be PA std/pro1/2/3, consented by the applicant and form completed but not actually submitted
$body = @"
{
  "shared": {
    "name": {
      "firstName": "John",
      "middleNames": [],
      "lastName": "Pass"
    },
    "title": "Mr",
    "dateOfBirth": "1991-01-01",
    "gender": "MALE",
    "address": {
      "buildingName": "LITTLE HOUSE",
      "town": "CLEARBEACH",
      "city": "SOMERSET",
      "postcode": "BA1 1AB",
      "country": "GB"
    }
  },
  "checks": {
    "dbsBasic": {
      "currentAddressStartDate": "2000-01-01",
      "previousAddresses": [],
      "previousNames": {},
      "phone": "+441234567890",
      "mobile": "+449876543210",
      "email": "john@pass.com",
      "townOfBirth": "LONDON",
      "countryOfBirth": "GB",
      "niNumber": {
        "number": "AB123456C"
      },
      "profile": {
        "hasProfile": false
      },
      "consent": true,
      "receiveCertificate": false,
      "receiveCertificateAtCurrentAddress": false,
      "recipient": {
        "address": {
          "buildingName": "LITTLE HOUSE",
          "town": "CLEARBEACH",
          "city": "SOMERSET",
          "postcode": "BA1 1AB",
          "country": "GB"
        }
      }
    },
    "digitalIdentity": {
      "levelOfAssurance": {
        "level": "L1A",
        "policy": "GPG45"
      },
      "authentication": {
        "level": "HIGH",
        "policy": "GPG44"
      },
      "subjectId": "f0726cb6-97c1-4802-9feb-eb7c6cd07949",
      "currentAddressVerified": true,
      "dateOfAddressCheck": "2022-05-03",
      "identityVerified": true,
      "fraudDetected": false,
      "verifyingOrganisation": "Yoti Ltd.",
      "passport": {
        "dateOfBirth": "1991-01-01",
        "nationality": "British",
        "number": "123456789",
        "dateOfIssue": "2020-01-01"
      },
      "drivingLicence": {
        "dateOfBirth": "1991-01-01",
        "number": "FOO99701011JJ9ZM13",
        "dateOfIssue": "2020-01-01",
        "countryOfIssue": "GB"
      }
    },
    "digitalRightToWork": {    
      "levelOfAssurance": {
        "level": "M1A",
        "policy": "GPG45"
      },
      "verifyingOrganisation": "Yoti Ltd.",
      "nationality": "British",
      "_shareCode": "SHARE1234",
      "fraudDetected": false, 
      "classification": "ListA",
      "documents": [
        { 
          "documentType": "PassportBritishCitizen",
          "fileId": "270091EE-9A53-4EBF-AA52-7FC8A1A10990",
          "expiryDate": "2099-01-01",
          "documentNumber": "12345678",
          "dateOfBirth": "1991-01-01",
          "fullName": "JOHN",
          "lastName": "PASS",

          "countryOfIssue": "GB",
          "issueDate": "2020-01-02",
          "documentNumber": "123456789",
          "chipDigitalSignatureVerified": true,
          "automatedFaceMatch": true,
        },
        { 
          "documentType": "BirthCertificateUK",
          "fileId": "270091EE-9A53-4EBF-AA52-7FC8A1A10990",
          
          "countryOfIssue": "GB",
          "expiryDate": "2099-01-01",
          "issueDate": "1991-01-02",
          "documentNumber": "12345",

          "fullName": "JOHN",
          "lastName": "PASS",
          "dateOfBirth": "1991-01-01",
          "nationality": "British",
          "placeOfBirth": "London",
        },
      ]
    }
  }
}
"@;

# Submit verification documents
$vdBody = @"
{
  "verificationDocuments": [
    {
      "document": "Group1_Passport",
      "countryOfIssue": "GB",
      "dateOfBirth": "1991-01-01",
      "passportNumber": "12345678",
      "issueDate": "2020-01-01"
    },
    {
      "document": "Group1_PhotocardDrivingLicence",
      "dateOfBirth": "1991-01-01",
      "countryOfIssue": "GB",
      "drivingLicenceNumber": "PASS9901011J99ZU",
      "validFromDate": "2020-01-01"
    }
  ],
  "routeName": "route1",
  "guidelineVersion": "DbsBasicV1",
  "ukNational": true,
  "dateOfBirth": "1991-01-01"
}
"@;

Select-Target -Deployment "indigo"; # "localhost";  # blue, releasetest, red, localhost etc.
$appId = "ARBDEY6V";
$applicantSsoToken = Get-SsoToken -LoginAs Kyp -Username "john1@test.com" -Password "P@55w0rd";
$appData = Get-Application $appId;

$x = HttpPut -Path "/api/application/${appId}/verification-documents/dbs-basic" -Body $vdBody
$x;

$x = HttpPost -Path "/api/application/${appId}" -Body $body;
$x; #.result
