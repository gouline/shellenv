#!/bin/bash

# Export environment variables from a .env file
export-env() {
    export $( grep -v '^#' $1 | xargs | envsubst )
}
