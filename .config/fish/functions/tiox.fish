function tiox -w tio
    set -l log_dir /var/log/tiox
    set -l device (ls /dev/serial/by-id/* | grep -E 'usb-.*STM.*-if02' | head -n1)

    if test -z "$device"
        echo "No STM device found."
        return 1
    end

    if not test -d $log_dir
        echo "\
Missing $log_dir. Run these commands to create it:
    sudo mkdir -p $log_dir
    sudo chown $USER:$USER $log_dir\
"
        return 1
    end

    set -l logs (ls -1 -t $log_dir | rev)
    if test (count $logs) -ge 5
        rm $logs[1]
    end
    tio --local-echo --log --log-directory $log_dir $device
end
