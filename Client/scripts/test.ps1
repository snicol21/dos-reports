$root = $(Split-Path $PSScriptRoot -Parent)
$MdsUrl = 'https://hc2525.hqcatalyst.local/MetadataService2/v2'

# get all dependent modules and functions
$modules = @( Get-ChildItem -Path $root\pwsh_modules\* -Include *.psd1 -Recurse -ErrorAction SilentlyContinue )
if ($modules) { Import-Module $modules -Force -Global }

Invoke-DosMds -Get -Type Entity -MdsUrl $MdsUrl