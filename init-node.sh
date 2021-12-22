#!/bin/bash
# Description: My Linode initialization script.
#              The node should be created with at
#              least a public key attached.
set -e

USERNAME=hchsiao
GIT_EMAIL=hchsiao@vlsilab.ee.ncku.edu.tw

# Create user for daily use
useradd $USERNAME
mkdir -p /home/$USERNAME

# Copy public key for login
cp -r $HOME/.ssh /home/$USERNAME
chown -R $USERNAME:$USERNAME /home/$USERNAME

# Allow sudo without password
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Won't need root anymore
passwd -d root

# Setup editor
apt update
apt install -y ctags
su $USERNAME -c "git clone --recursive https://github.com/hchsiao/vim-env.git /home/$USERNAME/.vim"

# Setup shell
apt-add-repository -y ppa:fish-shell/release-3
apt-get update
apt-get install -y fish fzf
chsh hchsiao -s $(grep "fish" /etc/shells)

# Setup rclone (to mount Google Drive, retaining state across VMs)
curl https://rclone.org/install.sh | bash

# Copy config
cp config/fish/config.fish /home/$USERNAME/.config/fish/config.fish
cp tmux.conf /home/$USERNAME/.tmux.conf
chown -R $USERNAME:$USERNAME /home/$USERNAME

# Setup git
cd /home/$USERNAME
su $USERNAME -c "git config --global user.email $GIT_EMAIL"
su $USERNAME -c "git config --global user.name $USERNAME"
