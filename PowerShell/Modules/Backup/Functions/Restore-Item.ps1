# ------------
# Restore-Item
# ------------

<#
.SYNOPSIS
Restores an item from the backup
.DESCRIPTION
Restores the most recent copy of the given item from the defined backup folder
.EXAMPLE
Restore-Item README
Restores the most recent backup of the README to the current directory
.EXAMPLE
Restore-Item -Name README -Path Git
Restores the most recent backup of the README to the `Git` folder
#>
function Restore-Item {

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "HIGH")]
    Param (
        # The item to restore
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("Item", "Input")]
        [string]$Name,
    
        # The path to restore the item to
        [ValidateScript({ Test-Path $_ })]
        [Alias("Output", "DestinationPath")]
        [string]$Path = ($PWD.Path),
    
        # Path to the backup directory
        [ValidateScript({ Test-Path $_ })]
        [string] $BackupPath = $Script:BACKUP_PATH,
    
        [ValidateSet("Archive", "Copy")]
        [string]$Type = "Archive"
    )

    # Get the most recent backup item
    $MostRecentBackup = Get-Backup -Filter *$Name* | Select-Object -First 1

    if (-Not $MostRecentBackup) { throw "Failed to find any backups with matching criteria" }

    # Resolve the destination path
    $Path = Resolve-Path $Path

    # TODO: Select "Archive" or "Copy" based on the file extension

    # Check should process
    if (-Not ($PSCmdlet.ShouldProcess($Path, "Restoring $($MostRecentBackup.Name)"))) { return }

    # Restore Item to the Destination Path
    if ($Type -eq "Archive") {
        Expand-Archive -Path $MostRecentBackup -DestinationPath $Path -Force
    }
    if ($Type -eq "Copy") {
        Copy-Item -Path $MostRecentBackup -Destination "$Path\$MostRecentBackup" -Force
    }
}
