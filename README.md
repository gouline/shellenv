# shellenv

Useful shell and environment utils

Sourced from `.zshrc` or `.bash_profile`:

```sh
SHELLENV_HOME="$HOME/workspace/shellenv"
test -f "$SHELLENV_HOME/python.sh" && source "$SHELLENV_HOME/python.sh"
test -f "$SHELLENV_HOME/env.sh" && source "$SHELLENV_HOME/env.sh"
```
