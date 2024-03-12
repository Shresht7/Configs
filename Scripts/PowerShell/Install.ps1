# -----------------------
# Source Helper Functions
# -----------------------

# Import helper functions
Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# ------------
# Installation
# ------------

# Exit script if not running as administrator
if (-Not (Test-IsElevated)) {
    Write-Error -Message "Requires Administrator Privileges!"
    return
}

# Symlink Everything into Place
# -----------------------------
 
. $PSScriptRoot\Symlink.ps1

# Install PowerShell Modules
# --------------------------

$Modules = @(
    "BurntToast",
    "CompletionPredictor",
    "Terminal-Icons",
    "posh-git",
    "PSFzf",
    "z",
    "Microsoft.PowerShell.SecretManagement",
    "Microsoft.PowerShell.SecretStore",
)

Write-Host "Installing PowerShell Modules ..."
foreach ($Module in $Modules) {
    Install-Module -Name $Module -Force
}

# Update Help for Modules
# -----------------------

Write-Host "Updating Help ..."
Update-Help -Force

# WinGet
# ------

if (Find-Path winget | Test-Path) {
    winget import .\WinGet\packages.json
}

# Scoop
# -----

if (Find-Path scoop | Test-Path) {
    scoop import .\Scoop\scoopfile.json
}


# GitHub CLI
# ----------

if (Find-Path gh | Test-Path) {
    Get-Content .\GitHub\gh\extensions.txt | ForEach-Object { gh extension install $_ }
}
