function Step-ModuleVersion {
    [OutputType([Version])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [Version[]]$Version,

        [Parameter(Position = 2)]
        [ValidateSet('Major', 'Minor', 'Build', 'Revision')]
        [string]$By = 'Build'
    )

    process {
        foreach ($Item in $Version) {
            switch ($By) {
                Major {
                    
                }
            }
        }
    }
}