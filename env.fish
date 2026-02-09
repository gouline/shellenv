# Export environment variables from a .env file
function export-env
    set -l env_file ".env"
    if test (count $argv) -gt 0
        set env_file $argv[1]
    end

    if test -f $env_file
        export (grep -v '^#' $env_file | xargs)
    else
        return 1
    end
end
