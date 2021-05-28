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
        "dbs-basic"
    ],
    "completedBy": "Me"    
}
"@;

$shortcode = $data.result.shortcode;
$data = Submit-Application -ShortCode $shortcode -Body @"
{ 
  shared: {
    name: { firstName: 'Anant', middleNames: [], lastName: 'Sharma' },
    title: 'Dr',
    dateOfBirth: '1990-03-07',
    gender: 'male',
    address: {
      companyName: '',
      subBuildingNumber: '',
      buildingName: '',
      buildingNumber: '',
      subStreet: '',
      street: '1 Bridge street',
      town: 'Portsoy',
      city: '',
      county: 'Aberdeenshire',
      postcode: 'AB452GP',
      country: 'GB'
    }
  },
  checks: {
    dbsBasic: {
      currentAddressStartDate: '2016-04-11',
      previousAddresses: [],
      townOfBirth: 'London',
      previousNames: {
        knownByOtherNames: true,
        names: [
          {
            firstName: 'Anant',
            lastName: 'Sharma',
            startDate: '2021-04-01',
            endDate: null
          }
        ]
      },
      countryOfBirth: 'GB',
      email: 'anantparashar17@gmail.com',
      receiveCertificate: true,
      receiveCertificateAtCurrentAddress: true,
      consent: true,
      profile: { number: 'ABCDEFG', hasProfile: false },
      phone: '+9112345678565',
      niNumber: { number: 'AA999999A' }
    }
  }
}
"@;

