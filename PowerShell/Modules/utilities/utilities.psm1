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
