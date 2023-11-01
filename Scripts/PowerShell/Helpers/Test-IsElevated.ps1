<#
.SYNOPSIS
    Tests if the current user is running in "Administrator" mode
.DESCRIPTION
    The Test-IsElevated function gets the ID and security principal of the current user account, and then
    checks to see if the user is a member of the WindowsBuiltInRole "Administrator" group. If the user is
    a member of the "Administrator" group, the function returns $true. Otherwise, it returns $false.
.OUTPUTS
    System.Boolean
.EXAMPLE
    Test-IsElevated
    Returns $True if the current user is in "Administrator" mode
.NOTES
    This cmdlet is specifically designed for Windows and relies on Windows-specific features to determine if a user is running with administrator privileges.
    Linux doesn't have the concept of administrators in the same way that Windows does, so the cmdlet as-is won't work on Linux.
    The cmdlet will just return $True and let the script proceed as normal.
#>
function Test-IsElevated {
    # Perform the check if only on windows
    if ($PSVersionTable.OS -like "*Windows*") {
        # Get the ID and security principal of the current user account
        $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $MyPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyIdentity)
        # Check to see if we are currently running in "Administrator" mode
        return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    else {
        # otherwise, if not on windows, continue as normal, trust the user and hope for the best!
        # This exists to make powershell scripts that use this compatible with other Operating Systems.
        # This is a band-aid fix.
        return $True # TODO: See if this cmdlet can be made useful on Linux
    }
}
