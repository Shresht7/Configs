<#
.SYNOPSIS
Run Pester Test Suite
.DESCRIPTION
Runs `Invoke-Pester` on every test powershell script (*.test.ps1)
.PARAMETER $Path
The path to look for test files
.EXAMPLE
Invoke-PesterTestSuite
Invoke the test suite
#>
function Invoke-PesterTestSuite {
    [CmdletBinding()]
    Param (
        [ValidateScript({ Test-Path $_ })]
        [string] $Path = "."
    )

    Get-ChildItem $Path -Recurse `
    | Where-Object { $_.Name -like "*.test.ps1" } `
    | ForEach-Object {
        Write-Verbose -Message "Pester: $($_)"
        Invoke-Pester -Script $_
    }
}
