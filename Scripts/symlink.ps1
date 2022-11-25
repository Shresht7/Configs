# ========
# SYMLINKS
# ========

<#
.SYNOPSIS
Symlinks everything in the right place
.DESCRIPTION
Symlinks dotfiles, powershell modules, and settings to their correct homes
#>

[CmdletBinding()]
param (
    # Shows the potential consequences of your actions. Does not actually perform them
    [Parameter()]
    [switch]$WhatIf = $WhatIfPreference,

    # If True, will ask you to confirm before performing any modification
    [Parameter()]
    [switch]$Confirm
)

# Exit script if not in administrator mode
if (-Not (Test-IsElevated)) { Write-Error -Message "Requires administrator privileges"; return }

# Symlink Paths
# -------------

$Links = @(
    @{
        Path   = "$HOME\.gitconfig"
        Target = "$HOME\Configs\Git\.gitconfig"
    }
    @{
        Path   = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
        Target = "$HOME\Configs\PowerShell\Microsoft.PowerShell_profile.ps1"
    }
    @{
        Path   = "$HOME\AppData\Roaming\Code\User\settings.json"
        Target = "$HOME\Configs\VSCode\settings.json"
    }
    @{
        Path   = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        Target = "$HOME\Configs\Windows-Terminal\settings.json"
    }
)

# Create symbolic links for dotfiles and settings
foreach ($Link in $Links) {
    New-Item -ItemType SymbolicLink -Path $Link.Path -Target $Link.Target -Force -WhatIf:$WhatIf -Confirm:$Confirm | Format-List
}

# Symlink PowerShell Modules
# --------------------------

# Create symbolic links for powershell modules
Get-ChildItem "$HOME\Configs\PowerShell\Modules" | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$HOME\Documents\PowerShell\Modules\$($_.Name)" -Target "$HOME\Configs\PowerShell\Modules\$($_.Name)" -Force -WhatIf:$WhatIf -Confirm:$Confirm | Format-List
}

# -------
# Helpers
# -------

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
