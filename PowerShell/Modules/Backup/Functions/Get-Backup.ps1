# ----------
# Get-Backup
# ----------

<#
.SYNOPSIS
Get the list of backups
.DESCRIPTION
Returns the directory listing of the backup directory
.EXAMPLE
Get-Backup
Returns a list of all backups
.EXAMPLE
Get-Backup -Filter '*Console*'
Returns a list of backups that match the given criteria
#>
function Get-Backup(
    # Filter the list of backup items
    [Alias("Name", "Item")]
    [string] $Filter,

    # Backups location
    [ValidateScript({ Test-Path $_ })]
    [Alias("Path", "Destination", "DestinationPath")]
    [string]$BackupPath = $Script:BACKUP_PATH
) {
    $Res = Get-ChildItem -Path $BackupPath -Exclude '__BACKUPS__.csv' -Recurse
    if ($Filter) {
        $Res = $Res | Where-Object { $_.Name -Like $Filter }
    }
    return $Res | Sort-Object LastWriteTime -Descending
}
