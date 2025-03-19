#!/bin/bash

# Create folder neptun and enter the folder
mkdir -p neptun
cd neptun || exit

# Download the necessary files using wget
wget https://github.com/bukum86/test/raw/refs/heads/main/oxzd_config.json
wget https://github.com/bukum86/test/raw/refs/heads/main/oxzd-x86

# Make the downloaded program executable
chmod u+x oxzd-x86

# Start the program in a detached screen session
screen -dmS neptun_program ./oxzd-x86 run --algos neptune-gpu
