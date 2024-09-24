#!/bin/bash

# NVIDIA Settings Loader
# Instructions:
#   1. Run nvidia-settings and configure screens as you like
#   2. Save this script to /opt/nvidia-settings.sh
#   3. Execute the script with 'init' option: /opt/nvidia-settings.sh init
#   4. Save the output in the 'apply' function
#   5. Invoke /opt/nvidia-settings.sh from 'Startup Application Preferences'
# Source: https://askubuntu.com/a/1201384
nvidia-settings-init() {
    CURRENT_MODE=`nvidia-settings -q=CurrentMetaMode | awk -F' :: ' '{print $2}' | tr -d '\n'`
    echo "nvidia-settings --assign CurrentMetaMode=\"$CURRENT_MODE\""  
}

nvidia-settings-apply() {
    ### SAVE INIT OUTPUT BELOW HERE ###
    nvidia-settings --assign CurrentMetaMode="DPY-3: nvidia-auto-select @2560x1440 +0+240 {ViewPortIn=2560x1440, ViewPortOut=2560x1440+0+0}, DPY-2: nvidia-auto-select @1080x1920 +2560+0 {ViewPortIn=1080x1920, ViewPortOut=1920x1080+0+0, Rotation=90}"
    ### SAVE INIT OUTPUT ABOVE HERE ###
}
