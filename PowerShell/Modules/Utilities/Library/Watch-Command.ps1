<#
.SYNOPSIS
Execute a script-block periodically
.DESCRIPTION
Periodically execute a script-block on a given time interval.
This allows to see the program output change over time. By default the interval is set to 1 second.
This script-block runs until explicitly stopped.
.PARAMETER $ScriptBlock
The Script-Block to execute repeatedly
.PARAMETER $Interval
The update interval timespan
.PARAMETER $ClearHost
Switch to clear the host screen on each tick
.EXAMPLE
Watch-Command { Get-Date }
Will execute `Get-Date` every second
.EXAMPLE
Watch-Command { Get-Date } -Interval 60
Will execute `Get-Date` every 60 seconds
#>
function Watch-Command(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [scriptblock] $ScriptBlock,

    [int32] $Interval = 1,

    [switch] $ClearHost
) {
    while ($True) {
        if ($ClearHost) { Clear-Host }
        $ScriptBlock.Invoke()
        Start-Sleep $Interval
    }
}
