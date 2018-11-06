<#
.EXAMPLE
Get-PsakeScriptTasks -buildFile ./build.ps1 | ConvertTo-VSCodeTask | ConvertTo-Json -Depth 10 | Set-Content ./.vscode/tasks.json
#>
function ConvertTo-VSCodeTask
{
    param
    (
        # Sadly, Get-PsakeScriptTasks returns vanilla PSCustomObjects,
        # so no possiblity for meaningful type checking here
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject[]]$PsakeTask
    )

    begin
    {
        $CachedPsakeTasks = New-Object System.Collections.ArrayList
    }

    process
    {
        $CachedPsakeTasks.AddRange($PsakeTask)
    }

    end
    {
        @{
            version = '2.0.0'
            windows = @{
                options = @{
                    shell = @{
                        executable = 'powershell.exe'
                        args       = '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command'
                    }
                }
            }
            linux   = @{
                options = @{
                    shell = @{
                        executable = '/usr/bin/pwsh'
                        args       = '-NoProfile', '-Command'
                    }
                }
            }
            osx     = @{
                options = @{
                    shell = @{
                        executable = '/usr/local/bin/pwsh'
                        args       = '-NoProfile', '-Command'
                    }
                }
            }
            tasks   = $CachedPsakeTasks.ForEach{
                @{
                    label          = $_.Name
                    type           = 'shell'
                    problemMatcher = @(
                        '$msCompile'
                    )
                    command        = "Invoke-Psake -taskList $($_.Name)"
                }
            }
        }
    }
}