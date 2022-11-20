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
        $Destination = Join-Path $BackupPath $Item.BaseName "$Date`_$($Item.Name)"
        $Hash = Get-FileHash $Item -Algorithm $HashAlgorithm
    
        # Create the destination if it doesn't already exist
        if (-Not (Test-Path $Destination)) {
            Write-Verbose "Creating $Destination"
            $null = New-Item $Destination -Force
        }

        # Check Should Process and exit if false
        if (!$PSCmdlet.ShouldProcess($Destination, "Backing up $Name to $Destination")) { return }
        
        # Perform Backup Operation
        switch ($Type) {
            "Archive" {
                Write-Verbose "Archiving $Name`t-->`r$Destination"
                $null = Compress-Archive -Path $Name -CompressionLevel Optimal -DestinationPath "$Destination.zip"
                break
            }
            "Copy" {
                Write-Verbose "Copying $Name`t-->`t$Destination"
                $null = Copy-Item -Path $Name -Destination $Destination -Recurse
                break
            }
        }

        
        $Output = [PSCustomObject]@{
            Name        = $Name
            Source      = $OriginalPath
            Destination = $Destination
            Date        = Get-Date
            Algorithm   = $Hash.Algorithm
            Hash        = $Hash.Hash   
        }

        $Output | Export-Csv -Path "$BackupPath\backups.csv"

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
    [Parameter(Mandatory = $True)]
    [string]$Item,

    [string]$Path = $PWD.Path,

    [string]$BackupPath = $DefaultBackupPath,

    [ValidateSet("Archive", "Copy")]
    [string]$Type = "Archive"
) {
    $MostRecentItem = Get-Backups -Filter *$Item* | Select-Object -First 1

    # TODO: Select "Archive" or "Copy" based on the file extension
    if ($Type -eq "Archive") {
        Expand-Archive -Path $MostRecentItem -DestinationPath $Path -Confirm
    }
    if ($Type -eq "Copy") {
        Copy-Item -Path "$MostRecentItem\$Name" -Destination "$Path\$Name"
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
Get-Backups
#>
function Get-Backups([string]$Filter, [string]$BackupPath = $DefaultBackupPath) {
    Get-ChildItem -Path $BackupPath -Filter $Filter | Sort-Object LastWriteTime -Descending
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
#>
function Remove-OldBackups(
    [Parameter()]
    [String]$Name,
        
    # TODO: Change this to UInt32 to prevent adding negative days. (Ok while testing)
    [Int32]$Age = 31,
    
    [String]$BackupPath = $DefaultBackupPath
) {
    # Get the list of backups that match the given criteria
    $Backups = if ($null -eq $Name) { Get-ChildItem -Path $BackupPath } else { Get-ChildItem -Path $Backups -Filter $Name }

    # Remove backups older than the set age (in days)
    $Backups | Where-Object { (Get-Date) -lt $_.CreationTime.AddDays(-$days) } | Remove-Item -Confirm
}
