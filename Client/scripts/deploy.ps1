param(
    [hashtable] $configStore,
    [Parameter(Mandatory)]
    [string] $secret
)

$root = $(Split-Path $PSScriptRoot -Parent)

# add default values to both the config store and configuration manifest
# only if they're not passed in from some external script
if (!$configStore) {
    $configStore = @{
        Name   = "StoreConfig"
        Type   = "File"
        Format = "XML"
        Path   = "C:\Program Files\Health Catalyst\install.config"
    }
}

# get all dependent modules and functions
$modules = @( Get-ChildItem -Path $root\pwsh_modules\* -Include *.psd1 -Recurse -ErrorAction SilentlyContinue )
if ($modules) { Import-Module $modules -Force -Global }

Set-DosMessageConfiguration -MinimumLoggingLevel "Information" -LoggingMode "Both" -LogFilePath "$root\logs.log"

Write-DosMessage -Level "Information" -Message "---" -HeaderType H2

# make sure configuration paths exist
Write-DosMessage -Level "Information" -Message "Find install config [$($configStore.Path)]"
if (!(Test-Path $configStore.Path)) { throw "Can't find config store [$($configStore.Path)]" }

# get common scope configurations
Write-DosMessage -Level "Information" -Message "Getting store configs from $([io.path]::GetFileName($configStore.Path))"
$config = Get-DosConfigValues -ConfigStore $configStore -Scope "common"

# get metadata service url from discovery
$metadataServiceUrl = Get-DosServiceUrl -DiscoveryServiceUrl $config.discoveryService -ServiceName "MetadataService" -ServiceVersion 2

# get accessToken
$accessTokenParams = @{
    identityUrl = $config.identityService
    clientId    = "fabric-installer"
    scope       = "dos/metadata dos/metadata.serviceAdmin"
    secret      = $secret
}
$accessToken = Get-AccessToken @accessTokenParams
# $accessToken | Out-File C:\Users\spencer.nicol\Desktop\token.txt -Force

# base params (required by all mds requests)
$mdsBaseParams = @{
    metadataServiceUrl = $metadataServiceUrl
    accessToken        = $accessToken
}

# $mdsPostParams = @{
#     post = $true
#     type = 'dataMart'
#     body = (Get-Content $root/config/datamart.json -Raw)
# }
# Invoke-MetadataService @mdsBaseParams @mdsPostParams

# $mdsGetParams = @{
#     get    = $true
#     type   = 'dataMart'
#     filter = @{ ContentId = '399ad4ee-2b03-4ffd-bab8-d0ed62aa910b' }
# }
# $dm = Invoke-MetadataService @mdsBaseParams @mdsGetParams

# $mdsPatchParams = @{
#     patch  = $true
#     type   = 'dataMart'
#     body   = (Get-Content $root/config/datamart.json -Raw)
#     params = @{ dataMartId = 194 }
# }
# Invoke-MetadataService @mdsBaseParams @mdsPatchParams

$mdsGetParams = @{
    get    = $true
    type   = 'dataMart'
    params = @{ dataMartId = 194 }
}
Invoke-MetadataService @mdsBaseParams @mdsGetParams


# # deploy datamart
# $dosReportsDataMartParams = @{
#     metadataServiceUrl = $metadataServiceUrl
#     body               = (Get-Content $root/config/datamart.json -Raw)
#     accessToken        = $accessToken
# }
# $datamart = New-DosReportsDataMart @dosReportsDataMartParams
# $datamart | Out-File C:\Users\spencer.nicol\Desktop\datamart.json