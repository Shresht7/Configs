# Windows Terminal

Windows Terminal is a modern terminal host application for command-line shells (e.g. PowerShell, bash,WSL etc.)

https://learn.microsoft.com/en-us/windows/terminal/

## ⚙️ Settings

[`settings.json`](settings.json)

## WSL2 - Windows Subsystem for Linux

https://learn.microsoft.com/en-us/windows/wsl/

## 💼 Portable Mode

> https://learn.microsoft.com/en-us/windows/terminal/distributions#windows-terminal-portable

Windows Terminal supports a portable mode, which allows you to run the application without installing it on your system. This is done by saving all data and settings next to the application executable itself, in the same folder. Portable mode let's you carry around or archive a preconfigured installation and run it from a Network share, Cloud Storage or USB drive.

To enable portable mode, you need to create a marker file called `.portable` in the same folder as the Windows Terminal executable (`WindowsTerminal.exe`). This file can be empty, but it must exist for portable mode to be activated. On the next launch, Windows Terminal will detect the `.portable` file and switch to portable mode and create a `settings` folder next to the executable, where it will store all user data and settings.

See https://learn.microsoft.com/en-us/windows/terminal/distributions#enabling-portable-mode

---

## 📕 Reference

- [Windows Terminal - Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/)
- [Custom Prompt Setup - Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/tutorials/custom-prompt-setup)
- [Color Schemes - Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/color-schemes)
- [Actions - Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/actions)
- [Windows Terminal Portable - Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/distributions#windows-terminal-portable)
