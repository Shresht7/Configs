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

# ---------
# Find-Path
# ---------

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
Set-Alias which Find-Path

# ----------
# Search-Web
# ----------

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

# --------
# New-Note
# --------

$notebook = "~\OneDrive\Notebooks"
$quickNotes = Join-Path $notebook "Quick-Notes"

<#
.SYNOPSIS
Create a new quick note
.DESCRIPTION
Creates a new markdown file in the Quick-Notes directory and writes contents to it
.PARAMETER content
Contents of the note
.EXAMPLE
New-Note "This is some very important stuff!"	# Creates a new timestamped note (markdown) with the given contents
#>
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
