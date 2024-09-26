#!/bin/bash

# Switches input for display (by model)
# Example: ddc_set_input "DELL U2715H" "DisplayPort-1"
# Example: ddc_set_input "DELL G2724D" "HDMI-1"
ddc_set_input() {
    display_model=$1
    input_name=$2

    # https://github.com/kfix/ddcctl?tab=readme-ov-file#input-sources
    case $input_name in
        "VGA-1") input_dec=1 ;;
        "VGA-2") input_dec=2 ;;
        "DVI-1") input_dec=3 ;;
        "DVI-2") input_dec=4 ;;
        "Composite-1") input_dec=5 ;;
        "Composite-2") input_dec=6 ;;
        "S-Video-1") input_dec=7 ;;
        "S-Video-2") input_dec=8 ;;
        "Tuner-1") input_dec=9 ;;
        "Tuner-2") input_dec=10 ;;
        "Tuner-3") input_dec=11 ;;
        "Component-1") input_dec=12 ;;
        "Component-2") input_dec=13 ;;
        "Component-3") input_dec=14 ;;
        "DisplayPort-1") input_dec=15 ;;
        "DisplayPort-2") input_dec=16 ;;
        "HDMI-1") input_dec=17 ;;
        "HDMI-2") input_dec=18 ;;
        "USB-C") input_dec=27 ;;
        *) echo "Unknown input: $input_name"; exit 404
    esac

    if command -v ddcutil 2>&1 > /dev/null; then
        # Linux / Windows (https://www.ddcutil.com/)

        input_hex=$( printf "x%02X" $input_dec | tr '[:upper:]' '[:lower:]' )
        current=$( ddcutil --model "$display_model" --terse getvcp 60 2>/dev/null | cut -d' ' -f4 )
        if [[ "$current" != "" && "$current" != "$input_hex" ]]; then
            echo "Setting $display_model input to $input_hex (ddcutil)"
            ddcutil --model "$display_model" setvcp 60 "$input_hex"
        fi
    elif command -v m1ddc 2>&1 > /dev/null; then
        # macOS (https://github.com/waydabber/m1ddc)

        display_index=$( m1ddc display list | grep "$display_model" | awk -v RS=\[ -v FS=\] 'NR>1{print $1}' | head -n 1 )
        if [ "$display_index" ]; then
            current=$( m1ddc display $display_index get input )
            if [[ "$current" != "" && "$current" != "$input_dec" ]]; then
                echo "Setting $display_model input to $input_dec (m1ddc)"
                m1ddc display $display_index set input $input_dec
            fi
        fi
    elif command -v lunar 2>&1 > /dev/null; then
        # macOS (https://lunar.fyi/)

        if lunar displays "$display_model"; then
            echo "Setting $display_model input to $input_dec (lunar)"
            lunar displays "$display_model" input "$input_dec"
        fi
    fi
}
