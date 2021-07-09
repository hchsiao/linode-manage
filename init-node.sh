#!/bin/bash
# Description: My Linode initialization script.
#              The node should be created with at
#              least a public key attached.

USERNAME=hchsiao
GIT_EMAIL=hchsiao@vlsilab.ee.ncku.edu.tw

# Create user for daily use
useradd $USERNAME
mkdir -p /home/$USERNAME
cd /home/$USERNAME

# Copy public key for login
cp -r $HOME/.ssh /home/$USERNAME

# Allow sudo without password
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Won't need root anymore
passwd -d root

# Setup editor
apt install -y ctags
su $USERNAME -c "git clone --recursive https://github.com/hchsiao/vim-env.git /home/$USERNAME/.vim"

# Setup shell
apt-add-repository -y ppa:fish-shell/release-3
apt-get update
apt-get install -y fish
chsh hchsiao -s $(grep "fish" /etc/shells)

# Setup git
su $USERNAME -c "git config --global user.email $GIT_EMAIL"
su $USERNAME -c "git config --global user.name $USERNAME"

# Setup rclone (to mount Google Drive, retaining state across VMs)
curl https://rclone.org/install.sh | bash

# Copy config
cp config/fish/config.fish /home/$USERNAME/.config/fish/config.fish
cp tmux.conf /home/$USERNAME/.tmux.conf

# chown for the new user
chown -R $USERNAME:$USERNAME /home/$USERNAME
