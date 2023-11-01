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
    This is a windows specific cmdlet.
#>
function Test-IsElevated {
    if ($PSVersionTable.OS -like "Windows") {
        # Get the ID and security principal of the current user account
        $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $MyPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyIdentity)
        # Check to see if we are currently running in "Administrator" mode
        return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    }
}
