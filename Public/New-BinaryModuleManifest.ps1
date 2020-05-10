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

        [string]$Author,
        [string]$CompanyName,
        [string]$Copyright,
        [string]$Description
    )

    $ModuleName = (Get-Item -Path $ModulePath).Name
    $OutputFolderPath = Split-Path -Path $Path -Parent
    $RootModuleFileName = "$($ModuleName).dll"
    $RootModulePath = Join-Path -Path $OutputFolderPath -ChildPath $RootModuleFileName
    $ModuleVersion = (Get-Item -Path $RootModulePath).VersionInfo.ProductVersion
    $TypesPath = Join-Path -Path $ModulePath -ChildPath 'types.ps1xml'
    $TypesToProcess = if (Test-Path -Path $TypesPath) { "$ModuleName.types.ps1xml" }
    $FormatsPath = Join-Path -Path $ModulePath -ChildPath 'format.ps1xml'
    $FormatsToProcess = if (Test-Path -Path $FormatsPath) { "$ModuleName.format.ps1xml" }
    $SourcePaths = Get-ChildItem -Path $ModulePath -Filter *.cs -Recurse
    $CmdletNames = $SourcePaths | Select-String -Pattern '^\s*\[Cmdlet\(Verbs[^.]+\.(\w+),\s+\"(.*)\"' | ForEach-Object { $_.Matches[0] } | ForEach-Object { "$($_.groups[1].Value)-$($_.groups[2].Value)" }
    $AliasNames = $SourcePaths | Select-String -Pattern '^\s*\[Alias\(\"(.*)\"\)\]' | ForEach-Object { $_.Matches[0].Groups[1].Value }

    New-ModuleManifest `
        -Path $Path `
        -RootModule $RootModuleFileName `
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