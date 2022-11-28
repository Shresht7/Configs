# -------------
# Remove-Backup
# -------------

<#
.SYNOPSIS
Remove old Backups
.DESCRIPTION
Remove old backup entries older than the retention period (default: 31 days)
.PARAMETER $Name
Wildcard name to filter the backups
.PARAMETER $Age
Only remove backups older than the given age. (default: 31 days)
.PARAMETER $BackupPath
Path to the backup folder
.EXAMPLE
Remove-Backup
Removes any backups that are older than the default age
.EXAMPLE
Remove-Backup -Age 5
Remove any backups that are older than 5 days
.EXAMPLE
Remove-Backup -Name '*Console*' -Age 14
Removes any backups that match the wildcard `*Console*` and are older than 14 days
.EXAMPLE
Remove-Backup -Name '*.ps1' -WhatIf
Shows what will happen if you perform the action `Remove-Backup -Name '*.ps1'`
.EXAMPLE
Remove-Backup -Age 7 -Confirm
Will ask to confirm before deleting any backups older than 7 days
#>
function Remove-Backup(
    [Parameter()]
    [String]$Name,
        
    # TODO: Change this to UInt32 to prevent adding negative days. (Ok while testing)
    [Int32]$Age = 31,
    
    # Path to the backup folder
    [String]$BackupPath = $Script:BACKUP_PATH,

    # Only show the potential action without performing it
    [switch] $WhatIf,

    # Confirm before performing the action
    [switch] $Confirm
) {
    # Get the list of backups that match the given criteria
    $Backups = if ($null -eq $Name) { Get-ChildItem -Path $BackupPath } else { Get-ChildItem -Path $Backups -Filter $Name }

    # Remove backups older than the set age (in days)
    $Backups | Where-Object { (Get-Date) -lt $_.LastAccessTime.AddDays(-$days) } | Remove-Item -Confirm:$Confirm -WhatIf:$WhatIf
}
