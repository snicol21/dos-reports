function DosReport {
    param
    (
        [Parameter(ParameterSetName = 'Post', Mandatory = $True)]
        [switch]$Post,
        [Parameter(ParameterSetName = 'Delete', Mandatory = $True)]
        [switch]$Delete,
        [Parameter(ParameterSetName = 'Post')]
        [Parameter(ParameterSetName = 'Delete')]
        [ValidateSet('DataMart', 'Entity', 'Binding')]
        [string]$Type

    )

    switch ($PsCmdlet.ParameterSetName) {
        'Generate' {
            if ($DataMart.IsPresent) {
                
            }
        }
    }
}