# Scoop

https://scoop.sh/

A package manager for windows

Scoop manages packages in a portable way, keeping them all isolated in a single directory (by default `C:\Users\<UserName>\scoop`).

## Installation

```pwsh
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

> [!NOTE]
> If this is the first time you are running an external script, you will need to change the PowerShell's execution policy. This policy provides a safety mechanism to prevent the execution of malicious scripts. You can set the execution policy to `RemoteSigned` which allows you to run local scripts without signing, but requires that scripts downloaded from the internet are signed by a trusted publisher. You can set the execution policy by running the following command in an elevated PowerShell session (Run as Administrator):
>
>   ```pwsh
>   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
>   ```

## Search

```pwsh
scoop search <app-name>
```

## List installed apps

```pwsh
scoop list
```

## Install an app

```pwsh
scoop install <app-name>
```

## Uninstall an app

```pwsh
scoop uninstall <app-name>
```

## Update an app

```pwsh
scoop update <app-name>
```

## Update Scoop and all installed apps

```pwsh
scoop update --all
```
## To update scoop itself

```pwsh
scoop update
```

## List of Scoop Apps

[`scoopfile.json`](scoopfile.json)

### Export `scoopfile`

```pwsh
scoop export > "Scoop/scoopfile.json"
```

### Import `scoopfile`

```pwsh
scoop import "Scoop/scoopfile.json"
```
