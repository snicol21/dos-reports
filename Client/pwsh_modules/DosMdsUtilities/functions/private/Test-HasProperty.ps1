function Test-HasProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)] $object,
        [Parameter(Mandatory, Position = 1)] [string] $propertyName
    )
    return [bool]($object.PSobject.Properties.Name -Contains $propertyName)
}