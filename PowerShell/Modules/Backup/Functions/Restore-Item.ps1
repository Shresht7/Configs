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

    [string]$BackupPath = $Script:BACKUP_PATH,

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
