# -----------
# Backup-Item
# -----------

<#
.SYNOPSIS
Creates a backup of the given item
.DESCRIPTION
Creates a backup-copy of the given item in the specified backup folder (default: $HOME/Archive/Backups).
By default, a .zip archive is created with the backup contents but you can also ask it to copy the item as is.
.EXAMPLE
Backup-Item important-file.txt
Creates an archive (.zip) backup of the important-file.txt in the default backup folder
.EXAMPLE
Backup-Item -Type Copy -Name important-file.txt
Create a copy of the important-file.txt in the default backup folder
.EXAMPLE
Backup-Item -Type Archive -Name important-folder -BackupPath "$HOME/NewBackup"
Creates an archive (.zip) backup of the important-folder in the user defined "$HOME/NewBackup" folder
.EXAMPLE
Backup-Item important-file.txt -HashAlgorithm MD5
Use MD5 algorithm to compute the hash of the backup file
#>
function Backup-Item {

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "MEDIUM")]
    Param (
        # The item to backup
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path $_ })]
        [Alias("Item", "Path", "Input")]
        [string] $Name,

        # The type of backup to create. "Archive" to create a .zip file or "Copy" to copy the contents as is
        [ValidateSet("Archive", "Copy")]
        [string] $Type = "Archive",

        # The algorithm to use to compute the file hash
        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [Alias("Algorithm", "Hash", "Checksum")]
        [string] $HashAlgorithm = "SHA256",
    
        # Path to the backup directory
        [ValidateScript({ Test-Path $_ })]
        [Alias("Output", "DestinationPath")]
        [string] $BackupPath = $Script:BACKUP_PATH,

        # Metadata file - keeps a log of the backup operations
        [string] $MetadataFilePath = (Join-Path $Script:BACKUP_PATH "__BACKUPS__.csv")
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
        if (-Not $PSCmdlet.ShouldProcess($Destination, "Backing up $Name to $Destination")) { return }
        
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
        
        # Create the output object
        $Output = [PSCustomObject]@{
            Name        = $Name
            Source      = $OriginalPath
            Destination = $Destination
            Date        = Get-Date
            Algorithm   = $Hash.Algorithm
            Hash        = $Hash.Hash   
        }

        # Write information to a csv file
        $Output | Export-Csv -Path $MetadataFilePath -Append

        return $Output
    }

    End { }
}
