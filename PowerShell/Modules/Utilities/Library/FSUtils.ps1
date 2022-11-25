# -----------------
# Enter-NewLocation
# -----------------

<#
.SYNOPSIS
Create a new directory and enter it
.DESCRIPTION
Creates a new directory with the given `$Name` and Set-Location to it
.PARAMETER Name
Name of the directory to create and enter into
.EXAMPLE
Enter-NewDirectory project-3
Creates a directory called project-3 and cd into it
#>
function Enter-NewDirectory(
    [Parameter(Mandatory)]
    [string]$Name
) {
    # Create the directory if it does not already exist
    if (-Not (Test-Path $Name)) {
        New-Item -ItemType Directory -Path $Name
    }
    # Set-Location to the directory
    Set-Location $Name
}
Set-Alias mkcdir Enter-NewDirectory

# -----------
# New-Symlink
# -----------

<#
.SYNOPSIS
Create a symlink
.DESCRIPTION
Creates a symbolic-link at the given path to the given target
.PARAMETER Path
Original path
.PARAMETER Target
Path to the targetted location
.EXAMPLE
New-Symlink "$HOME\.gitconfig" "$HOME\Configs\Git\.gitconfig"   # Links $HOME\.gitconfig to $HOME\Configs\Git\.gitconfig
#>
function New-Symlink($Path, $Target) {
    New-Item -ItemType SymbolicLink -Path $Path -Target $Target
}
Set-Alias symlink New-Symlink

<#
.SYNOPSIS
Gets the broken links
.DESCRIPTION
Gets the broken links (that do not point to a valid location) in the given directory.
.PARAMETER $Path
The location where you wish to look inside of.
.EXAMPLE
Get-BrokenSymlinks
# Returns a list of broken symlinks
.EXAMPLE
Get-BrokenSymlinks | Remove-Item -Confirm
# Removes all broken symlinks asking as you go
#>
function Get-BrokenSymlinks(
    # The path to look inside of
    [ValidateScript({ Test-Path $Path })]
    [string]$Path = ".",

    # Search recursively
    [switch]$Recurse
) {
    # Recursively get all children and filter out links. Then filter the links again to those who do not have a valid link target
    Get-ChildItem $Path -Recurse:$Recurse | Where-Object { $null -ne $_.LinkTarget -And -Not (Test-Path -Path $_.LinkTarget) }
}

<#
.SYNOPSIS
Get size of the given path
.DESCRIPTION
Measures the size of the given path
.PARAMETER $Path
Path to measure the size of
.PARAMETER $Recurse
Recursively measure the size of the path
.EXAMPLE
Get-Size
Get the size of the current directory
Get-Size -Recurse
Get the size of the current directory by recursing into sub-directories
#>
function Get-Size(
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Test-Path $_ })]
    [string[]]$Path = ".",

    [switch]$Recurse
) {
    Begin {
        $Output = [System.Collections.ArrayList]::new()
    }
    Process {
        $Item = Get-Item $Path
        
        # If the Item is a directory
        if ($Item.PSIsContainer) {
            $null = $Output.Add(($Item | Get-ChildItem -Recurse:$Recurse | Measure-Object -Sum Length | Select-Object `
                    @{Name = "Name"; Expression = { $Item.Name } },
                    @{Name = "Path"; Expression = { $Item.FullName } },
                    @{Name = "Files"; Expression = { $_.Count } },
                    @{Name = "Size"; Expression = { $_.Sum } },
                    @{Name = "Bytes"; Expression = { $_.Sum } },
                    @{Name = "Kilobytes"; Expression = { $_.Sum / 1Kb } },
                    @{Name = "Megabytes"; Expression = { $_.Sum / 1Mb } },
                    @{Name = "Gigabytes"; Expression = { $_.Sum / 1Gb } }
                ))
        }
        # Else if the item is a file
        else {
            $null = $Output.Add(($Item | Select-Object `
                    @{Name = "Name"; Expression = { $Item.Name } },
                    @{Name = "Path"; Expression = { $Item.FullName } },
                    @{Name = "Size"; Expression = { $_.Length } },
                    @{Name = "Bytes"; Expression = { $_.Length } },
                    @{Name = "Kilobytes"; Expression = { $_.Length / 1Kb } },
                    @{Name = "Megabytes"; Expression = { $_.Length / 1Mb } },
                    @{Name = "Gigabytes"; Expression = { $_.Length / 1Gb } }
                ))
        }
    }
    End {
        return $Output
    }
}
