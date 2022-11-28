# ================
# BACKUP UTILITIES
# ================

$DefaultBackupPath = "$HOME\Archives\Backups"

# #TODO: MaxBackupCount to keep

# -----------
# Backup-Item
# -----------

<#
.SYNOPSIS
Creates a backup of the given item
.DESCRIPTION
Creates a backup-copy of the given item in the specified backup folder
.EXAMPLE
Backup-Item important-file.txt
Creates an archive (.zip) backup of the important-file.txt in the default backup folder
.EXAMPLE
Backup-Item -Type Copy -Item important-file.txt
Create a copy of the important-file.txt in the default backup folder
.EXAMPLE
Backup-Item -Type Archive -Item important-folder -BackupPath "$HOME/NewBackup"
Creates an archive (.zip) backup of the important-folder in the user defined "$HOME/NewBackup" folder
#>
function Backup-Item {

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "MEDIUM")]
    Param (
        # Path of the item to backup
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateScript({ Test-Path (Resolve-Path $_) })]
        [string]$Name,

        # The type of backup to create. "Archive" to create a `.zip` file or "Copy" to copy the contents as is
        [ValidateSet("Archive", "Copy")]
        [string]$Type = "Archive",

        # The algorithm to use to get file hashes
        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]$HashAlgorithm = "SHA256",
    
        # Path to the backup directory
        [string]$BackupPath = $DefaultBackupPath
    )
    
    Begin {
        # Create the Backup Directory if it doesn't exist
        if (-Not (Test-Path $BackupPath -PathType Container)) {
            Write-Verbose "Creating $BackupPath"
            $null = New-Item -ItemType Directory $BackupPath
        }
    }
    
    Process {
        # Gather Information
        $OriginalPath = Resolve-Path $Name
        $Item = Get-Item $OriginalPath
        $Date = Get-Date -Format FileDateTimeUniversal

        # Determine Destination
        $DestFolder = Join-Path $BackupPath $Item.BaseName
        $Destination = Join-Path $DestFolder "$Date`_$($Item.Name)$(if ($Type -eq "Archive") { ".zip" })"
        
        # Create the destination if it doesn't already exist
        if (-Not (Test-Path $DestFolder)) {
            Write-Verbose "Creating $DestFolder"
            $null = New-Item -ItemType Directory $DestFolder -Force
        }

        # Check Should Process and exit if false
        if (!$PSCmdlet.ShouldProcess($Destination, "Backing up $Name to $Destination")) { return }
        
        # Perform Backup Operation
        switch ($Type) {
            "Archive" {
                Write-Verbose "Archiving $Name`t-->`t$Destination"
                $null = Compress-Archive -Path $Name -CompressionLevel Optimal -DestinationPath $Destination
                break
            }
            "Copy" {
                Write-Verbose "Copying $Name`t-->`t$Destination"
                $null = Copy-Item -Path $Name -Destination $Destination -Recurse
                break
            }
        }

        # Get file hash of the produced backup
        $Hash = Get-FileHash $Destination
        
        $Output = [PSCustomObject]@{
            Name        = $Name
            Source      = $OriginalPath
            Destination = $Destination
            Date        = Get-Date
            Algorithm   = $Hash.Algorithm
            Hash        = $Hash.Hash   
        }

        # Write information down to a csv file
        $Output | Export-Csv -Path "$BackupPath\__BACKUPS__.csv" -Append

        return $Output
    }

    End { }
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
function Restore-Item(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]$Name,

    [ValidateScript({ Test-Path $_ })]
    [string]$Path = ($PWD.Path),

    [string]$BackupPath = $DefaultBackupPath,

    [ValidateSet("Archive", "Copy")]
    [string]$Type = "Archive",

    [switch] $WhatIf,

    [switch] $Confirm,

    # Force the operation
    [switch] $Force
) {
    $MostRecentItem = Get-Backup -Filter *$Name* | Select-Object -First 1

    if (-Not $MostRecentItem) { throw "Failed to find any backups with matching criteria" }

    $Path = Resolve-Path $Path

    # TODO: Select "Archive" or "Copy" based on the file extension
    if ($Type -eq "Archive") {
        Expand-Archive -Path $MostRecentItem -DestinationPath $Path -Confirm:$Confirm -WhatIf:$WhatIf -Force:$Force
    }
    if ($Type -eq "Copy") {
        Copy-Item -Path $MostRecentItem -Destination "$Path\$MostRecentItem" -Confirm:$Confirm -WhatIf:$WhatIf -Force:$Force
    }
}

# ------------
# Get-Backups
# ------------

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
function Get-Backup([string]$Filter, [string]$BackupPath = $DefaultBackupPath) {
    $Res = Get-ChildItem -Path $BackupPath -Exclude '__BACKUPS__.csv'
    if ($Filter) {
        $Res = $Res | Where-Object { $_.Name -Like $Filter }
    }
    return $Res | Sort-Object LastWriteTime -Descending
}

# -----------------
# Remove-OldBackups
# -----------------

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
Remove-OldBackup
Removes any backups that are older than the default age
.EXAMPLE
Remove-OldBackup -Age 5
Remove any backups that are older than 5 days
.EXAMPLE
Remove-OldBackup -Name '*Console*' -Age 14
Removes any backups that match the wildcard `*Console*` and are older than 14 days
.EXAMPLE
Remove-OldBackup -Name '*.ps1' -WhatIf
Shows what will happen if you perform the action `Remove-OldBackup -Name '*.ps1'`
.EXAMPLE
Remove-OldBackup -Age 7 -Confirm
Will ask to confirm before deleting any backups older than 7 days
#>
function Remove-OldBackup(
    [Parameter()]
    [String]$Name,
        
    # TODO: Change this to UInt32 to prevent adding negative days. (Ok while testing)
    [Int32]$Age = 31,
    
    # Path to the backup folder
    [String]$BackupPath = $DefaultBackupPath,

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
