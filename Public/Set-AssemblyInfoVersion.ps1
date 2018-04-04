function Set-AssemblyInfoVersion 
{
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Path,

        [Parameter(Mandatory)]
        [Version]$Version,

        [switch]$Recurse
    )

    foreach($Item in $Path)
    {
        Get-ChildItem -Path $Item -Name AssemblyInfo.cs -Recurse:$Recurse | 
            ForEach-Object {
                $NewContent = switch -Regex -File $_ 
                {
                    '^\[assembly: AssemblyVersion\(".*"\)\]$' { "[assembly: AssemblyVersion(`"$($Version.ToString())`")]" } 
                    '^\[assembly: AssemblyFileVersion\(".*"\)\]$' { "[assembly: AssemblyFileVersion(`"$($Version.ToString())`")]" }
                    default { $_ } 
                } 
                
                $NewContent | Set-Content -Path $_ -Encoding UTF8
            }
        }
    }


<#

            $AssemblyInfoFileName = $_
            $AssemblyInfoContents = Get-Content -Path $AssemblyInfoFileName -Encoding UTF8

            $AssemblyInfoContents | 
                ForEach-Object {
                $_ -replace '^\[assembly: AssemblyVersion\(".*"\)\]$', "[assembly: AssemblyVersion(`"$($Version.ToString())`")]" 
                $_ -replace '^\[assembly: AssemblyFileVersion\(".*"\)\]$', "[assembly: AssemblyFileVersion(`"$($Version.ToString())`")]"
            } | 
                Set-Content -Path $AssemblyInfoFileName -Encoding UTF8
            }
#>            