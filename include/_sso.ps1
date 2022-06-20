# don't execute this if functions are already defined
if (Test-Path Function:\Get-SsoToken)
{
    exit;
}
else
{
    Write-Host "Defining SSO functions";
}

. "$PSScriptRoot\_http.ps1";

function Login-As
{
    param (
        [Parameter(Mandatory)]
        [string] $Token
    );
    
    $global:_SsoToken = $token;
    Write-Host "Set logged in user to token";
}

function Get-SsoToken
{
    param (
        [Parameter(Mandatory)]
        [ValidateSet('IronGiant','Kyp', 'Yodel', 'DbsTracking')]
        [string] $LoginAs,

        [Parameter()][string] $Username,
        [Parameter()][string] $Password
    );
    
    Write-Host "Get-SsoToken";

    $token = Switch ($LoginAs)
    {
        'Kyp' { 
            # check sso appsettings.json { ssoserver { "enableResourceOwnerGrant": true } }
            # if this fails
            $t = (_http -Url "$global:_SsoBaseUrl/auth/connect/token" `
                        -Verb POST `
                        -ContentType "application/x-www-form-urlencoded" `
                        -Body @{
                            client_id="testing"; # "soapui"
                            client_secret="e6707423-2e64-4480-9524-d612b3a7e6a2";
                            scope="kypapi righttowork not_public";
                            grant_type="password";
                            username=$Username;
                            password=$Password; 
                        } `
                        -UpdateConcurrencyToken 0 `
                        -ErrorAction STOP).content.access_token;
            
            Write-Host "Successfully obtained token '$t' for $LoginAs as $Username via password grant type";
            $t;
        }
        
        'IronGiant' { 
            $t = (_http -Url "$global:_SsoBaseUrl/auth/connect/token" `
                        -Verb POST `
                        -ContentType "application/x-www-form-urlencoded" `
                        -Body @{
                            client_id="irongiant"; 
                            client_secret="e6707423-2e64-4480-9524-d612b3a7e6a2"; 
                            scope="kypapi scheduling dbsscreenscrape";
                            grant_type="client_credentials";
                        } `
                        -UpdateConcurrencyToken 0 `
                        -ErrorAction STOP).content.access_token;
            
            Write-Host "Successfully obtained token for $LoginAs via client credentials grant type";
            $t;
        }
        
        'DbsTracking' { 
            $t = (_http -Url "$global:_SsoBaseUrl/auth/connect/token" `
                        -Verb POST `
                        -ContentType "application/x-www-form-urlencoded" `
                        -Body @{
                            client_id="dbs-tracking"; 
                            client_secret="e6707423-2e64-4480-9524-d612b3a7e6a2"; 
                            scope="kypapi dbsscreenscrape";
                            grant_type="client_credentials";
                        } `
                        -UpdateConcurrencyToken 0 `
                        -ErrorAction STOP).content.access_token;
            
            Write-Host "Successfully obtained token for $LoginAs via client credentials grant type";
            $t;
        }

        default {
            throw "LoginAs value '$LoginAs' not yet supported";
        }
    }
    
    Login-As $token;
    return $token;
}
