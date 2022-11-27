# ============
# AutoComplete
# ============

# GitHub CLI
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# Deno
Invoke-Expression -Command $(deno completions powershell | Out-String)

# NPM
. $PSScriptRoot\Library\npm.ps1
