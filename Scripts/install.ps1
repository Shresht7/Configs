# ------------
# Installation
# ------------

# Exit script if not running as administrator
if (-Not (Test-IsElevated)) { Write-Error -Message "Requires Administrator Privileges!"; return }

# Install PowerShell Modules
# --------------------------

Write-Host "Installing PowerShell Modules ..."
Install-Module Terminal-Icons
Install-Module posh-git
Install-Module PSFzf
Install-Module z

# TODO: Add Scoop and WinGet packages

# Update Help for Modules
# -----------------------

Write-Host "Updating Help ..."
Update-Help -Force

# ----------------
# Helper Functions
# ----------------

<#
.SYNOPSIS
Checks if the current script has administrator privileges
.DESCRIPTION
Checks if the current script is running in administrator mode. Return true if it does, false if it doesn't
#>
function Test-IsElevated {
    # Get the ID and security principal of the current user account
    $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $MyPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyIdentity)
    # Check to see if we are currently running in "Administrator" mode
    return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}
