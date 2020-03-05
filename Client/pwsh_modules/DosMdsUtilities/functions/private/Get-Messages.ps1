function Get-Messages {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('get', 'delete', 'post', 'patch')]
        [string]$method,
        [Parameter(Mandatory)]
        [ValidateSet('dataMart', 'entity', 'binding')]
        [string]$type
    )
    $method = $method.ToUpper()
    $type = $type.ToUpper()
    return @{
        attempting = "Attemping to $method $type with the metadata service. $method --> {0}"
        success    = "Success! $method method completed for $type --> {0}"
        failure    = "Something went wrong! The $method request succeeded, but the response was empty."
        exists     = "$type already exists in metadata."
        unknown    = "There was an error attempting to $method $type with the metadata service --> {0}"
        nodata     = "The $type requested responded with no data"
    }
}