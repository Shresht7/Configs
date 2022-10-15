# ----------
# Navigation
# ----------

function ~ { Set-Location ~ }; Set-Alias home ~

# ----------
# Oh-My-Posh
# ----------

# https://ohmyposh.dev/

$OhMyPoshTheme = "~/Configs/PowerShell/Themes/s7.omp.yaml"
oh-my-posh init pwsh --config $OhMyPoshTheme | Invoke-Expression

# --------------
# Terminal-Icons
# --------------

# https://www.powershellgallery.com/packages/Terminal-Icons/0.5.0

Import-Module Terminal-Icons

# ----------
# PSReadLine
# ----------

# https://github.com/PowerShell/PSReadLine

Set-PSReadLineOption -PredictionSource History

# Requires PSReadLine v2.2-prerelease
# Set-PSReadLineOption -PredictionViewStyle ListView
# Set-PSReadLineOption -EditMode Windows

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

function Show-PSReadLineHistory { Get-Content (Get-PSReadLineOption).HistorySavePath }
function Remove-PSReadLineHistory { Remove-Item (Get-PSReadLineOption).HistorySavePath }

# Prevent annoying beeping noises
# Set-PSReadLineOption -BellStyle None

# --------
# Posh-Git
# --------

# https://github.com/dahlbyk/posh-git

Import-Module posh-git

# ----------
# Fuzzy Find
# ----------

# https://github.com/sharkdp/fd

# Use `fd` instead of `find` in fzf (fuzzy-finder)
$env:FZF_DEFAULT_COMMAND = 'fd --type file'

# Alias `fd` as `find`
Set-Alias find fd

function Show-Previews {
	fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --reverse
}
Set-Alias preview Show-Previews

# ------------------
# Z Directory Jumper
# ------------------

Import-Module z

# ----------
# GitHub CLI
# ----------

Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# ---------
# Utilities
# ---------

# Locate the given command's executable
function Find-Path($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
Set-Alias which Find-Path

# TODO: Create a Backup cmdlet
# function Backup($path) {
# 	$backupPath = Join-Path ~\Backup $path
# 	Copy-Item -Path $path -Destination (Join-Path ~\Backup $path)
# 	Write-Output "$path ==> $backupPath"
# }

# TODO?: Symlink cmdlet for easier linking

# TODO: Add URLs to GitHub Repositories and other relavent documentation
# TODO: Improve comments
