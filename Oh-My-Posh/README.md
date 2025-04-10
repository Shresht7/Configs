# Oh My Posh

https://ohmyposh.dev/

**A Prompt Theme Engine**

---

## Installation

### 🪟 Windows

```sh
winget install JanDeDobbeleer.OhMyPosh -s winget
```

### 🐧 Linux

```sh
curl -s https://ohmyposh.dev/install.sh | bash -s
```

By default the script will install to `/usr/local/bin` or the existing Oh My Posh executable's installation folder. If you want to install to a different location you can specify it using the `-d` flag:

```sh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin
```

You can also use homebrew.

```sh
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```


## Update

### 🪟 Windows

```sh
winget upgrade JanDeDobbeleer.OhMyPosh -s winget
```

### 🐧 Linux

Using homebrew:

```sh
brew update && brew upgrade oh-my-posh
```

## Changing the Prompt

### PowerShell

Edit your [PowerShell profile script](../PowerShell/Microsoft.PowerShell_profile.ps1), you can find its location under the `$PROFILE` variable in your preferred PowerShell version.

> [!NOTE]
> 
> You may have to create the file if it doesn't exist.

Add the following line to the profile:

```sh
oh-my-posh init pwsh | Invoke-Expression
```

Once added, reload the profile for the changes to take effect:

```sh
. $PROFILE
```

### bash

Add the following to `~/.bashrc` (could be `~/.profile` or `~/.bash_profile` depending on your environment):

```sh
eval "$(oh-my-posh init bash)"
```

Once added, reload your profile or source the file:

```sh
exec bash
# or
source ~/.bashrc
```

---

## Themes

You can find the themes in the folder indicated by the environment variable `POSH_THEMES_PATH`. For example, you can use `oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression` for the prompt initialization in PowerShell.

## Customize

To set a new config/theme you need to change the `--config` option of the `oh-my-posh init <shell>` line in your `profile` or `.<shell>rc` script (see [prompt](https://ohmyposh.dev/docs/installation/prompt)) and point it to the location of a predefined [theme](https://ohmyposh.dev/docs/themes) or custom configuration.

There are two possible values the `--config` flag can handle:
1. a path to a local configuration file
   ```
   oh-my-posh init pwsh --config '$Env:POSH_THEMES_PATH\jandedobbeleer.omp.json' | Invoke-Expression
   ```
2. a URL pointing to a remote config
   ```
   oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json' | Invoke-Expression
   ```

> [!TIP]
> When using oh-my-posh in Windows and the WSL, know that you can share your theme with the WSL by pointing to a theme in your Windows user's home folder.
>
> Inside the WSL, you can find your Windows user's home folder here: `/mnt/c/Users/<WINDOWSUSERNAME>`.

See [Oh My Posh: Configuration](https://ohmyposh.dev/docs/configuration/general) for more information on how to customize your prompt.

---

## 📕 References

- https://ohmyposh.dev/docs/installation/windows
- https://ohmyposh.dev/docs/installation/linux
- https://ohmyposh.dev/docs/installation/customize
