function New-BinaryModuleManifest
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$ModulePath,

        [Parameter(Mandatory)]
        [string]$Guid,

        [switch]$Hybrid,
        [string]$Author,
        [string]$CompanyName,
        [string]$Copyright,
        [string]$Description,
        [string]$ModuleName = (Get-Item -Path $ModulePath).Name,
        [string]$SanitizedModuleName = [regex]::Replace($ModuleName, '[^\w.]', '')
    )

    $OutputFolderPath = Split-Path -Path $Path -Parent

    $DllFileName = "$($SanitizedModuleName).dll"
    $ScriptFileName = "$($ModuleName).psm1"

    if ($Hybrid)
    {
        $RootModuleFileName = $ScriptFileName
        $NestedModules = @($DllFileName)
    }
    else
    {
        $RootModuleFileName = $DllFileName
        $NestedModules = @()
    }

    $DllFilePath = Join-Path -Path $OutputFolderPath -ChildPath $DllFileName
    $ModuleVersion = (Get-Item -Path $DllFilePath).VersionInfo.ProductVersion -replace '\+.*$', ''
    $TypesPath = Join-Path -Path $ModulePath -ChildPath 'types.ps1xml'
    $TypesToProcess = if (Test-Path -Path $TypesPath) { "$ModuleName.types.ps1xml" }
    $FormatsPath = Join-Path -Path $ModulePath -ChildPath 'format.ps1xml'
    $FormatsToProcess = if (Test-Path -Path $FormatsPath) { "$ModuleName.format.ps1xml" }

    $Types = Add-Type -Path $DllFilePath -PassThru
    $CmdletNames = $Types | ForEach-Object { $_.GetCustomAttributes($true) } | Where-Object { $_ -is [System.Management.Automation.CmdletAttribute] } | ForEach-Object { "$($_.VerbName)-$($_.NounName)" } | Select-Object -Unique
    $AliasNames = $Types | ForEach-Object { $_.GetCustomAttributes($true) } | Where-Object { $_ -is [System.Management.Automation.AliasAttribute] } | ForEach-Object { $_.AliasNames } | Select-Object -Unique

    Write-Verbose "Module Name: $ModuleName"
    Write-Verbose "Module Version: $ModuleVersion"
    Write-Verbose "Root Module Path: $RootModuleFileName"
    Write-Verbose "Nested Module Paths: $NestedModules"
    Write-Verbose "Types Path: $TypesPath"
    Write-Verbose "Types to Process: $TypesToProcess"
    Write-Verbose "Formats Path: $FormatsPath"
    Write-Verbose "Formats to Process: $FormatsToProcess"
    Write-Verbose "Cmdlet Names: $CmdletNames"
    Write-Verbose "Alias Names: $AliasNames"

    New-ModuleManifest `
        -Path $Path `
        -RootModule $RootModuleFileName `
        -NestedModules $NestedModules `
        -ModuleVersion $ModuleVersion `
        -Guid $Guid `
        -Author $Author `
        -CompanyName $CompanyName `
        -Copyright $Copyright `
        -Description $Description `
        -TypesToProcess $TypesToProcess `
        -AliasesToExport $AliasNames `
        -FormatsToProcess $FormatsToProcess `
        -CmdletsToExport $CmdletNames
}