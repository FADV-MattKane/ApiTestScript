. "$PSScriptRoot\_http.ps1";
. "$PSScriptRoot\_kyp.ps1";

if (Test-Path Function:\Countersign-Application)
{
    exit;
}
else
{
    Write-Host "Defining Public API functions";
}

function Countersign-Application
{
    param (
        [Parameter(Mandatory)] [string] $ShortCode,
        [Parameter(Mandatory)] [string] $Body
    );
    
    Write-Host "Countersign-Application";
    return HttpPost -Path "/api/application/$ShortCode/countersign" -Body $Body;
}

function Create-Application
{
    param (
        [Parameter(Mandatory)] [string] $Body
    );
    
    Write-Host "Create-Application";
    $data = HttpPost -Path "/api/application/setup" -Body $Body;
    Write-Host "Application '$($data.result.shortcode)' Created";
    return $data;
}

function Customer-Search
{
    param (
        [Parameter(Mandatory)] [string] $Body
    );
    
    Write-Host "Customer-Search";
    return HttpPost -Path "/api/customer-search" -Body $Body;
}

function Enter-OverseasCrCheck-Results
{
    param (
        [Parameter(Mandatory)] [string] $ShortCode,
        [Parameter(Mandatory)] [string] $Body
    );
    
    Write-Host "Enter-OverseasCrCheck-Results";
    return HttpPut -Path "/api/application/$ShortCode/results/overseas-criminal-record" -Body $Body;
}

function Get-Application
{
    param (
        [Parameter(Mandatory)] [string] $Shortcode
    );
    
    Write-Host "Get-Application";
    return HttpGet -Path "/api/application/$Shortcode";
}

function Organisation-Search
{
    param (
        [Parameter(Mandatory)] [string] $Body
    );
    
    Write-Host "Organisation-Search";
    return HttpPost -Path "/api/organisation-search" -Body $Body;
}

function Submit-Application
{
    param (
        [Parameter(Mandatory)] [string] $ShortCode,
        [Parameter(Mandatory)] [string] $Body
    );
    
    Write-Host "Submit-Application";
    return HttpPost -Path "/api/application/$ShortCode" -Body $Body;
}

function Verify-Application
{
    param (
        [Parameter(Mandatory)] [string] $ShortCode,
        [Parameter(Mandatory)] [string] $Body
    );
    
    Write-Host "Verify-Application";
    return HttpPost -Path "/api/application/$ShortCode/verify" -Body $Body;
}