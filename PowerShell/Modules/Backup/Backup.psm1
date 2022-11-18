# ================
# BACKUP UTILITIES
# ================

$DefaultBackupPath = "$HOME\Archives\Backups"

# -----------
# Backup-Item
# -----------

<#
.SYNOPSIS
Creates a backup of the given item
.DESCRIPTION
Creates a backup-copy of the given item in the specified folder
.EXAMPLE
Backup-Item important-file.txt
#>
function Backup-Item(
    [Parameter(Mandatory = $true)]
    [string]$Item,

    [string]$BackupPath = $DefaultBackupPath,
    
    [ValidateSet("Compress", "Copy")]
    [string]$Type = "Compress"
) {
    if (-Not (Test-Path $BackupPath -PathType Container)) {
        $CreateBackup = Read-Host "The backup path [$BackupPath] does not exist! Do you wish to create it [Y/n]" || "Y"
        if ($CreateBackup -like "y") {
            New-Item -ItemType Directory $BackupPath
        }
        else {
            Write-Error "Cannot continue without valid backup path [$BackupPath]"
        }
    }

    $Date = Get-Date -Format FileDateTimeUniversal
    $Name = (Get-Item $Item).Name
    $Destination = Join-Path $BackupPath "$Date`_$Name"

    if ($Type -eq "Compress") {
        Compress-Archive -Path $Item -CompressionLevel Optimal -DestinationPath "$Destination.zip"
    }
    if ($Type -eq "Copy") {
        Copy-Item -Path $Item -Destination $Destination -Recurse
    }
}

# ------------
# Restore-Item
# ------------

<#
.SYNOPSIS
Restores an item from the backup
.DESCRIPTION
Restores the most recent copy of the given item from the defined backup folder
#>
function Restore-Item($Item, $Path = $PWD.Path, $BackupPath = $DefaultBackupPath) {
    $Name = (Get-Item $Item).Name
    $MostRecentItem = Get-ChildItem "$BackupPath\" | Where-Object { $_ -Match $Name } | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
    # Copy-Item -Path "$MostRecentItem\$Name" -Destination "$Path\$Name"
    Expand-Archive -Path $MostRecentItem -DestinationPath $Path
}

# -----------------
# Remove-OldBackups
# -----------------

$retentionDays = -7

<#
.SYNOPSIS
Remove old Backups
.DESCRIPTION
Remove old backup entries older than the retention period (default: 7 days)
#>
function Remove-OldBackups($BackupPath = $DefaultBackupPath, $days = $retentionDays) {
    Get-ChildItem -Path $BackupPath | Where-Object { (Get-Date) -lt $_.CreationTime.AddDays($days) } | Remove-Item
}
