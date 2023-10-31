# -----------------------
# Source Helper Functions
# -----------------------

# Import helper functions
Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# ----------
# GitHub CLI
# ----------

if (Find-Path gh | Test-Path) {
    gh extension list > .\GitHub\gh\extensions.txt
    Write-Host "Exported gh extensions! ✅"
}

# ------
# WinGet
# ------

if (Find-Path winget | Test-Path) {
    winget export .\WinGet\packages.json
    Write-Host "Exported winget packages! ✅"
}

# -----
# Scoop
# -----

if (Find-Path scoop | Test-Path) {
    scoop export > .\Scoop\scoopfile.json
    Write-Host "Exported scoop apps! ✅"
}

# ------------------
# VS Code Extensions
# ------------------

if (Find-Path code | Test-Path) {
    code --list-extensions > .\VSCode\extensions.txt
    Write-Host "Exported VS Code extensions! ✅"
}

# -----------------
# Oh My Posh Prompt
# -----------------

# Take a snapshot of the current oh-my-posh prompt
oh-my-posh config export image --cursor-padding 50 --author 'Shresht7' --output s7-prompt.png

Write-Host "Exported Oh My Posh Prompt Screenshot! ✅"

Write-Progress -Activity Snapshot -Completed
