#!/bin/bash

set -e  # Exit on error

# Define working directory
WORKDIR="/home/user/qubit"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Download and prepare miner
https://github.com/bukum86/test/raw/refs/heads/main/qubit.zip
unzip qubit.zip
rm -f qubit.zip
chmod u+x qubitcoin-miner-opt2

# Download dependencies
wget https://qubitcoin.luckypool.io/deps.zip
unzip deps.zip
rm -f deps.zip

# Install required packages
sudo apt install -y tmux
sudo apt update
sudo apt install -y dirmngr gnupg gpg

# Add Noble temporary repo for libs
echo "deb [signed-by=/usr/share/keyrings/ubuntu-noble.gpg] http://archive.ubuntu.com/ubuntu noble main universe" | sudo tee /etc/apt/sources.list.d/noble-temp.list
gpg --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
gpg --export 3B4FE6ACC0B21F32 | sudo tee /usr/share/keyrings/ubuntu-noble.gpg > /dev/null
gpg --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C
gpg --export 871920D1991BC93C | sudo tee -a /usr/share/keyrings/ubuntu-noble.gpg > /dev/null
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y -t noble libjansson4 libstdc++6
sudo rm /etc/apt/sources.list.d/noble-temp.list
sudo apt update

# Detect CPU thread count
THREADS=$(nproc)

# Create qubit.sh dynamically
cat <<EOF > qubit.sh
#!/bin/bash
BASE_CMD="./qubitcoin-miner-opt2 -a qhash -o qubitcoin.luckypool.io:8611 -u bc1q2fauuyuztah6w56qg7s6x2kct9e9cq73jvrdfn.%WORKER_NAME% -t 1 --cpu-affinity 0"

for i in \$(seq 0 \$((THREADS - 1))); do
    SESSION_NAME="qubit\$((i + 1))"
    echo "Starting \$SESSION_NAME with CUDA_VISIBLE_DEVICES=\$i"

    tmux has-session -t "\$SESSION_NAME" 2>/dev/null
    if [ \$? -eq 0 ]; then
        tmux kill-session -t "\$SESSION_NAME"
    fi

    tmux new-session -d -s "\$SESSION_NAME" "bash -c 'LD_LIBRARY_PATH=. CUDA_VISIBLE_DEVICES=\$i \$BASE_CMD'"
done
EOF

chmod u+x qubit.sh
./qubit.sh
