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

# Update Help for Modules
# -----------------------

Write-Host "Updating Help ..."
Update-Help -Force


# TODO: Add Scoop and WinGet packages

# GitHub CLI
# ----------

if (Find-Path gh | Test-Path) {
    Get-Content .\GitHub\gh\extensions.txt | ForEach-Object { gh extension install $_ }
}

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
