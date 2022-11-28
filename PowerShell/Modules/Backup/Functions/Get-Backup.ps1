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
function Get-Backup([string]$Filter, [string]$BackupPath = $Script:BACKUP_PATH) {
    $Res = Get-ChildItem -Path $BackupPath -Exclude '__BACKUPS__.csv'
    if ($Filter) {
        $Res = $Res | Where-Object { $_.Name -Like $Filter }
    }
    return $Res | Sort-Object LastWriteTime -Descending
}
