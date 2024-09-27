#!/bin/bash

alias python=python3
alias pip=pip3

# Shortcut to create and activate Python virtual environment in ./.venv
# Takes Python version as optional argument or falls back on .python-version or PYTHON_VERSION
python-venv() {
    if [ "$1" ]; then
        python_version="$1"
        python_version_source="argument"
    elif [ -f .python-version ]; then
        python_version=$( cat .python-version )
        python_version_source=".python-version"
    else
        python_version=$PYTHON_VERSION
        python_version_source="default"
    fi

    if [ ! -d .venv ]; then
        echo "creating venv with ${python_version} ($python_version_source)..."
        if [ "$python_version" ]; then
            uv venv --python $python_version
        else
            uv venv
        fi
    fi

    # activate venv (if not already activated)
    if ! command -v deactivate 2>&1 >/dev/null; then
        echo "activating venv..."
        . .venv/bin/activate
    fi    
}

# Extension for python-venv to install packages for any package manager it finds
python-venv-install() {
    python-venv

    # uv
    find . -name "uv.lock" ! -path "./.venv/**" | while IFS= read -r file; do
        echo "uv synchronizing $file..."
        ( cd $( dirname -- "$file" ) ; uv sync --freeze )
    done

    # poetry
    find . -name "poetry.lock" ! -path "./.venv/**" | while IFS= read -r file; do
        poetry config virtualenvs.create false
        echo "poetry installing $file..."
        ( cd $( dirname -- "$file" ) ; poetry install --sync --no-root --all-extras )
    done

    # setup.py
    find . -name "setup.py" ! -path "./.venv/**" | while IFS= read -r file; do
        echo "setup installing $file..."
        uv pip install -e $( dirname -- "$file" )
    done

    # requirements.txt
    find . -name "requirements*.txt" ! -path "./.venv/**" | while IFS= read -r file; do
        echo "requirements installing $file"
        uv pip install -r "$file"
    done
}

# Parse JSON using built-in Python
# Example: echo '{"username":"blah","password":"anotherblah"}' | python-json "password"
python-json() {
    python3 -c "import json,sys; print(json.load(sys.stdin)['$1'])"
}
