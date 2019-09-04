<#
.EXAMPLE
Get-PsakeScriptTasks -buildFile ./build.ps1 | ConvertTo-VSCodeTask | ConvertTo-Json -Depth 10 | Set-Content ./.vscode/tasks.json
#>
function ConvertTo-VSCodeTask
{
    param
    (
        # Sadly, Get-PsakeScriptTasks returns vanilla PSCustomObjects,
        # so no possibility for any meaningful type checking here
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
            tasks   = $CachedPsakeTasks.ForEach{
                $task = [ordered]@{
                    label          = $_.Name
                    type           = 'shell'
                    problemMatcher = @(
                        '$msCompile'
                    )
                    command        = "Invoke-Psake -taskList $($_.Name)"
                }

                if ($_.Name -eq 'default')
                {
                    $task.group = @{
                        kind      = 'build'
                        isDefault = $true
                    }
                }

                $task
            }
        }
    }
}