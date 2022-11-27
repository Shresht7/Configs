# ===
# NPM
# ===

$NPMCommands = @(
    [Completion]::new('install', 'Install a package', @(
            [Completion]::new('-g', 'Global')
            [Completion]::new('--global', 'Global')
            [Completion]::new('--save-dev', 'Save as dev-dependency')
        ))
    [Completion]::new('run', 'Run arbitrary script package', @(
            (Get-NpmScript | ForEach-Object { [Completion]::new($_.Name, $_.Script) })
        ))
)

Register-CommandCompleter -Name npm -Tooltip 'Node Package Manager' -Completions $NPMCommands
