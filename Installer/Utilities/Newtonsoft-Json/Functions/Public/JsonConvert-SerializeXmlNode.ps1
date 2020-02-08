function JsonConvert-SerializeXmlNode {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True, Position = 0)]
        [psobject]$Xml,
        [Parameter(Mandatory = $False)]
        [switch]$OmitRootObject
    )
    $json = [Newtonsoft.Json.JsonConvert]::SerializeXmlNode($Xml, 0, $OmitRootObject.IsPresent);
    $json = $json -replace "({`"@Integer`":`")(\d*)(`"})", '$2' `
        -replace "({`"@Float`":`")(\d*.\d*)(`"})", '$2' `
        -replace "({`"@Boolean`":`")(true|false)(`"})", '$2'
    return $json
}