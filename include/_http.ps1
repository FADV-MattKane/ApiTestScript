# don't execute this if functions are already defined
if (Test-Path Function:\_http)
{
    exit;
}
else
{
    Write-Host "Defining http internals";
}

function _http {
    param (
        [Parameter(Mandatory)] 
        [string] $Url,

        [Parameter(Mandatory)]
        [ValidateSet('GET','POST', 'PUT', 'DELETE')]
        [string] $Verb,

        [Parameter()] 
        [object] $Body = $null,

        [Parameter()] 
        [string] $SsoToken = $global:_SsoToken,

        [Parameter()] 
        [string] $ConcurrencyToken = $global:_ConcurrencyToken,

        [Parameter()] [string] $ContentType = "application/json",
        
        [Parameter()] [bool] $UpdateConcurrencyToken = 1,
        
        [Parameter()] [string] $OutputContentType = "application/json"
    );
    
    $headers = @{ 
        "Authorization" = "Bearer $SsoToken"; 
        "x-concurrency-token" = "$ConcurrencyToken";
        "X-Customer-Id" = "$global:_CustomerId";
    };

    Write-Host "$Verb $Url";
    $response = Switch ($Verb)
    {
        'GET' { Invoke-WebRequest -Uri "$Url" `
                                  -Method $Verb `
                                  -ContentType $ContentType `
                                  -Headers $headers; }

        'POST' { Invoke-WebRequest -Uri "$Url" `
                                   -Method $Verb `
                                   -ContentType $ContentType `
                                   -Headers $headers `
                                   -Body $Body; }

        'PUT' { Invoke-WebRequest -Uri "$Url" `
                                   -Method $Verb `
                                   -ContentType $ContentType `
                                   -Headers $headers `
                                   -Body $Body; }
                                   

        'DELETE' { Invoke-WebRequest -Uri "$Url" `
                                     -Method $Verb `
                                     -ContentType $ContentType `
                                     -Headers $headers `
                                     -Body $Body; }
    };

    $contentObj = Switch ($OutputContentType) {
        "application/json" { ConvertFrom-Json $([String]::new($response.Content)); }
        default { $response.Content; }
    }

    $correlationId = $response.Headers["correlation-id"];

    if($UpdateConcurrencyToken -eq 1) 
    {
        $ConcurrencyToken = $response.Headers["x-concurrency-token"];
        $global:_ConcurrencyToken = $ConcurrencyToken;
        return @{ 
            statusCode = $response.StatusCode;
            content = $contentObj; 
            concurrencyToken = $ConcurrencyToken;
            correlationId = $correlationId;
        };
    }
    else
    {
        return @{ 
            statusCode = $response.StatusCode;
            content = $contentObj; 
            correlationId = $correlationId;
        };
    }
}

function HttpGet
{
    param (
        [Parameter(Mandatory)] [string] $Path,
        [Parameter()] [string] $SsoToken = $global:_SsoToken,
        [Parameter()] [string] $ConcurrencyToken = $global:_ConcurrencyToken,
        [Parameter()] [string] $ContentType = "application/json",
        [Parameter()] [switch] $Html
    );
    if ($Html -eq $false) {
        return _http -Url "$global:_KypBaseUrl$Path" `
                 -Verb GET `
                 -SsoToken $SsoToken `
                 -ConcurrencyToken $ConcurrencyToken `
                 -ContentType $ContentType;
    } else {
        return _http -Url "$global:_KypBaseUrl$Path" `
                 -Verb GET `
                 -SsoToken $SsoToken `
                 -ConcurrencyToken $ConcurrencyToken `
                 -ContentType $ContentType `
                 -OutputContentType "application/html";
    }
}

function HttpPost
{
    param (
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $Body,
        [Parameter()] [string] $SsoToken = $global:_SsoToken,
        [Parameter()] [string] $ConcurrencyToken = $global:_ConcurrencyToken,
        [Parameter()] [string] $ContentType = "application/json"
    );

    return _http -Url "$global:_KypBaseUrl$Path" `
                 -Verb POST `
                 -Body $Body `
                 -SsoToken $SsoToken `
                 -ConcurrencyToken $ConcurrencyToken `
                 -ContentType $ContentType;
}

function HttpPut
{
    param (
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $Body,
        [Parameter()] [string] $SsoToken = $global:_SsoToken,
        [Parameter()] [string] $ConcurrencyToken = $global:_ConcurrencyToken,
        [Parameter()] [string] $ContentType = "application/json"
    );

    return _http -Url "$global:_KypBaseUrl$Path" `
                 -Verb PUT `
                 -Body $Body `
                 -SsoToken $SsoToken `
                 -ConcurrencyToken $ConcurrencyToken `
                 -ContentType $ContentType;
}


function HttpDelete
{
    param (
        [Parameter(Mandatory)] [string] $Path,
        [Parameter()] [string] $SsoToken = $global:_SsoToken,
        [Parameter()] [string] $ConcurrencyToken = $global:_ConcurrencyToken,
        [Parameter()] [string] $ContentType = "application/json"
    );

    return _http -Url "$global:_KypBaseUrl$Path" `
                 -Verb DELETE `
                 -SsoToken $SsoToken `
                 -ConcurrencyToken = $ConcurrencyToken;
    
}