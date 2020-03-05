function Update-DataMart {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $url,
        [Parameter(Mandatory)] [string] $body,
        [Parameter(Mandatory)] [string] $accessToken
    )

    $name = (ConvertFrom-Json -InputObject $body).Name
    $headers = @{ Accept = "application/json"; Authorization = "Bearer $accessToken" }
    $messages = Get-Messages -method 'patch' -type 'dataMart'

    try {
        Write-DosMessage -Level "Information" -Message ($messages.attempting -f $url)
        $response = Invoke-RestMethod -Method Patch -Uri $url -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing -TimeoutSec 600
        # if ($response) {
        #     $display = $response | Select-Object Id, Name | ConvertTo-Json -Compress
        #     Write-DosMessage -Level "Information" -Message ($messages.success -f $display)
        return $response
        # }
        # else {
        #     Write-DosMessage -Level "Fatal" -Message ($messages.failure)
        # }
    }
    catch {
        $exception = $_.Exception
        # if ((Assert-WebExceptionType -exception $exception -typeCode 400) -and ((Get-ErrorFromResponse -response $exception.Response) -match "'Name' already exists")) {
        #     Write-DosMessage -Level "Information" -Message ($messages.exists)
        #     $url = "$($url)?`$filter=Name eq '$($name)'"
        #     Get-DataMart -url $url -accessToken $accessToken
        # }
        else {
            $_error = "Unknown error attempting to PATCH"
            $exception = $_.Exception
            if ($null -ne $exception -and $null -ne $exception.Response) {
                $_error = Get-ErrorFromResponse -response $exception.Response
            }
            Write-DosMessage -Level "Fatal" -Message ($messages.unknown -f $_error)
        }
    }
}