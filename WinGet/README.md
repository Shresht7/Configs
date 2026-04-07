# WinGet

`winget` is a command-line tool for managing software on Windows. It allows you to search, install, upgrade, and uninstall applications from the command line. WinGet is part of the Windows Package Manager, which provides a unified interface for managing software on Windows.

https://learn.microsoft.com/en-us/windows/package-manager/

---

## Commands

### Search on WinGet

To search for a package on WinGet

```sh
winget search <name>
```

### Install a Package

To install a specific package

```sh
winget install <name>
# or
winget install -e <exact-name>
```

### Uninstall a Package

To uninstall a specific package

```sh
winget uninstall <name>
# or
winget uninstall -e <exact-name>
```

### Show Information about a Package

To show information about a specific package

```sh
winget show <name>
```

### List of WinGet Packages

To list all installed packages

```sh
winget list
```

[`packages.json`](packages.json)

### Upgrade all Packages

To upgrade all installed packages

```sh
winget upgrade --all
```

### Export winget packages

To export all installed packages to the `packages.json` file

```shell
winget export "WinGet/packages.json"
```
### Import winget packages

To install app packages from the `packages.json` file

```shell
winget import "WinGet/packages.json"
```
--

## 📕 References

- [Microsoft Learn: Windows Package Manager](https://learn.microsoft.com/en-us/windows/package-manager/)
- [Microsoft Learn: WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [Microsoft Learn: Intro to Windows Package Manager](https://learn.microsoft.com/en-us/shows/open-at-microsoft/intro-to-windows-package-manager)

## Related

- [Chocolatey](https://chocolatey.org/)
- [Scoop](https://scoop.sh/)
- [PSGallery: Microsoft.WinGet.Client](https://www.powershellgallery.com/packages/Microsoft.WinGet.Client/0.2.1)
