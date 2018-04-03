function Step-ModuleVersion
{
    [OutputType([Version])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [Version[]]$Version,

        [Parameter(Position = 2)]
        [ValidateSet('Major', 'Minor', 'Build', 'Revision')]
        [string]$By = 'Build'
    )

    process
    {
        foreach ($Item in $Version)
        {
            $NewItem = switch ($By)
            {
                Major
                {
                    New-Object -TypeName Version -ArgumentList $Item.Major + 1, 0, 0, 0
                }
                Minor
                {
                    New-Object -TypeName Version -ArgumentList $Item.Major, $Item.Minor + 1, 0, 0
                }
                Build
                {
                    New-Object -TypeName Version -ArgumentList $Item.Major, $Item.Minor, $Item.Build + 1, 0
                }
                Revision
                {
                    New-Object -TypeName Version -ArgumentList $Item.Major, $Item.Minor, $Item.Build, $Item.Revision + 1
                }
            }

            $NewItem | Add-Member -MemberType NoteProperty -Name Path -Value $Item.Path -PassThru
        }
    }
}