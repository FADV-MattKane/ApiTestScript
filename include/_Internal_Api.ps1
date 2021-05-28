. "..\include\_http.ps1";
. "..\include\_kyp.ps1";

if (Test-Path Function:\Create-User)
{
    Write-Host "Internal API functions loaded, not importing again";
    exit;
}
else
{
    Write-Host "Defining Internal API functions";
}

function Create-User
{
    param (
        [Parameter(Mandatory)] [string] $FirstName,
        [Parameter(Mandatory)] [string] $LastName,
        [Parameter(Mandatory)] [string] $Email,
        [Parameter(Mandatory)] [boolean] $IsInternal,
        [Parameter(Mandatory)] [string] $CustomerShortcode
    );
    
    $body = @"
{
    firstName: '$FirstName',
    lastName: '$LastName',
    email: '$Email',
    isInternal: '$IsInternal',
    customerShortcode: '$CustomerShortcode'
}
"@;

    Write-Host "Create-User '$FirstName' '$LastName' '$EmailAddress' '$IsInternal'";
    return HttpPost -Path "/api/users" -Body $body;
}
