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
