function Update-VSCodeTask
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [string]$BuildFile = './psakefile.ps1'
    )

    Get-PsakeScriptTasks -buildFile $BuildFile |
        ConvertTo-VSCodeTask |
        ConvertTo-Json -Depth 10 |
        Set-Content ./.vscode/tasks.json
}