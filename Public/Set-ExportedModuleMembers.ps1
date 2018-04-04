function Set-ExportedModuleMembers
{
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Path
    )

    process
    {
        foreach ($Item in $Path)
        {
            Import-Module $Item -Force

            $ModuleName = Split-Path -Path $Item -LeafBase
            $FunctionNames = Get-Command -Module $ModuleName -CommandType Function | Select-Object -ExpandProperty Name
            $AliasNames = Get-Command -Module $ModuleName -CommandType Alias | Select-Object -ExpandProperty Name
            $CmdletNames = Get-Command -Module $ModuleName -CommandType Cmdlet | Select-Object -ExpandProperty Name

            Update-ModuleManifest `
                -Path $Item `
                -FunctionsToExport $FunctionNames `
                -AliasesToExport $AliasNames `
                -CmdletsToExport $CmdletNames
        }
    }
}