# ===========================
# PSReadLineHistory Utilities
# ===========================

<#
.SYNOPSIS
Get the path to the PSReadLine history file
.DESCRIPTION
Returns the path to the PSReadLine history file
.EXAMPLE
Get-PSReadLineHistoryPath
.EXAMPLE
code (Get-PSReadLineHistoryPath)
.EXAMPLE
Set-Location (Split-Path (Get-PSReadLineHistoryPath))
#>
function Get-PSReadLineHistoryPath { (Get-PSReadLineOption).HistorySavePath }

<#
.SYNOPSIS
Get the PSReadLine history contents
.DESCRIPTION
Returns the contents of the PSReadLine history file
.EXAMPLE
Get-PSReadLineHistory
#>
function Get-PSReadLineHistory { Get-Content (Get-PSReadLineHistoryPath) }

<#
.SYNOPSIS
Set the PSReadLine history contents
.DESCRIPTION
Sets (overwrites) the contents of the PSReadLine history file. Useful after performing
some manipulation on the existing history (using Get-PSReadLineHistory).
.EXAMPLE
$content = ...
Set-PSReadLineHistory $content
#>
function Set-PSReadLineHistory($Content) { Set-Content -Path (Get-PSReadLineHistoryPath) -Value $Content }

<#
.SYNOPSIS
Remove commands from the PSReadLine history
.DESCRIPTION
Removes the selected commands and updates the PSReadLine history. If no arguments are passed, opens a 
multi-select Fzf input that you can use to choose the commands. Any and all commands that match any of
the selection will be removed from the PSReadLine history.
.INPUTS $MarkedForRemoval
Items that you want to remove from the history. If no arguments are passed, opens a multi-select fzf input
.EXAMPLE
Remove-PSReadLineHistoryItems
.EXAMPLE
Remove-PSReadLineHistoryItems "git add ."
#>
function Remove-PSReadLineHistoryItems($MarkedForRemoval = (Get-PSReadLineHistory | Invoke-Fzf -Multi -Cycle)) {
    # Get the PSReadLineHistory
    $ReadlineHistory = Get-PSReadLineHistory
	
    # TODO: Add Flag to only remove duplicates (leave 1 entry behind)
	
    # Iterate over all items that are marked-for-removal and filter the ReadLineHistory
    foreach ($filter in $MarkedForRemoval) {
        $ReadlineHistory = $ReadlineHistory | Where-Object { $_ -cne $filter }
    }

    # Set Content of the PSReadLineHistory
    Set-PSReadLineHistory ($ReadlineHistory)
}

<#
.SYNOPSIS
Remove duplicate items from the history
.DESCRIPTION
Removes duplicate entries and updates the PSReadLine history
.EXAMPLE
Remove-PSReadLineHistoryDuplicates
#>
function Remove-PSReadLineHistoryDuplicates() {
    $answer = Read-Host "Are you sure you want to remove all duplicate history items? [y/N]" || "N"
    if ($answer -NotLike "Y") { return }

    $PSReadLineHistory = Get-PSReadLineHistory
    $originalCount = ($PSReadLineHistory | Measure-Object -Line).Lines

    # Iterate backwards to preserve the most recent command
    $commands = New-Object System.Collections.ArrayList
    for ($i = $originalCount; $i -gt 0; $i--) {
        $line = $PSReadLineHistory[$i]
        if (!$commands.Contains($line)) {
            $null = $commands.Add($line)
        }
    }

    $finalCount = ($commands | Measure-Object -Line).Lines
    $diffCount = $originalCount - $finalCount
    Write-Host "$diffCount duplicate commands removed!"

    Set-PSReadLineHistory ($commands)
}

<#
.SYNOPSIS
Gets the frequency of the commands in the history
.DESCRIPTION
Returns a hash-table containing commands from the PSReadLine history and the number of times they've been used
.EXAMPLE
Get-PSReadLineHistoryFrequency
#>
function Get-PSReadLineHistoryFrequency() {
    $frequency = @{}
    foreach ($line in Get-PSReadLineHistory) {
        if (!$frequency[$line]) {
            $frequency.Add($line, 1)
        }
        else {
            $frequency[$line]++
        }
    }
    $sorted = $frequency.GetEnumerator() | Sort-Object -Property Value
    Write-Output $sorted
}
