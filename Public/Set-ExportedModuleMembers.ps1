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
            Write-Verbose "Importing module $Item"
            Import-Module $Item -Force

            $ModuleName = (Get-Item -Path $Item).BaseName
            Write-Verbose "Module name is $ModuleName"

            $FunctionNames = Get-Command -Module $ModuleName -CommandType Function | Select-Object -ExpandProperty Name
            Write-Verbose "Function names are $($FunctionsNames -join ', ')"
            if ($FunctionNames) { Update-ModuleManifest -Path $Item -FunctionsToExport $FunctionNames }

            $AliasNames = Get-Command -Module $ModuleName -CommandType Alias | Select-Object -ExpandProperty Name
            Write-Verbose "Alias names are $($AliasNames -join ', ')"
            if ($AliasNames) { Update-ModuleManifest -Path $Item -AliasesToExport $AliasNames} 

            $CmdletNames = Get-Command -Module $ModuleName -CommandType Cmdlet | Select-Object -ExpandProperty Name
            Write-Verbose "Cmdlet names are $($CmdletNames -join ', ')"
            if ($CmdletNames) { Update-ModuleManifest -Path $Item -CmdletsToExport $CmdletNames }
        }
    }
}