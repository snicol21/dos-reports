function JsonConvert-DeserializeObject {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$Json
    )
	
    function ConvertFrom-JObject($obj) {
        if ($obj -is [Newtonsoft.Json.Linq.JArray]) {
            $a = @()
            foreach ($entry in $obj.GetEnumerator()) {
                $a += @(ConvertFrom-JObject $entry)
            }
            return $a
        }
        elseif ($obj -is [Newtonsoft.Json.Linq.JObject]) {
            $h = [ordered]@{ }
            foreach ($kvp in $obj.GetEnumerator()) {
                $val = ConvertFrom-JObject $kvp.value
                if ($kvp.value -is [Newtonsoft.Json.Linq.JArray]) { $val = @($val) }
                $h += @{ "$($kvp.key)" = $val }
            }
            return $h
        }
        elseif ($obj -is [Newtonsoft.Json.Linq.JValue]) {
            return $obj.Value
        }
        else {
            return $obj
        }
    }
	
    $jsonSettings = New-Object Newtonsoft.Json.JsonSerializerSettings
    $object = [Newtonsoft.Json.JsonConvert]::DeserializeObject($Json, [Newtonsoft.Json.Linq.JObject], $jsonSettings)
    return ConvertFrom-JObject $object
}