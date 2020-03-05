function New-DataMart {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [string] $url,
        [Parameter(Mandatory = $true)] $body,
        [Parameter(Mandatory = $true)] [string] $token
    )

    $url = "$($url.TrimEnd("/"))/DataMarts"

    if (!($body -is [string])) {
        $clientObject = $body
        $body = $body | ConvertTo-Json -Depth 100 -Compress
    }
    else {
        $clientObject = ConvertFrom-Json -InputObject $body
    }

    $headers = @{"Accept" = "application/json" }
    if ($token) {
        $headers.Add("Authorization", "Bearer $token")
    }

    # attempt to add
    try {
        Write-DosMessage -Level "Information" -Message "Attemping to post json metadata for the ""$($clientObject.Name)"" datamart with Metadata Service. POST:$url"
        $response = Invoke-RestMethod -Method Post -Uri $url -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing -TimeoutSec 600
        if ($response) {
            Write-DosMessage -Level "Information" -Message "Successfully registered datamart: $($response | Select-Object Id, Name | ConvertTo-Json -Compress)"
            return $response
        }
        else {
            Write-DosMessage -Level "Fatal" -Message "Something went wrong! The POST request succeeded, but the response was empty."
        }
    }
    catch {
        $exception = $_.Exception
        if ((Assert-WebExceptionType -exception $exception -typeCode 400) -and ((Get-ErrorFromResponse -response $exception.Response) -match "'Name' already exists")) {
            Write-DosMessage -Level "Information" -Message """$($clientObject.Name)"" datamart already registered with Metadata Service."
            $url = "$($url)?`$filter=Name eq '$($clientObject.Name)'"
            Write-DosMessage -Level "Information" -Message "Getting ""$($clientObject.Name)"" datamart. GET:$url"
            $response = Invoke-RestMethod -Method Get -Uri $url -ContentType "application/json" -Headers $headers -UseBasicParsing
            if ($response.value) {
                $response = $response.value
                Write-DosMessage -Level "Information" -Message "Successfully found datamart: $($response | Select-Object Id, Name | ConvertTo-Json -Compress)"
                return $response
            }
            else {
                Write-DosMessage -Level "Fatal" -Message "Something went wrong! The POST request succeeded, but the response was empty."
            }
        }
        else {
            $_error = "Unknown error attempting to post"
            $exception = $_.Exception
            if ($null -ne $exception -and $null -ne $exception.Response) {
                $_error = Get-ErrorFromResponse -response $exception.Response
            }
            Write-DosMessage -Level "Fatal" -Message "There was an error registering datamart ""$($clientObject.Name)"" with Metadata Service: $_error, halting script."
        }
    }
}