# Fix function keys on Keyrchron keyboards from operating the macOS way,
# i.e. press for media keys, Fn+press for F1-12 buttons.
# Source: https://www.reddit.com/r/MechanicalKeyboards/comments/d5y5if/keychron_2_bt_connection_stuck_in_numpad_mode/f2bwwe8
keychron-fix-fn() {
    sudo su

    echo "options hid_apple fnmode=2" > /etc/modprobe.d/hid_apple.conf
    update-initramfs -u

    reboot now
}
