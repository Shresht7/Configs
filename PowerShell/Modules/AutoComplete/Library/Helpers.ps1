# ----------------
# Helper Functions
# ----------------

# Retrieves package information from the package json
function Get-PackageJson(
    [ValidateScript({ Test-Path $_ })]
    [string]$Path = $PWD.Path
) {
    $PackageJson = Join-Path $Path "package.json"

    return Get-Content $PackageJson -ErrorAction SilentlyContinue | ConvertFrom-Json
}

# Retrieves the list of npm scripts from the package json
function Get-NpmScript(
    [ValidateScript({ Test-Path $_ })]
    [string]$Path = $PWD.Path
) {
    $Package = Get-PackageJson $Path

    if (-Not $Package) { return }

    $scripts = $Package.scripts |
    Get-Member -MemberType NoteProperty |
    Select-Object -Property Name, @{Name = "Script"; Expression = { $Package.scripts.($_.Name) } }

    return $scripts
}
