<#
.SYNOPSIS
Starts an application
.DESCRIPTION
Start an application from the shell:AppsFolder
.PARAMETER AppName
Name of the Application. (Use `Get-StartApps` to get a list of apps)
.EXAMPLE
Start-App Clock
Start the Windows Clock application
.EXAMPLE
Get-StartApps | Invoke-Fzf | Start-App
Interactively select the app using fzf and start it
#>
function Start-App(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]$Name
) {
    $App = Get-StartApps | Where-Object { $_.Name -eq $Name }
    if (-Not $App) { return }
    Start-Process "explorer.exe" -ArgumentList "shell:AppsFolder\$(($App).AppId)"
}
