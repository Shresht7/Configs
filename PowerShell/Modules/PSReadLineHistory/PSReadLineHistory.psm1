# ===========================
# PSReadLineHistory Utilities
# ===========================

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
