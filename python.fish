alias python python3
alias pip pip3

# Shortcut to create and activate Python virtual environment in ./.venv
# Takes Python version as optional argument or falls back on .python-version or PYTHON_VERSION
function python-venv
    set -l python_version ""
    set -l python_version_source ""

    if test (count $argv) -gt 0
        set python_version $argv[1]
        set python_version_source "argument"
    else if test -f .python-version
        set python_version (cat .python-version)
        set python_version_source ".python-version"
    else
        set python_version $PYTHON_VERSION
        set python_version_source "default"
    end

    if not test -d .venv
        echo "creating venv with $python_version ($python_version_source)..."
        if test -n "$python_version"
            uv venv --python $python_version
        else
            uv venv
        end
    end

    # Activate venv if not already activated.
    if not set -q VIRTUAL_ENV
        echo "activating venv..."
        source .venv/bin/activate.fish
    end
end

# Extension for python-venv to install packages for any package manager it finds
function python-venv-install
    python-venv $argv

    # uv
    find . -name "uv.lock" ! -path "./.venv/**" | while read -l file
        echo "uv synchronizing $file..."
        set -l dir (dirname -- "$file")
        if test -n "$UV_ARGS"
            sh -c "cd \"$dir\" && uv sync --frozen $UV_ARGS"
        else
            sh -c "cd \"$dir\" && uv sync --frozen"
        end
    end

    # poetry
    find . -name "poetry.lock" ! -path "./.venv/**" | while read -l file
        poetry config virtualenvs.create false
        echo "poetry installing $file..."
        set -l dir (dirname -- "$file")
        if test -n "$POETRY_ARGS"
            sh -c "cd \"$dir\" && poetry install --sync --no-root --all-extras $POETRY_ARGS"
        else
            sh -c "cd \"$dir\" && poetry install --sync --no-root --all-extras"
        end
    end

    # setup.py
    find . -name "setup.py" ! -path "./.venv/**" | while read -l file
        echo "setup installing $file..."
        set -l dir (dirname -- "$file")
        if test -n "$PIP_ARGS"
            sh -c "uv pip install -e \"$dir\" $PIP_ARGS"
        else
            uv pip install -e "$dir"
        end
    end

    # requirements.txt
    find . -name "requirements*.txt" ! -path "./.venv/**" | while read -l file
        echo "requirements installing $file"
        if test -n "$PIP_ARGS"
            sh -c "uv pip install -r \"$file\" $PIP_ARGS"
        else
            uv pip install -r "$file"
        end
    end
end

# Parse JSON using built-in Python
# Example: echo '{"username":"blah","password":"anotherblah"}' | python-json "password"
function python-json
    python3 -c "import json,sys; print(json.load(sys.stdin)['$argv[1]'])"
end

# Interactive Python shell in Docker
function python-docker
    if test (count $argv) -lt 1
        echo "usage: python-docker <tag> [command ...]"
        return 1
    end

    set -l tag $argv[1]
    set -l cmd $argv[2..-1]

    docker run --rm -it \
        -w /app \
        -v .:/app \
        python:$tag $cmd
end
