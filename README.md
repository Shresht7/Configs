# Configs

My System Configuration

---

## 📜 [Scripts](Scripts/)

- [`Install.ps1`](Scripts/Install.ps1) - Responsible for setting up the entire system by installing various packages and applications
- [`Symlink.ps1`](Scripts/Symlink.ps1) - Symlinks dotfiles, settings and modules to the right places
- [`Snapshot.ps1`](Scripts/Snapshot.ps1) - Takes a snapshot of system configuration

---

## Git

https://git-scm.com/

### gitconfig

[`.gitconfig`](Git/.gitconfig)

## GitHub

### gh

[GitHub CLI extensions](GitHub/gh/extensions.txt)

## PowerShell

https://learn.microsoft.com/en-us/powershell/

### PowerShell Profile

[`Microsoft.PowerShell_profile.ps1`](PowerShell/Microsoft.PowerShell_profile.ps1)

[About PowerShell Profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.2)
### Oh My Posh

https://ohmyposh.dev/

#### Theme

[`s7.omp.yaml`](PowerShell/Themes/s7.omp.yaml)


![oh-my-posh-prompt-theme](s7-prompt.png)

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

---

## 📕 References

- [dotfiles.github.io][github-dotfiles]


<!-- ===== -->
<!-- LINKS -->
<!-- ===== -->

[github-dotfiles]: https://dotfiles.github.io/
