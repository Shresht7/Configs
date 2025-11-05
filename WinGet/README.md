# WinGet

https://learn.microsoft.com/en-us/windows/package-manager/winget/

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

## 📕 References

- [Microsoft Learn: Windows Package Manager](https://learn.microsoft.com/en-us/windows/package-manager/)
- [Microsoft Learn: WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
