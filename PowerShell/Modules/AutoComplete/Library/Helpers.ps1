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
