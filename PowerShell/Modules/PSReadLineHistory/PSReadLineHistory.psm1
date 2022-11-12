# ===========================
# PSReadLineHistory Utilities
# ===========================

function Get-PSReadLineHistoryPath { (Get-PSReadLineOption).HistorySavePath }
function Get-PSReadLineHistory { Get-Content (Get-PSReadLineHistoryPath) }
function Remove-PSReadLineHistoryItems($MarkedForRemoval = (Get-PSReadLineHistory | Invoke-Fzf -Multi -Cycle)) {
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

<#
.SYNOPSIS
Gets the frequency of the commands in the history
.DESCRIPTION
Returns a hash-table containing commands from the PSReadLine history and the number of times they've been used
#>
function Get-CommandFrequency() {
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
