param (
    [Parameter(Mandatory = $false)]
    [string]$discoveryServiceUrl = "https://HC2525.hqcatalyst.local/DiscoveryService/v1",
    [Parameter(Mandatory = $false)]
    [string]$accessToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhERjg1QzNENTZFNUFGOEQ3NDQ4OERCRkI1MTc4NjExRjJCRjQ3RjUiLCJ0eXAiOiJKV1QiLCJ4NXQiOiJqZmhjUFZibHI0MTBTSTJfdFJlR0VmS19SX1UifQ.eyJuYmYiOjE1ODE0NDE1NzIsImV4cCI6MTU4MTQ0NTE3MiwiaXNzIjoiaHR0cHM6Ly9oYzI1MjUuaHFjYXRhbHlzdC5sb2NhbC9pZGVudGl0eSIsImF1ZCI6WyJodHRwczovL2hjMjUyNS5ocWNhdGFseXN0LmxvY2FsL2lkZW50aXR5L3Jlc291cmNlcyIsImRvcy1tZXRhZGF0YS1zZXJ2aWNlLWFwaSJdLCJjbGllbnRfaWQiOiJmYWJyaWMtaW5zdGFsbGVyIiwic2NvcGUiOlsiZG9zL21ldGFkYXRhIiwiZG9zL21ldGFkYXRhLnNlcnZpY2VBZG1pbiJdfQ.Lt4VW_43pa-YxFSjxKTo0-mHwGFsadK9UiKFQeN7IL5z-XX7pXoAuyU8AptLlRdaorQzb98EwjI_1-po7klSixqombPpXBmFIA-rykcVbfNfl8YXUqYYoCVPsO0ejuiVIfJm4Bm2chB1gvfgViaUIYUnKY-Nqy2AlHhuzF8s0ZPXNRG3GrZD1oIKyVqwNqU95M7l_y317_kJ7KTOogCemPtioRKleAu0uw-upVDhL0h_nLw3BLFnUDg9d5zIdglnywjrPyzDiUTUChYgIgn39JhKQndQhEjvrFPdHOLnULHdXLPl9G2UH2Zj6P31LJl72Lw_l_uo-J0aVf3GRGzcjw"
)

<# Get the metadata service url from discovery service #>
$metadataServiceUrl = Invoke-RestMethod -Method Get -Uri "$($discoveryServiceUrl)/Services?`$filter=ServiceName eq 'MetadataService' and Version eq 2" -UseDefaultCredentials | `
    Select-Object -ExpandProperty value | `
    Select-Object -ExpandProperty ServiceUrl

$headers = @{ "Accept" = "application/json"; "Authorization" = "Bearer $accessToken" }
$body = (Get-Content "$PSScriptRoot/mds-datamart.json" -Raw)
$postUri = "$($metadataServiceUrl)/DataMarts"
Invoke-RestMethod -Method Post -Uri $postUri -Body $body -ContentType "application/json" -Headers $headers -UseBasicParsing -TimeoutSec 600

# $deleteUri = "$($metadataServiceUrl)/DataMarts(193)"
# Invoke-RestMethod -Method Delete -Uri $deleteUri -Headers $headers -UseBasicParsing -TimeoutSec 600

