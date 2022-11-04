# ---------------
# HELPER FUNCTION
# ---------------

<#
.SYNOPSIS
Find the path of the given program's executable
.DESCRIPTION
Locates the path for the given program's executable like the Unix `which` command.
.PARAMETER command
Name of the command
.EXAMPLE
Find-Path git		# Returns C:\Program Files\Git\cmd\git.exe
#>
function Find-Path($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# ------
# WinGet
# ------

if (Find-Path winget | Test-Path) {
    Write-Host "Exporting winget packages..."
    winget export .\WinGet\packages.json
    Write-Host "Exported winget packages! ✅"
}
else {
    Write-Error "💥 winget not found ❌"
}

# -----
# Scoop
# -----

if (Find-Path scoop | Test-Path) {
    Write-Host "Exporting scoop apps..."
    scoop export > .\Scoop\scoopfile.json
    Write-Host "Exported scoop apps! ✅"
}
else {
    Write-Error "💥 scoop not found ❌"
}

# ------------------
# VS Code Extensions
# ------------------

if (Find-Path code | Test-Path) {
    Write-Host "Exporting VS Code extensions..."
    code --list-extensions > .\VSCode\extensions.txt
    Write-Host "Exported VS Code extensions! ✅"
}
else {
    Write-Error "💥 code not found ❌"
}
