# shellenv

Useful shell and environment utils

Sourced from `~/.config/fish/config.fish`:

```fish
set SHELLENV_HOME "$HOME/workspace/shellenv"
if test -d $SHELLENV_HOME
    fish_add_path "$SHELLENV_HOME/bin"
    for module in env python
        if test -f "$SHELLENV_HOME/$module.fish"
            source "$SHELLENV_HOME/$module.fish"
        end
    end
end
```
