. '..\include\_Public_Api.ps1';
. '..\include\_Internal_Api.ps1';
. '..\include\_TestTools.ps1';

Select-Target -Deployment 'localhost';  # blue, releasetest, red, localhost etc.
$prodMgrToken = Get-SsoToken -LoginAs Kyp -Username "GbgProductManager_Matt@product.int" -Password "Smegma123";

# $appData = Get-Application $appId;
# app must be PA std/pro1/2/3, consented by the applicant and form completed but not actually submitted

$appSetupBody = @{
  profile = "Bronze PA Profile"
  checks = @()
  person = "da50090b-abb9-ec11-831c-d03c1f437d5c" # John Pass in MomCorp
  completedBy = "Applicant"
  applicant = @{
      email = "john@pass.com"
  }
  tags = @()
  dbs = @{}
  verification = @{
      "availableMethods" =@("Organisation", "PostOffice")
  }
  paymentMethod = "invoiced"
} | ConvertTo-Json -Depth 10;
$appSetupResponse = HttpPost -Path "/api/application/setup" -Body $appSetupBody;
$appId = $appSetupResponse.content.shortcode;
Write-Output "Created Application $appId";

$applicantToken = Get-SsoToken -LoginAs Kyp -Username 'john@pass.com' -Password 'Smegma123!';
$x = HttpPut -Path "/api/application/$appId/verification-method" -Body '{method: "PostOffice"}';
Write-Output "Selected verification method for $appId";

$x = HttpPut -Path "/api/application/$appId/post-office-location" -Body @"
{
  "name": "Nottingham",
  "locationBusinessId": "5552273",
  "branchType": "MAIN",
  "address": {
      "address1": "124-126 Victoria Centre",
      "address4": "Nottingham",
      "address5": "Nottinghamshire",
      "latitude": 52.956,
      "longitude": -1.1479,
      "postcode": "NG1 3QD"
  }
}
"@;
Write-Output "Selected post office location for $appId";

$x = HttpPut -Path "/api/application/$appId/consent" -Body "{}";
Write-Output "Obtained consent for $appId";

$body = @{
  shared = @{
    name = @{
      firstName = 'John'
      middleNames = @()
      lastName = 'Pass'
    }
    title = 'Mr'
    dateOfBirth = '1991-01-01'
    gender = 'MALE'
    address = @{
      buildingName = 'LITTLE HOUSE'
      town = 'CLEARBEACH'
      city = 'SOMERSET'
      postcode = 'BA1 1AB'
      country = 'GB'
    }
  }
  checks = @{
    dbsBasic = @{
      currentAddressStartDate = '2000-01-01'
      previousAddresses = @()
      previousNames = @{}
      phone = '+441234567890'
      mobile = '+449876543210'
      email = 'john@pass.com'
      townOfBirth = 'LONDON'
      countryOfBirth = 'GB'
      niNumber = @{
        number = 'AB123456C'
      }
      profile = @{
        hasProfile = 'false'
      }
      consent = 'true'
      receiveCertificate = 'false'
      receiveCertificateAtCurrentAddress = 'false'
      recipient = @{
        address = @{
          buildingName = 'LITTLE HOUSE'
          town = 'CLEARBEACH'
          city = 'SOMERSET'
          postcode = 'BA1 1AB'
          country = 'GB'
        }
      }
    }
    digitalIdentity = @{
      levelOfAssurance = @{
        level = 'M1A'
        policy = 'GPG45'
      }
      authentication = @{
        level = 'HIGH'
        policy = 'GPG44'
      }
      subjectId = 'f0726cb6-97c1-4802-9feb-eb7c6cd07949'
      currentAddressVerified = 'true'
      dateOfAddressCheck = '2022-05-03'
      identityVerified = 'true'
      fraudDetected = 'false'
      verifyingOrganisation = 'Yoti Ltd.'
      passport = @{
        dateOfBirth = '1991-01-01'
        nationality = 'British'
        number = '123456789'
        dateOfIssue = '2020-01-01'
      }
      drivingLicence = @{
        dateOfBirth = '1991-01-01'
        number = 'FOO99701011JJ9ZM13'
        dateOfIssue = '2020-01-01'
        countryOfIssue = 'GB'
      }
    }
    digitalRightToWork = @{    
      levelOfAssurance = @{
        level = 'M1A'
        policy = 'GPG45'
      }
      verifyingOrganisation = 'Yoti Ltd.'
      nationality = 'British'
      _shareCode = 'SHARE1234'
      fraudDetected = 'true'
      classification = 'ListA'
      documents = @(
        @{ 
          documentType = 'PassportBritishCitizen'
          fileId = 'CC478A1B-25F6-44F9-AB2A-C9B5B27AB9F6'
          expiryDate = '2099-01-01'
          documentNumber = '12345678'
          dateOfBirth = '1991-01-01'
          fullName = 'JOHN'
          lastName = 'PASS'
          countryOfIssue = 'GB'
          issueDate = '2020-01-02'
          chipDigitalSignatureVerified = 'true'
          automatedFaceMatch = 'true'
        },
        @{ 
          documentType = 'BirthCertificateUK'
          fileId = '5E1DDE5D-EEE8-4272-A16F-42EC48BC8EBE'
          countryOfIssue = 'GB'
          expiryDate = '2099-01-01'
          issueDate = '1991-01-02'
          documentNumber = '12345'

          fullName = 'JOHN'
          lastName = 'PASS'
          dateOfBirth = '1991-01-01'
          nationality = 'British'
          placeOfBirth = 'London'
        }
      )
    }
  }
} | ConvertTo-Json -Depth 10;

# Submit verification documents
$vdBody = @{
  verificationDocuments= @(
    @{
      document = 'Group1_Passport'
      countryOfIssue = 'GB'
      dateOfBirth = '1991-01-01'
      passportNumber = '12345678'
      issueDate = '2020-01-01'
    },
    @{
      document = 'Group1_PhotocardDrivingLicence'
      dateOfBirth = '1991-01-01'
      countryOfIssue = 'GB'
      drivingLicenceNumber = 'PASS9901011J99ZU'
      validFromDate = '2020-01-01'
    })
  routeName = 'route1'
  guidelineVersion = 'DbsBasicV1'
  ukNational = 'true'
  dateOfBirth = '1991-01-01'
} | ConvertTo-Json -Depth 10;

$x = HttpPut -Path "/api/application/${appId}/verification-documents/dbs-basic" -Body $vdBody;
$x;

$x = HttpPost -Path "/api/application/${appId}" -Body $body;
$x; #.result

Write-Output "Viewable at https://localhost:44301/applications/application/$appId ";
