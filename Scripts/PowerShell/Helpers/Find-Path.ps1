<#
.SYNOPSIS
Find the path of the given program's executable
.DESCRIPTION
Locates the path for the given program's executable like the Unix `which` command.
.PARAMETER $Command
Name of the command
.EXAMPLE
Find-Path git
Returns C:\Program Files\Git\cmd\git.exe
#>
function Find-Path([string]$Command) {
    Get-Command -Name $Command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
