function Get-DataMart {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $url,
        [Parameter(Mandatory)] [string] $accessToken,
        [hashtable] $filter
    )

    $headers = @{ Accept = "application/json"; Authorization = "Bearer $accessToken" }
    $messages = Get-Messages -method 'get' -type 'dataMart'
    if ($filter) {
        $filterKey = $filter.keys[0]
        $filterValue = $filter.values[0]
        if ($filterKey -eq 'Name') {
            $url = "$($url)?`$filter=$filterKey eq '$($filterValue)'"
        }
        else {
            $url = "$($url)?`$filter=$filterKey eq $($filterValue)"
        }
    }

    try {
        Write-DosMessage -Level "Information" -Message ($messages.attempting -f $url)
        $response = Invoke-RestMethod -Method Get -Uri $url -ContentType "application/json" -Headers $headers -UseBasicParsing -TimeoutSec 600
        if ($response) {
            if (Test-HasProperty -object $response -propertyName 'value') { $result = $response.value } else { $result = $response }
            $display = "$(if($result.length -gt 3){"[showing first 3]..."})$($result | Select-Object Id, Name -First 3 | ConvertTo-Json -Compress)"
            if (!$result) {
                throw ($messages.nodata)
            }
            Write-DosMessage -Level "Information" -Message ($messages.success -f $display)
            if ($id.IsPresent) {
                return $result.Id
            }
            return $result
        }
        else {
            Write-DosMessage -Level "Fatal" -Message ($messages.failure)
        }
    }
    catch {
        $exception = $_.Exception
        if ($exception.Message -match "responded with no data") {
            Write-DosMessage -Level "Error" -Message $exception.Message
        }
        else {
            $_error = "Unknown error attempting to GET"
            if ($null -ne $exception -and $null -ne $exception.Response) {
                $_error = Get-ErrorFromResponse -response $exception.Response
            }
            Write-DosMessage -Level "Fatal" -Message ($messages.unknown -f $_error)
        }
    }
}