# ================
# BACKUP UTILITIES
# ================

$Script:BACKUP_PATH = "$HOME\Archives\Backups"

# #TODO: MaxBackupCount to keep

Get-ChildItem "$PSScriptRoot\Functions" -Filter '*.ps1' | ForEach-Object {
    . $_.FullName
}
