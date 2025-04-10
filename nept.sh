#!/bin/bash

# Create and enter the neptune folder
mkdir -p neptune
cd neptune

# Download the files using wget
wget https://github.com/bukum86/test/raw/refs/heads/main/oxzd-x86-1.3
wget https://github.com/bukum86/test/raw/refs/heads/main/oxzd_config.json

# Rename the file and make it executable
mv oxzd-x86-1.1 oxzd-x86
chmod +x oxzd-x86

# Start the program in screen
screen -dmS neptune_session ./oxzd-x86 run --algos neptune-gpu
