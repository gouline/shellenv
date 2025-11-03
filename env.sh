# Export environment variables from a .env file
export-env() {
    set -a
    source "${1:-.env}"
    set +a
}
