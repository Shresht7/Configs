# ----------
# GitHub CLI
# ----------

if (Find-Path gh | Test-Path) {
    gh extension list > .\GitHub\gh\extensions.txt
    Write-Host "Exported gh extensions! ✅"
}
else {
    Write-Error "💥 gh not found ❌"
}

# ------
# WinGet
# ------

if (Find-Path winget | Test-Path) {
    winget export .\WinGet\packages.json
    Write-Host "Exported winget packages! ✅"
}
else {
    Write-Error "💥 winget not found ❌"
}

# -----
# Scoop
# -----

if (Find-Path scoop | Test-Path) {
    scoop export > .\Scoop\scoopfile.json
    Write-Host "Exported scoop apps! ✅"
}
else {
    Write-Error "💥 scoop not found ❌"
}

# ------------------
# VS Code Extensions
# ------------------

if (Find-Path code | Test-Path) {
    code --list-extensions > .\VSCode\extensions.txt
    Write-Host "Exported VS Code extensions! ✅"
}
else {
    Write-Error "💥 code not found ❌"
}

# -----------------
# Oh My Posh Prompt
# -----------------

# Take a snapshot of the current oh-my-posh prompt
oh-my-posh config export image --cursor-padding 50 --author 'Shresht7' --output s7-prompt.png

Write-Host "Exported Oh My Posh Prompt Screenshot! ✅"

Write-Progress -Activity Snapshot -Completed

# ----------------
# Helper Functions
# ----------------

<#
.SYNOPSIS
Find the path of the given program's executable
.DESCRIPTION
Locates the path for the given program's executable like the Unix `which` command.
.PARAMETER $Command
Name of the command
.EXAMPLE
Find-Path git
Returns C:\Program Files\Git\cmd\git.exe
#>
function Find-Path([string]$Command) {
    Get-Command -Name $Command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
