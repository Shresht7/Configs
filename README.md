# Configs

Configuration of my system. 

---

## Scripts

### Symlinks

[`symlink.ps1`](Scripts/symlink.ps1) - Symlinks dotfiles to the correct places

---

## Git

https://git-scm.com/

### gitconfig

[`.gitconfig`](Git/.gitconfig)

## PowerShell

https://learn.microsoft.com/en-us/powershell/

### PowerShell Profile

[`Microsoft.PowerShell_profile.ps1`](PowerShell/Microsoft.PowerShell_profile.ps1)

[About PowerShell Profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.2)
### Oh My Posh

https://ohmyposh.dev/

#### Theme

[`s7.omp.yaml`](PowerShell/Themes/s7.omp.yaml)

<!-- TODO: Add Screenshot of Oh My Posh Prompt -->

## Scoop

https://scoop.sh/

### List of Scoop Apps

[`scoopfile.json`](Scoop/scoopfile.json)

#### Export scoopfile

```shell
scoop export > Scoop\scoopfile.json
```

#### Import scoopfile

```shell
scoop import Scoop\scoopfile.json
```

## Visual Studio Code

https://code.visualstudio.com/

### VS Code Settings

[`settings.json`](VSCode/settings.json)

### VS Code Extensions

[`extensions.txt`](VSCode/extensions.txt)

#### Export VS Code Extensions

```shell
code --list-extensions > VSCode\extensions.txt
```

## Windows Terminal

https://learn.microsoft.com/en-us/windows/terminal/

### Settings

[`settings.json`](Windows-Terminal/settings.json)

### WSL2 - Windows Subsystem for Linux

https://learn.microsoft.com/en-us/windows/wsl/

### CaskaydiaCove Nerd Font

https://www.nerdfonts.com/

## WinGet

https://learn.microsoft.com/en-us/windows/package-manager/winget/

### List of WinGet Packages

[`packages.json`](WinGet/packages.json)

### Export winget packages
```shell
winget export WinGet\packages.json
```
### Import winget packages
```shell
winget import WinGet\packages.json
```
