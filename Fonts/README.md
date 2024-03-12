# Fonts

## Nerd Fonts

Nerd Fonts are popular fonts that are patched to include icons.

https://www.nerdfonts.com/

### Cascadia Code

**Cascadia Code** is a monospace font from Microsoft.

https://github.com/microsoft/cascadia-code

### Caskaydia Cove

**Caskaydia Cove** is a Nerd Font fork of Cascadia Code.

https://www.nerdfonts.com/downloads/

## Configuration

### Windows Terminal

Fonts can be changed in the Windows Terminal [`settings.json`](../Windows-Terminal/settings.json) file.

```json
{
    "profiles": {
        "defaults": {
            "font": {
                "face": "CaskaydiaCove Nerd Font Mono"
            }
        }
    }
}
```

### Visual Studio Code

To change the font in Visual Studio Code, open the settings and search for `font`. Then select the font you want to use.

The settings can also be changed through the configuration file. In the [`settings.json`](../VSCode/settings.json), change the `editor.fontFamily` and `terminal.integrated.fontFamily` settings.

```json
{
    "editor.fontFamily": "CaskaydiaCove Nerd Font Mono",
    "terminal.integrated.fontFamily": "CaskaydiaCove Nerd Font Mono"
}
```

### Visual Studio

This can be done by opening the settings in `Tools > Options > Fonts` and `Colors > Terminal` and selecting a font like `CaskaydiaCove Nerd Font Mono`.

---

## 📕 References

- https://ohmyposh.dev/docs/installation/fonts
