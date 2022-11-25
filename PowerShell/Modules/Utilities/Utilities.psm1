# =========
# Utilities
# =========

# ---------------------
# File-System Utilities
# ---------------------

. .\Library\FSUtils.ps1

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

# ---------------
# Verify-Elevated
# ---------------

function Test-IsElevated {
    # Get the ID and security principal of the current user account
    $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $MyPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyIdentity)
    # Check to see if we are currently running in "Administrator" mode
    return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}
Set-Alias isAdmin Test-IsElevated

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
