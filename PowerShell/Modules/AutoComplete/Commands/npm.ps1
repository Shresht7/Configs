# ===
# NPM
# ===

# TODO: Add the remaining commands as needed

$NPMCommands = @(
    [Completion]::new('audit', 'Run a security audit', @(
            [Completion]::new('fix', 'Apply remediation to the package tree')
            [Completion]::new('signatures', 'Verify the signature of the downloaded packages')
        ))
    [Completion]::new('install', 'Install a package', @(
            [Completion]::new('-g', 'Global')
            [Completion]::new('--global', 'Global')
            [Completion]::new('--save-dev', 'Save as dev-dependency')
        ))
    [Completion]::new('run', 'Run arbitrary script package', @(), {
            (Get-NpmScript | ForEach-Object { [Completion]::new($_.Name, $_.Script) })
        })
    [Completion]::new('search', 'Search for packages')
    [Completion]::new('start', 'Start a package')
    [Completion]::new('stop', 'Stop a package')
    [Completion]::new('test', 'Test a package')
    [Completion]::new('token', 'Manage your authentication tokens', @(
            [Completion]::new('list', 'Show a table of all active authentication tokens')
            [Completion]::new('revoke', 'Remove an authentication token')
            [Completion]::new('create', 'Create a new authentication token')
        ))
    [Completion]::new('uninstall', 'Remove a package')
    [Completion]::new('update', 'Update packages', @(
            [Completion]::new('--global', 'Update global packages')
        ))
    [Completion]::new('version', 'Bump a package version', @(
            [Completion]::new('major')
            [Completion]::new('minor')
            [Completion]::new('patch')
            [Completion]::new('premajor')
            [Completion]::new('preminor')
            [Completion]::new('prepatch')
            [Completion]::new('prerelease')
            [Completion]::new('from-git')
        ))
    [Completion]::new('whoami', 'Display npm username', @(
            [Completion]::new('--registry', 'The base URL of the npm registry (Default: "https://registry.npmjs.org/")')
        ))
)

Register-CommandCompleter -Name npm -Tooltip 'Node Package Manager' -Completions $NPMCommands
