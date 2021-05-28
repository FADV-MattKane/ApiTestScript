
if (Test-Path Function:\Assert-Response)
{
    Write-Host "Assert functions loaded, not importing again";
    exit;
}
else
{
    Write-Host "Defining Assert functions";
}

function Get-Timecode
{
    return "$(Get-Date -Format yyyyMMddHHmmssfff)";
}

function Assert-Response
{
    param (
        [Parameter(Mandatory)] [hashtable] $StdResponseData,
        
        [Parameter(Mandatory)]
        [ValidateSet(200, 201, 204, 400, 401,403, 404)]
        [int] $ExpectedResponseCode
    );
    $returnedStatusCode = $StdResponseData.statusCode;
    $info = '{0}, file {1}, line {2}' -f @( 
        $MyInvocation.Line.Trim(), 
        $MyInvocation.ScriptName, 
        $MyInvocation.ScriptLineNumber 
    );
    $state = "PASS";

    if(-not ($returnedStatusCode -eq $ExpectedResponseCode))
    {
        $state = "FAIL";
    }
    
    $message = @"
Assert-Response: '$state': Expected '$ExpectedResponseCode', got '$returnedStatusCode'
             at: '$info'
"@;

    if ($state -eq "PASS")
    {
        Write-Host $message;
    }
    else
    {
        throw $message;
    }
}

