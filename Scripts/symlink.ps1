# ========
# SYMLINKS
# ========

<#
.SYNOPSIS
Shorthand to create a symlink
.DESCRIPTION
Creates a symlink at the given path to the given target
.PARAMETER Path
Original path to create the symlink
.PARAMETER Target
Path to the targetted location
.EXAMPLE
Set-Symlink "$HOME\.gitconfig" "$HOME\Configs\Git\.gitconfig"   # Links $HOME\.gitconfig to $HOME\Configs\Git\.gitconfig
#>
function Set-Symlink($Path, $Target) {
    if (Test-Path $Path) { Remove-Item $Path }
    New-Item -ItemType SymbolicLink -Path $Path -Target $Target
}

# ---
# Git
# ---

Set-Symlink -Path "$HOME\.gitconfig" -Target "$HOME\Configs\Git\.gitconfig"

# ---------- 
# PowerShell
# ----------

# Profile
Set-Symlink -Path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$HOME\Configs\PowerShell\Microsoft.PowerShell_profile.ps1"

# Modules
Get-ChildItem "$HOME\Configs\PowerShell\Modules" | ForEach-Object {
    $ModuleName = $_.Name
    Set-Symlink -Path $HOME\Documents\PowerShell\Modules\$ModuleName -Target $HOME\Configs\PowerShell\Modules\$ModuleName
}

# ------
# VSCode
# ------

Set-Symlink -Path "$HOME\AppData\Roaming\Code\User\settings.json" -Target "$HOME\Configs\VSCode\settings.json"

# ----------------
# Windows Terminal
# ----------------

Set-Symlink -Path "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target "$HOME\Configs\Windows-Terminal\settings.json"
