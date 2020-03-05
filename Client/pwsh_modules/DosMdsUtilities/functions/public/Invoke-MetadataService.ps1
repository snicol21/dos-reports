function Invoke-MetadataService {
    param
    (
        [Parameter(ParameterSetName = 'get', Mandatory)] [switch]$get,
        [Parameter(ParameterSetName = 'delete', Mandatory)] [switch]$delete,
        [Parameter(ParameterSetName = 'post', Mandatory)] [switch]$post,
        [Parameter(ParameterSetName = 'patch', Mandatory)] [switch]$patch,

        [Parameter(ParameterSetName = 'get', Mandatory)]
        [Parameter(ParameterSetName = 'delete', Mandatory)]
        [Parameter(ParameterSetName = 'post', Mandatory)]
        [Parameter(ParameterSetName = 'patch', Mandatory)]
        [ValidateSet('dataMart', 'entity', 'binding')]
        [string] $type,

        [Parameter(ParameterSetName = 'get', Mandatory)]
        [Parameter(ParameterSetName = 'delete', Mandatory)]
        [Parameter(ParameterSetName = 'post', Mandatory)]
        [Parameter(ParameterSetName = 'patch', Mandatory)]
        [string] $metadataServiceUrl,

        [Parameter(ParameterSetName = 'post', Mandatory)]
        [Parameter(ParameterSetName = 'patch', Mandatory)]
        [string] $body,

        [Parameter(ParameterSetName = 'get')]
        [Parameter(ParameterSetName = 'post')]
        [Parameter(ParameterSetName = 'delete', Mandatory)]
        [Parameter(ParameterSetName = 'patch', Mandatory)]
        [hashtable] $params,

        [Parameter(ParameterSetName = 'get')]
        [ValidateScript( {
                if ($_.Count -eq 1) { $true } else { throw "`$filter can only contain 1 key value pair" }
                if (@('Id', 'ContentId', 'Name') -contains $_.keys[0]) { $true } else { throw "`$filter can only contain keys: Id, ContentId, or Name" }
                if ($_.ContainsKey("Id")) { if ($_.Item('Id') -is [int]) { $true } else { throw "@{Id=[value]} value must be an integer" } }
                if ($_.ContainsKey("Name")) { if ($_.Item('Name') -is [string]) { $true } else { throw "@{Name=[value]} value must be an string" } }
                if ($_.ContainsKey("ContentId")) { if (Test-IsGuid $_.Item('ContentId')) { $true } else { throw "@{ContentId=[value]} value must be a valid guid string" } }
            })]
        [hashtable] $filter,

        [Parameter(Mandatory)]
        [string] $accessToken
    )
    begin {
        $url = $metadataServiceUrl.TrimEnd("/")

        switch ($type) {
            'dataMart' {
                if ($params) {
                    <# validation #> if (!($params.Count -eq 1)) { Write-DosMessage -Level "Fatal" -Message "dataMart `$params requires exactly 1 key value pair" }
                    <# validation #> if (!$params.ContainsKey("dataMartId")) { Write-DosMessage -Level "Fatal" -Message "dataMart `$params missing dataMartId key value pair" }
                    <# validation #> if (!$params.Item('dataMartId') -is [int]) { Write-DosMessage -Level "Fatal" -Message "@{dataMartId=[value]} value must be an integer" }
                    $url = "$($url)/DataMarts({0})" -f $params.Item('dataMartId')
                }
                else {
                    $url = "$($url)/DataMarts"
                }
            }
            'entity' {
                if ($params) {
                    <# validation #> if (!($params.Count -in @(1, 2))) { Write-DosMessage -Level "Fatal" -Message "entity `$params requires exactly 1 or 2 key value pairs" }
                    if ($params.ContainsKey("dataMartId")) {
                        <# validation #> if (!($params.Item('dataMartId') -is [int])) { Write-DosMessage -Level "Fatal" -Message "@{dataMartId=[value]} value must be an integer" }
                        if ($params.ContainsKey("entityId")) {
                            <# validation #> if (!($params.Item('entityId') -is [int])) { Write-DosMessage -Level "Fatal" -Message "@{entityId=[value]} value must be an integer" }
                            $url = "$($url)/DataMarts({0})/Entities({1})" -f $params.Item('dataMartId'), $params.Item('entityId')
                        }
                        else {
                            $url = "$($url)/DataMarts({0})/Entities" -f $params.Item('dataMartId')
                        }
                    }
                    else {
                        $url = "$($url)/Entities({0})" -f $params.Item('entityId')
                    }
                }
                else {
                    $url = "$($url)/Entities"
                }
            }
            'binding' {
                if ($params) {
                    <# validation #> if (!($params.Count -in @(1, 2))) { Write-DosMessage -Level "Fatal" -Message "binding `$params requires exactly 1 or 2 key value pairs" }
                    if ($params.ContainsKey("dataMartId")) {
                        <# validation #> if (!($params.Item('dataMartId') -is [int])) { Write-DosMessage -Level "Fatal" -Message "@{dataMartId=[value]} value must be an integer" }
                        if ($params.ContainsKey("bindingId")) {
                            <# validation #> if (!($params.Item('bindingId') -is [int])) { Write-DosMessage -Level "Fatal" -Message "@{bindingId=[value]} value must be an integer" }
                            $url = "$($url)/DataMarts({0})/Bindings({1})" -f $params.Item('dataMartId'), $params.Item('bindingId')
                        }
                        else {
                            $url = "$($url)/DataMarts({0})/Bindings" -f $params.Item('dataMartId')
                        }
                    }
                    else {
                        $url = "$($url)/Bindings({0})" -f $params.Item('bindingId')
                    }
                }
                else {
                    $url = "$($url)/Bindings"
                }
            }
        }
    }
    process {
        switch ("$($PsCmdlet.ParameterSetName)|$($type)") {
            'get|dataMart' {
                if ($filter) { return Get-DataMart -url $url -accessToken $accessToken -filter $filter }
                return Get-DataMart -url $url -accessToken $accessToken
            }
            'get|entity' {
                return $url
            }
            'delete' {
                return $url
            }
            'post' {
                return $url
                # return New-DataMart -url $url -body $body -accessToken $accessToken
            }
            'patch' {
                return $url
                # return Update-DataMart -url $url -body $body -accessToken $accessToken
            }
        }
    }
}