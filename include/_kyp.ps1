# don't execute this if functions are already defined
if (Test-Path Function:\Select-Target)
{
    exit;
}
else
{
    Write-Host "Defining KYP internals";
}

. "..\include\_sso.ps1";

$ErrorActionPreference = "Stop";

function Select-Target
{
    param (
        [Parameter(Mandatory)]
        [ValidateSet('localhost','blue', 'indigo', 'cyan', 'magenta', 'red', 'green', 'yellow', 'releasetest')]
        [string] $Deployment
    );
    # param (
    #     [Parameter(Mandatory)]
    #     [ValidateSet('MomCorp','PlanetExpress', 'KwikEMart')]
    #     [string] $Customer
    # );
    
    $global:_SsoBaseUrl = "https://sso-dev.knowyourpeople.co.uk";
    $global:_KypBaseUrl = "https://gbg-kyp-$Deployment.azurewebsites.net";
    $global:_ConcurrencyToken = "";
    $global:_SsoToken = "";

    if ($Deployment -eq 'localhost') {
        $global:_SsoBaseUrl = "https://localhost:5001";
        $global:_KypBaseUrl = "https://localhost:44301";
        $global:_CustomerId = "A2263B50-DC56-E511-BD1D-0019B9B80185"; # localhost MomCorp
        $global:_PersonId = 'afd3fd62-16a7-ea11-a9f4-3c528206716b'; # localhost MomCorp/Derek Smalls

        Write-Output "Selected localhost sso/kyp, MomCorp customer, person Derek Smalls. Ensure localhost KYP is running!";
        return;
    }
    
    if ($Deployment -eq 'magenta') {
        $global:_CustomerId = 'D0FEB8A7-55FF-E711-80C2-00155D8CF4BB'; # magenta QA_CustB
        $global:_PersonId = '5DCBAC29-8C77-EC11-94F6-A04A5E5D73A6'; # magenta John Alert (applicant all@test.com)
    }
    
    # if ($Deployment -eq 'blue') {
    #     $global:_SsoBaseUrl = "https://dev-sso.gbgplc.com";
    # }
    
    # if ($Deployment -eq 'releasetest') {
    #     $global:_SsoBaseUrl = "https://dev-sso.gbgplc.com";
    # }

    Write-Output "Selected SSO $global:_SsoBaseUrl";
    Write-Output "Selected KYP $Deployment $global:_KypBaseUrl";
    Write-Output "Selected CustomerId=$global:_CustomerId PersonId=$global:_PersonId";
}

if ($global:_SsoToken -eq $null) {
    Write-Host 'Loading default settings';
    Select-Target -Deployment localhost;
}

