# ============
# AutoComplete
# ============

. $PSScriptRoot\Class\Completion.ps1
. $PSScriptRoot\Library\Commands.ps1

# GitHub CLI
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# Deno
Invoke-Expression -Command $(deno completions powershell | Out-String)

# Npm
. $PSScriptRoot\Commands\npm.ps1
