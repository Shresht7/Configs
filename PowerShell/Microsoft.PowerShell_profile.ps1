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

function Get-PSReadLineHistoryPath { (Get-PSReadLineOption).HistorySavePath }
function Get-PSReadLineHistory { Get-Content (Get-PSReadLineHistoryPath) }

function Remove-PSReadLineHistoryItems($MarkedForRemoval = (Get-PSReadLineHistory | Invoke-Fzf -Multi)) {
	# Get the PSReadLineHistory
	$ReadlineHistory = Get-PSReadLineHistory
	
	# TODO: Add Flag to only remove duplicates (leave 1 entry behind)
	
	# Iterate over all items that are marked-for-removal and filter the ReadLineHistory
	foreach ($filter in $MarkedForRemoval) {
		$ReadlineHistory = $ReadlineHistory | Where-Object { $_ -cne $filter }
	}

	# Set Content of the PSReadLineHistory
	$ReadlineHistory | Set-Content (Get-PSReadLineHistoryPath)
}

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
$env:FZF_DEFAULT_OPTS = '--reverse'

# Alias `fd` as `find`
Set-Alias find fd

function Show-Previews() {
	fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
}
Set-Alias preview Show-Previews

function Show-TLDR() {
	tldr --list | fzf --preview 'tldr --color=always {}' | ForEach-Object { tldr $_ }
}
Set-Alias tldrf Show-TLDR

function Set-FuzzyLocation() {
	fd --type directory | fzf | Set-Location
}
Set-Alias cdf Set-FuzzyLocation

# -----
# PSFzf
# -----

# https://github.com/kelleyma49/PSFzf

Import-Module PSFzf

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+g' -PSReadlineChordReverseHistory 'Ctrl+r'

# -------
# RipGrep
# -------

<#
.SYNOPSIS
Performs full-text search
.DESCRIPTION
Uses ripgrep (rg) and fuzzy-finder (fzf) to perform an interactive full-text search and shows the preview using bat
.PARAMETER text
The text or regular expression to search for
.EXAMPLE
Search-FullText TODO:		# Searches for all file containing TODO:
#>
function Search-FullText($text) {
	# rg $text --line-number | fzf --delimiter=":" --preview 'bat --style=numbers --color=always --highlight-line {2} --line-range {2}: {1}'
	Invoke-PsFzfRipgrep $text
}
Set-Alias fts Search-FullText

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

Import-Module utilities

$notebook = "~\OneDrive\Notebooks"
$quickNotes = Join-Path $notebook "Quick-Notes"
function New-Note($content) {
	$note = Join-Path $quickNotes ((Get-Date -Format FileDateTimeUniversal) + ".md")
	"---"  >> $note
	"createdAt: " + (Get-Date).ToString() >> $note
	"---"  >> $note
	"" >> $note
	$content >> $note
	"" >> $note
}
Set-Alias note New-Note
