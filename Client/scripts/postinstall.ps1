param (
    [Parameter(Mandatory = $true)]
    [hashtable]$modules
)

$saveToPath = "$(Split-Path $PSScriptRoot -Parent)\pwsh_modules";

# download modules from powershell gallery
foreach ($module in $modules.GetEnumerator()) {
    Find-Module -Name $module.Key -RequiredVersion $module.Value -Repository 'PSGallery' | `
        Save-Module -Path $saveToPath -Force
    Write-Host "Downloaded $($module.Key) version $($module.Value) from PSGallery"
}

# consolidate pwsh_modules
$subModules = @( Get-ChildItem -Path $saveToPath\*\*\* -Include *.psd1 -Recurse -ErrorAction SilentlyContinue )
foreach ($subModule in $subModules) {
    $dir = "$saveToPath\$($subModule.BaseName)";
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir -ErrorAction Stop | Out-Null }
    Copy-Item -Path "$(Split-Path $subModule.FullName -Parent)\*" -Destination $dir -Force -Recurse
    Remove-Item "$(Split-Path $subModule.FullName -Parent)\*" -Force -Recurse
}

# remove any empty folders
Get-ChildItem $saveToPath -Force -Recurse | `
    Where-Object { $_.psiscontainer -and (Get-ChildItem $_.FullName -Force -Recurse | Where-Object { !$_.psiscontainer }).count -eq 0 } | `
    Remove-Item -Recurse -Force