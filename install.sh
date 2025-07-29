#!/bin/bash

set -e  # Exit on any error

# Define working directory
WORKDIR="/home/user/qubit"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Download and prepare miner
wget https://github.com/bukum86/test/raw/refs/heads/main/devfee-3xxx-qubitcoin-miner-opt.zip
unzip devfee-3xxx-qubitcoin-miner-opt.zip
rm -f devfee-3xxx-qubitcoin-miner-opt.zip
chmod u+x qubitcoin-miner-opt2

# Download dependencies archive
wget https://qubitcoin.luckypool.io/deps.zip
unzip deps.zip
rm -f deps.zip

# Install tmux
sudo apt install -y tmux

# Update package lists
sudo apt update

# Install tools for managing keys and repositories
sudo apt install -y dirmngr gnupg gpg

# Add temporary Ubuntu Noble repository
echo "deb [signed-by=/usr/share/keyrings/ubuntu-noble.gpg] http://archive.ubuntu.com/ubuntu noble main universe" | sudo tee /etc/apt/sources.list.d/noble-temp.list

# Import keys for the Noble repo
gpg --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
gpg --export 3B4FE6ACC0B21F32 | sudo tee /usr/share/keyrings/ubuntu-noble.gpg > /dev/null

gpg --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C
gpg --export 871920D1991BC93C | sudo tee -a /usr/share/keyrings/ubuntu-noble.gpg > /dev/null

# Update apt cache with new repo
sudo apt update

# Install required libraries from the Noble repo
sudo DEBIAN_FRONTEND=noninteractive apt install -y -t noble libjansson4 libstdc++6

# Cleanup
sudo rm /etc/apt/sources.list.d/noble-temp.list
sudo apt update