function adbw
    adb wait-for-device
    if set -q argv[1]
        adb $argv
    else
        adb devices
    end
end
