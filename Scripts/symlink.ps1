# ========
# SYMLINKS
# ========

<#
.SYNOPSIS
Symlinks everything in the right place
.DESCRIPTION
Symlinks dotfiles, powershell modules, and settings to their correct homes
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    # Path to the CSV file containing the symlinks
    [string] $LinksCSVPath = "$PSScriptRoot\symlinks.csv"
)

begin {

    # Test Elevation
    # --------------

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


    # Exit script if not in administrator mode
    if (-Not (Test-IsElevated)) {
        Write-Error -Message "Requires administrator privileges"
        return
    }
    
    # Symlink Paths
    # -------------
    
    $Links = Import-Csv -Path $LinksCSVPath
}

process {
    # Create symbolic links for dotfiles and settings
    foreach ($Link in $Links) {
        if ($PSCmdlet.ShouldProcess($Link.Path)) {
            New-Item -ItemType SymbolicLink -Path $Link.Path -Target $Link.Target -Force | Format-List
        }
    }

}

end {

}
