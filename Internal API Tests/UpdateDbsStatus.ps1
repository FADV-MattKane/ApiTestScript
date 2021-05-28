. "..\include\_Public_Api.ps1";
. "..\include\_Internal_Api.ps1";
. "..\include\_TestTools.ps1";

Select-Target -Deployment "blue";  # blue, releasetest, red, localhost etc.
$ssoToken = Get-SsoToken -LoginAs IronGiant; # has been granted the dbsscreenscrape scope

# $data = HttpGet -Path "/api/tracking/standard-enhanced";
$shortcode =  'AP03FNJY'; # $data.resu./uplt.results[0].applicationShortcode;
Write-Host "Application '$shortcode' available for update...";

# This is the body tested as working by the /api/tracking/standard-enhanced endpoint
# $body = @"
# {
#   applicationId: "$shortcode",
#   ranAt: "2020-09-08",
#   scrape: [
#       { stage: 'ApplicationReceived',  status: 'Completed', completedOn: "2020-09-01" },
#       { stage: 'ApplicationValidation',  status: 'Completed', completedOn: "2020-09-02" },
#       { stage: 'PoliceNationalComputer',  status: 'InProgress', completedOn: null },
#       { stage: 'BarredListSearch',  status: 'NotRecorded', completedOn: null },
#       { stage: 'PoliceRecords',  status: 'NotRecorded', completedOn: null },
#       { stage: 'CertificatePrinted',  status: 'NotRequired', completedOn: null },
#       { stage: 'CertificateDispatched',  status: 'NotStarted', completedOn: null },
#       { stage: 'Withdrawn',  status: 'NotStarted', completedOn: null }
#   ],
#   escalation: {
#      wasAvailable: true,
#      wasAttempted: false,
#      wasSuccessful: false,
#      countersignerNumber: 'CSN0099'
#   }
# }
# "@;

# This was the body sent by the ScreenSrape Web fn for application B45MHBGY
# $body = @"
# {
#   "ApplicationId":"B45MHBGY",
#   "RanAt":"2020-09-25T16:41:12.5323132+00:00",
#   "Scrape":[
#     {"Stage":"ReceivedByDbs","Status":"Completed","CompletedOn":"2015-05-20"},
#     {"Stage":"DbsValidated","Status":"Completed","CompletedOn":"2015-05-20"},
#     {"Stage":"PoliceNationalComputer","Status":"Completed","CompletedOn":"2015-05-27"},
#     {"Stage":"BarredListSearch","Status":"InProgress","CompletedOn":null},
#     {"Stage":"PoliceRecords","Status":"NotStarted","CompletedOn":null},
#     {"Stage":"CertificatePrinted","Status":"NotStarted","CompletedOn":null}
#   ],
#   "Escalation":{
#     "WasAvaliable":false,
#     "WasAttempted":false,
#     "WasSuccessful":false,
#     "CountersigNumber":null
#   }
# }
# "@;

# fixed body: this works
$body = @"
{
  "ApplicationId":"B45MHBGY",
  "RanAt":"2020-09-25T16:41:12.5323132+00:00",
  "Scrape":[
    {"Stage":"ApplicationReceived","Status":"Completed","CompletedOn":"2015-05-20"},
    {"Stage":"ApplicationValidation","Status":"Completed","CompletedOn":"2015-05-20"},
    {"Stage":"PoliceNationalComputer","Status":"Completed","CompletedOn":"2015-05-27"},
    {"Stage":"BarredListSearch","Status":"InProgress","CompletedOn":null},
    {"Stage":"PoliceRecords","Status":"NotStarted","CompletedOn":null},
    {"Stage":"CertificatePrinted","Status":"NotStarted","CompletedOn":null}
  ],
  "Escalation":{
    "WasAvaliable":false,
    "WasAttempted":false,
    "WasSuccessful":false,
    "CountersignerNumber":null
  }
}
"@;

$x = HttpPut -Path "/api/tracking/standard-enhanced" -Body $body;
# Invoke-WebRequest : {"message":"The request is invalid.","modelState":{"dbsStdEnhStatusUpdateModel.Scrape[0].Stage":["An error has occurred."],"dbsStdEnhStatusUpdateModel.Scrape[1].Stage":["An error has occurred."]}}
$x.result;
