function Delete-DataMart {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [string] $url,
        [Parameter(Mandatory = $true)] [string] $token
    )

    $url = "$($url.TrimEnd("/"))/DataMarts"

    $headers = @{"Accept" = "application/json" }
    if ($token) {
        $headers.Add("Authorization", "Bearer $token")
    }

    # attempt to add
    try {
        Write-DosMessage -Level "Information" -Message "Attemping to delete metadata for the ""$($clientObject.Name)"" datamart with Metadata Service. DELETE:$url"
        $response = Invoke-RestMethod -Method Delete -Uri $url -ContentType "application/json" -Headers $headers -UseBasicParsing -TimeoutSec 600
        if ($response) {
            Write-DosMessage -Level "Information" -Message "Successfully deleted datamart: $($response | Select-Object Id, Name | ConvertTo-Json -Compress)"
            return $response
        }
        else {
            Write-DosMessage -Level "Fatal" -Message "Something went wrong! The DELETE request succeeded, but the response was empty."
        }
    }
    catch {
        $_error = "Unknown error attempting to delete"
        $exception = $_.Exception
        if ($null -ne $exception -and $null -ne $exception.Response) {
            $_error = Get-ErrorFromResponse -response $exception.Response
        }
        Write-DosMessage -Level "Fatal" -Message "There was an error deleting datamart ""$($clientObject.Name)"" with Metadata Service: $_error, halting script."
    }
}