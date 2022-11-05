# ------------
# Installation
# ------------

# TODO: Verify Elevated Permissions

# Update Help for Modules
# -----------------------

Write-Host "Updating Help ..."
Update-Help -Force

# Install PowerShell Modules
# --------------------------

Write-Host "Installing PowerShell Modules ..."
Install-Module Terminal-Icons
Install-Module posh-git
Install-Module PSFzf
Install-Module z

# TODO: Add Scoop and WinGet packages
