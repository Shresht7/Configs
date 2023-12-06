# Configs

**My System Configurations** --- This repository contains files and information about how I set up my systems. This includes applications, settings and development environments.

> **This whole project is, and will always be, a work-in-progress.**

> **NOTE**: Linux is a recent addition to my workflow, and as such most of this repository is Windows specific. This will improve as I continue to use Linux and gradually make modifications.

---

## 🖋️ Objectives

The goals of this project are:
- to be a central repository of configuration files
- to be a representation of the desired state of my machines
- to host documentation that I can follow to recreate my systems
- to provide scripts that automate the process of configuration
- to get me up to speed on a new machine as soon as possible
- to free my brain from trying to remember all the details and intricacies.

Historically, moving from one system to another has always been a pain point. It took me ages to recreate my workflow on a new computer. The main objective of this repository is to expedite that process.

---

## 📜 [Scripts](Scripts/)

The [`Scripts`](Scripts/) folder contains scripts that help with automating the various tasks associated with the configuration processes.

- [`Install.ps1`](Scripts/PowerShell/Install.ps1) - Responsible for setting up the entire system by installing various packages and applications
- [`Symlink.ps1`](Scripts/PowerShell/Symlink.ps1) - Symlinks dotfiles, settings and modules to the right places
- [`Snapshot.ps1`](Scripts/PowerShell/Snapshot.ps1) - Takes a snapshot of system configuration

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
scoop export > "Scoop/scoopfile.json"
```

#### Import scoopfile

```shell
scoop import "Scoop/scoopfile.json"
```

## Visual Studio Code

https://code.visualstudio.com/

### VS Code Settings

[`settings.json`](VSCode/settings.json)

### VS Code Extensions

[`extensions.txt`](VSCode/extensions.txt)

#### Export VS Code Extensions

```shell
code --list-extensions > "VSCode/extensions.txt"
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
winget export "WinGet/packages.json"
```
### Import winget packages
```shell
winget import "WinGet/packages.json"
```

---

## 📕 References

- [dotfiles.github.io][github-dotfiles]


<!-- ===== -->
<!-- LINKS -->
<!-- ===== -->

[github-dotfiles]: https://dotfiles.github.io/
