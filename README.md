# shellenv

Useful shell and environment utils

Sourced from `.zshrc` or `.bash_profile`:

```sh
if [ -d "$HOME/workspace/shellenv" ]; then
    source "$HOME/workspace/shellenv/python.sh"
    source "$HOME/workspace/shellenv/env.sh"
    source "$HOME/workspace/shellenv/aws.sh"
fi
```
