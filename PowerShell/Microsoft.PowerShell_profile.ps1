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
function Show-PSReadLineHistory { Get-Content (Get-PSReadLineHistoryPath) }
function Remove-PSReadLineHistory { Remove-Item (Get-PSReadLineHistoryPath) }

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
	rg $text --line-number | fzf --delimiter=":" --preview 'bat --style=numbers --color=always --highlight-line {2} --line-range {2}: {1}'
}

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

<#
.SYNOPSIS
Find the executable path for the given program
.DESCRIPTION
Locates the executable path for the given program like the Unix which command.
.PARAMETER command
Name of the command
.EXAMPLE
Find-Path git		# Returns C:\Program Files\Git\cmd\git.exe
#>
function Find-Path($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
Set-Alias which Find-Path

<#
.SYNOPSIS
Search the web
.DESCRIPTION
Launches the default web-browser to do a web-search using a search-engine
.PARAMETER query
The search query to perform
.PARAMETER engine
The search engine to use to perform the search
.EXAMPLE
Search-Web 'PowerShell Documentation'			# Searches the web for 'PowerShell Documentation' using the default search engine
Search-Web 'Microsoft PowerToys' bing			# Searches the web for 'Microsoft PowerToys' using the 'bing' search engine
Search-Web -engine github -query 'Terminal'		# Searches GitHub for 'Terminal'
#>
function Search-Web($query, $engine = "google") {
	# Prompt for query if null
	if ($null -eq $query) {
		$query = Read-Host "Search Query "
	}
	# Load and parse search-engine data  # TODO: Move the searchEngines.json file someplace central so that it can be used by other programs
	$searchEngines = Get-Content "~\Configs\PowerShell\searchEngines.json" | ConvertFrom-Json | Where-Object { $_.shortcut -ieq $engine }
	# Encode the query string
	$encodedQuery = [System.Web.HttpUtility]::UrlEncode($query)
	# Build the search query URL
	$search = $searchEngines | ForEach-Object { $_.url.Replace("%s", $encodedQuery) }
	# Launch the URL using the Start-Process cmdlet (opens the URL with the default browser)
	Start-Process $search
}

# TODO: Create Backup Helper
# function Backup-Item($item, $backupPath) {
# 	if (Test-Path $item) {
# 		$dateTime = Get-Date -Format FileDateTime
# 		$backupPath = Join-Path ~\Backup $item+$dateTime
# 		# Copy-Item -Path $item -Destination $backupPath
# 		Write-Output "$item ==> $backupPath"
# 	}
# 	else {
# 		Write-Output "Failed to find $item"
# 	}
# }
# Set-Alias backup Backup-Item

# TODO?: Symlink cmdlet for easier linking

# TODO: Add URLs to GitHub Repositories and other relavent documentation
# TODO: Improve comments
