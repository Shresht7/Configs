# ===
# NPM
# ===

Register-ArgumentCompleter -CommandName npm -ScriptBlock {
    Param($WordToComplete, $CommandAST, $CursorPosition)

    $Tokens = $CommandAST.Extent.Text.Trim() -Split '\s+'
    $Completions = switch ($Tokens[1]) {
        'install' { "--global", "-g"; break }
        'version' { "major", "minor", "patch", "premajor", "preminor", "prepatch", "prerelease", "from-git"; break }
        'update' { "--global", "-g"; break }
        'upgrade' { "--global", "-g"; break }
        'run' { Get-NpmScript; break }
        Default { "install", "run", "start", "--help", "-h", "--version", "-v", "whoami", "update", "upgrade", "uninstall" }
    }

    $Completions | Where-Object { $_ -Like "${WordToComplete}*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
}

# ----------------
# Helper Functions
# ----------------

# Retrieves package information from the package json
function Get-PackageJson(
    [ValidateScript({ Test-Path $_ })]
    [string]$Path = $PWD.Path
) {
    $PackageJson = Join-Path $Path "package.json"

    if (-Not (Test-Path $PackageJson -PathType Leaf)) {
        throw "Could not find a package json"
    }

    return Get-Content $PackageJson | ConvertFrom-Json
}

# Retrieves the list of npm scripts from the package json
function Get-NpmScript(
    [ValidateScript({ Test-Path $_ })]
    [string]$Path = $PWD.Path
) {
    $Package = Get-PackageJson $Path
    $scripts = $Package.scripts | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name }

    return $scripts
}
