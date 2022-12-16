# ----------
# Navigation
# ----------

function ~ { Set-Location ~ }; Set-Alias ~ home

# =======
# MODULES
# =======

Import-Module -Name AutoComplete
Import-Module -Name Utilities
Import-Module -Name PSFavorite

# ========
# EXTERNAL
# ========

# ----------
# Oh-My-Posh
# ----------

# https://ohmyposh.dev/

oh-my-posh init pwsh --config "~/Configs/PowerShell/Themes/s7.omp.yaml" | Invoke-Expression

Set-Alias omp oh-my-posh.exe

# ----
# Find
# ----

# https://github.com/sharkdp/fd

# Alias `fd` as `find`
Set-Alias find fd

# ----------
# Fuzzy Find
# ----------

# https://github.com/junegunn/fzf

# Use `fd` instead of `find` in fzf (fuzzy-finder)
$env:FZF_DEFAULT_COMMAND = 'fd --type file'
$env:FZF_DEFAULT_OPTS = '--reverse'

# -----
# PSFzf
# -----

# https://github.com/kelleyma49/PSFzf

Import-Module PSFzf

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+g' -PSReadlineChordReverseHistory 'Ctrl+r'

# ----------
# PSReadLine
# ----------

# https://github.com/PowerShell/PSReadLine

# Usage: https://github.com/PowerShell/PSReadLine#usage
# Sample Profile: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Searching for commands with up/down arrow is really handy.  The
# option "moves to end" is useful if you want the cursor at the end
# of the line while cycling through history like it does w/o searching,
# without that option, the cursor will remain at the position it was
# when you used up arrow, which can be useful if you forget the exact
# string you started the search on.
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Sometimes you enter a command but realize you forgot to do something else first.
# This binding will let you save that command in the history so you can recall it,
# but it doesn't actually execute.
# It also clears the line with RevertLine so the
# undo stack is reset - though redo will still reconstruct the command line.
Set-PSReadLineKeyHandler -Key Alt+w `
    -BriefDescription SaveInHistory `
    -LongDescription "Save current line in history but do not execute" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}

# Sometimes you want to get a property of invoke a member on what you've entered so far
# but you need parenthesis to do that.  This binding will help by putting parenthesis around the current selection,
# or if nothing is selected, the whole line.
Set-PSReadLineKeyHandler -Key 'Ctrl+Shift+(' `
    -BriefDescription ParenthesizeSelection `
    -LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
    -ScriptBlock {
    param($key, $arg)

    # Get the current selection
    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    # Get the current line
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # Parenthesize the selection
    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    # Parenthesize the whole line
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
        [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    }
}

# Invoke the currently selected expression, or if nothing is selected, the whole line.
Set-PSReadLineKeyHandler -Key "Ctrl+Shift+e" `
    -BriefDescription InvokeSelection `
    -LongDescription "Invoke the currently selected expression, or if nothing is selected, the whole line" `
    -ScriptBlock {
    param($key, $arg)

    # Get the current selection
    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    # Get the current line
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # Invoke the selection and replace it with the result
    if ($selectionStart -ne -1) {
        $expression = $line.SubString($selectionStart, $selectionLength)
        $Result = (Invoke-Expression $expression | Out-String).Trim()
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $Result)
    }
    # Invoke the whole line and replace it with the result
    else {
        $expression = $line.SubString($selectionStart, $selectionLength)
        $Result = (Invoke-Expression $expression | Out-String).Trim()
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, $Result)
    }
}

$Env:PSReadLineEnable = $True

# History handler
Set-PSReadLineOption -AddToHistoryHandler {
    param([string]$line)
    $minimumLength = 3
    $sensitive = "password|asplaintext|token|key|secret|hook|webhook"
    return ($Env:PSReadLineEnable -eq $True) -and
        ($line.Length -gt $minimumLength) -and
        ($line[0] -ne ' ') -and
        ($line[0] -ne ';') -and
        ($line -NotMatch $sensitive)
}

# Prevent annoying beeping noises
# Set-PSReadLineOption -BellStyle None

# --------
# Posh-Git
# --------

# https://github.com/dahlbyk/posh-git

Import-Module posh-git


# --------------
# Terminal-Icons
# --------------

# https://www.powershellgallery.com/packages/Terminal-Icons/0.5.0

Import-Module Terminal-Icons

# ------------------
# Z Directory Jumper
# ------------------

Import-Module z

# -------
# PSStyle
# -------

# $PSStyle.Formatting.TableHeader = $PSStyle.Foreground.BrightMagenta
# -------
# PSStyle
# -------

# $PSStyle.Formatting.TableHeader = $PSStyle.Foreground.BrightMagenta
