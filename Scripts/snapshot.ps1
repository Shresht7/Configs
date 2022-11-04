# ------
# WinGet
# ------

if ($null -ne (Find-Path winget)) {
    Write-Host "Exporting winget packages..."
    winget export .\WinGet\packages.json
    Write-Host "Exported winget packages! ✅"
}
else {
    Write-Error "💥 winget not found ❌"
}

# -----
# Scoop
# -----

if ($null -ne (Find-Path scoop)) {
    Write-Host "Exporting scoop apps..."
    scoop export > .\Scoop\scoopfile.json
    Write-Host "Exported scoop apps! ✅"
}
else {
    Write-Error "💥 scoop not found ❌"
}

# ------------------
# VS Code Extensions
# ------------------

if ($null -ne (Find-Path code)) {
    Write-Host "Exporting VS Code extensions..."
    code --list-extensions > .\VSCode\extensions.txt
    Write-Host "Exported VS Code extensions! ✅"
}
else {
    Write-Error "💥 code not found ❌"
}
