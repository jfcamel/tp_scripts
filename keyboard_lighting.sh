keyboard_light_on() {
    sudo echo 2 > /sys/class/leds/tpacpi\:\:kbd_backlight/brightness
}

keyboard_light_off() {
    sudo echo 0 > /sys/class/leds/tpacpi\:\:kbd_backlight/brightness
}

