# Scoop

https://scoop.sh/

A package manager for windows

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
