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
Returns the path to the PSReadLine history file
.EXAMPLE
code (Get-PSReadLineHistoryPath)
Opens the PSReadLine history file with VS Code
.EXAMPLE
Set-Location (Split-Path (Get-PSReadLineHistoryPath))
Set-Location to parent folder of the PSReadLine history file
#>
function Get-PSReadLineHistoryPath { (Get-PSReadLineOption).HistorySavePath }

<#
.SYNOPSIS
Get the PSReadLine history contents
.DESCRIPTION
Returns the contents of the PSReadLine history file
.EXAMPLE
Get-PSReadLineHistory
Returns the content of the PSReadLine history file
#>
function Get-PSReadLineHistory { Get-Content (Get-PSReadLineHistoryPath) }

<#
.SYNOPSIS
Set the PSReadLine history contents
.DESCRIPTION
Sets (overwrites) the contents of the PSReadLine history file. Useful after performing
some manipulation on the existing history (using Get-PSReadLineHistory)
.PARAMETER Content
The new contents of the PSReadLine history file
.EXAMPLE
Set-PSReadLineHistory ($Content)
#>
function Set-PSReadLineHistory(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]$Content
) {
    $Path = Get-PSReadLineHistoryPath
    $Temp = "$Path.temp"
    $Content | Out-File $Temp
    Move-Item -Path $Temp -Destination $Path -Force
}

<#
.SYNOPSIS
Gets the frequency of the commands in the history
.DESCRIPTION
Returns a hash-table containing commands from the PSReadLine history and the number of times they've been used
.EXAMPLE
Get-PSReadLineHistoryFrequency
Returns a hash-table containing commands from the PSReadLine history and their usage frequency
#>
function Get-PSReadLineHistoryFrequency {
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

<#
.SYNOPSIS
Remove commands from the PSReadLine history
.DESCRIPTION
Removes the selected commands and updates the PSReadLine history. If no arguments are passed, opens a 
multi-select fzf input that you can use to choose the commands. Any and all commands that match any of
the selection will be removed from the PSReadLine history.
.PARAMETER $MarkedForRemoval
Items that you want to remove from the history. If no arguments are passed, opens a multi-select fzf input
.EXAMPLE
Remove-PSReadLineHistoryItems
Open an interactive multi-select fzf input to selectively remove commands
.EXAMPLE
Remove-PSReadLineHistoryItems "git add ."
Removes the "git add ." command from the history
#>
function Remove-PSReadLineHistoryItems([string]$MarkedForRemoval = (Get-PSReadLineHistory | Invoke-Fzf -Multi -Cycle)) {
    # Get the PSReadLineHistory
    $ReadlineHistory = Get-PSReadLineHistory
	
    # Iterate over all items that are marked-for-removal and filter the ReadLineHistory
    foreach ($filter in $MarkedForRemoval) {
        $ReadlineHistory = $ReadlineHistory | Where-Object { $_ -cne $filter }
    }

    # Set Content of the PSReadLineHistory
    Set-PSReadLineHistory $ReadlineHistory
}

<#
.SYNOPSIS
Remove the last command recorded in the PSReadLine history
.DESCRIPTION
Removes the last x commands from the PSReadLine history
.PARAMETER Count
The number of commands to remove (defaults to 1)
.EXAMPLE
Remove-PSRemoveLast
Remove the last command
.EXAMPLE
Remove-PSRemoveLast 5
Remove the last 5 commands
#>
function Remove-PSReadLineLast([Uint32]$Count = 1) {
    $PSReadLineHistory = Get-PSReadLineHistory
    $Length = $PSReadLineHistory.Length
    $Mark = $Length - $Count
    
    $PSReadLineHistory[$Mark..$Length] | ForEach-Object { Write-Host "[Remove]:" $_ }
    $Check = Read-Host "`nWill Remove the above lines [y/N]" || "N"
    if ($Check -ne "Y") { return }

    # Get everything but the last $Count items (accounting for off-by-one and the current command itself)
    Set-PSReadLineHistory $PSReadLineHistory[0..($Mark - 1)]
}

<#
.SYNOPSIS
Remove duplicate items from the history
.DESCRIPTION
Removes duplicate entries and updates the PSReadLine history
.EXAMPLE
Remove-PSReadLineHistoryDuplicates
Removes duplicate entries from the PSReadLine history only keeping the latest command
#>
function Remove-PSReadLineHistoryDuplicates {
    $answer = Read-Host "Are you sure you want to remove all duplicate history items? [y/N]" || "N"
    if ($answer -NotLike "Y") { return }

    $PSReadLineHistory = Get-PSReadLineHistory
    $originalCount = ($PSReadLineHistory | Measure-Object -Line).Lines

    $PSReadLineHistory = $PSReadLineHistory | Sort-Object -Unique

    $finalCount = ($PSReadLineHistory | Measure-Object -Line).Lines
    $diffCount = $originalCount - $finalCount
    Write-Host "$diffCount duplicate commands removed!"

    Set-PSReadLineHistory $PSReadLineHistory
}
