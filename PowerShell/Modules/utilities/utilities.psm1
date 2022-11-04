# =========
# UTILITIES
# =========

# -----------------
# Enter-NewLocation
# -----------------

<#
.SYNOPSIS
Create a new directory and enter it
.DESCRIPTION
Creates a new directory with the given `DirName` and Set-Location to it
.PARAMETER DirName
Name of the directory
.EXAMPLE
New-Directory project-3		# Creates a directory called project-3 and cd into it
#>
function Enter-NewDirectory($DirName) {
    if (!Test-Path $DirName) {
        New-Item -ItemType Directory -Path $DirName
    }
    Set-Location $DirName
}
Set-Alias mkcdir Enter-NewDirectory

# -----------
# New-Symlink
# -----------

<#
.SYNOPSIS
Create a symlink
.DESCRIPTION
Creates a symbolic-link at the given path to the given target
.PARAMETER Path
Original path
.PARAMETER Target
Path to the targetted location
.EXAMPLE
New-Symlink "$HOME\.gitconfig" "$HOME\Configs\Git\.gitconfig"   # Links $HOME\.gitconfig to $HOME\Configs\Git\.gitconfig
#>
function New-Symlink($Path, $Target) {
    New-Item -ItemType SymbolicLink -Path $Path -Target $Target
}
Set-Alias symlink New-Symlink
