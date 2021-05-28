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
    
    $global:_SsoBaseUrl = "https://gbg-sso-dev.azurewebsites.net";
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
    
    if ($Deployment -eq 'blue') {
        $global:_SsoBaseUrl = "https://dev-sso.gbgplc.com";
    }
    
    if ($Deployment -eq 'releasetest') {
        $global:_SsoBaseUrl = "https://dev-sso.gbgplc.com";
    }

    Write-Output "Selected $Deployment sso/kyp";
}

if ($global:_SsoToken -eq $null) {
    Write-Host 'Loading default settings';
    Select-Target -Deployment localhost;
}

