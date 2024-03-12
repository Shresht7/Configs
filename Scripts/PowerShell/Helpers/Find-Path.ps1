<#
.SYNOPSIS
    Find the path of the given program's executable
.DESCRIPTION
    Locates the path for the given program's executable like the Unix `which` command.
.EXAMPLE
    Find-Path git
    Returns C:\Program Files\Git\cmd\git.exe
#>
function Find-Path(
    # Name of the command to lookup
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Program", "Executable")]
    [string] $Command
) {
    Get-Command -Name $Command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
