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
        [string]$BackupPath = $Script:BACKUP_PATH
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
