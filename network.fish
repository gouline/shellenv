function sshwait
    while true
        ssh -o ConnectTimeout=5 $argv
        test $status -ne 255; and break
        sleep 3
    end
end
