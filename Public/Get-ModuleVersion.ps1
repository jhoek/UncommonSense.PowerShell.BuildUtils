function Get-ModuleVersion {
    [OutputType([Version])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [ValidateScript( { Test-Path $_ } )]
        [string[]]$Path
    )

    process 
    {
        [System.Management.Automation.ProviderInfo]$Provider = $null

        foreach($Item in $PSCmdlet.GetResolvedProviderPathFromPSPath($Path, [ref]$Provider))
        {
            New-Object -TypeName Version -ArgumentList (Import-PowerShellDataFile -Path $Path)['ModuleVersion'] | 
                Add-Member -MemberType NoteProperty -Name Path -Value $Item -PassThru
        }
    }    
}