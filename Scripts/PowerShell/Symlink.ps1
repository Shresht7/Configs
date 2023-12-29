<#
.SYNOPSIS
    Symlinks everything in the right place
.DESCRIPTION
    This script creates symbolic links for dotfiles, PowerShell modules, and settings by reading
    information from the specified CSV file (default: symlinks.csv). The CSV file should contain
    details about which file or directory should be symlinked to its desired target location.
.EXAMPLE
    . .\Scripts\PowerShell\Symlink.ps1
    Run the symlink script to symlink everything specified in the symlinks.csv file
.EXAMPLE
    . .\Scripts\PowerShell\Symlink.ps1 -WhatIf
    Performs a dry run without making any changes
.EXAMPLE
    . .\Scripts\PowerShell\Symlink.ps1 -Confirm
    Prompts you to confirm the action before creating any symlink
.NOTES
    This script requires administrator privileges
#>
[CmdletBinding(SupportsShouldProcess)]
param (
    # Path to the CSV file containing the symlinks
    # Default value is "$PSScriptRoot\symlinks.csv".
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string] $LinksCSVPath = "$PSScriptRoot\symlinks.csv",

    # Force the creation of symbolic links
    [switch] $Force
)

# Check if the file actually exists
if (-Not (Test-Path -Path $LinksCSVPath)) {
    Write-Error -Message "CSV file not found: $LinksCSVPath"
    return
}

# Import helper functions
Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Exit script if not in administrator mode
if (-Not (Test-IsElevated)) {
    Write-Error -Message "⭐ Requires administrator privileges! ⭐"
    return
}

# Import symlink information from the csv file
Write-Verbose "Importing symlink information from CSV file: $LinksCSVPath"
$Links = Import-Csv -Path $LinksCSVPath

# Create symbolic links for dotfiles and settings
foreach ($Link in $Links) {

    $Path = Join-Path $HOME $Link.Path      # The path to create the symbolic link at
    $Target = Join-Path $HOME $Link.Target  # The path the symlink will point to

    if ($PSCmdlet.ShouldProcess($Target, "Symlink $Path")) {
        $null = New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force:$Force
        Write-Verbose "`nSymbolic Link Created:`nPath: $Path`nTarget: $Target`n"
    }

}
