#!/bin/bash

# Do NOT run this script as root
# Disclaimer: the --install script has been written and tested on and for a Debian10 and may not work on other distributions / older versions
# Note that this script has been designed to work as a full and standalone installer, every single package it needs is installed from within it

# If running on a VM
# The following command should be ran on the host OS (replace vm-name by the name of your vm):
# VBoxManage modifyvm vm-name --nested-hw-virt on

set -xe
username=$1
gituser=$2

##########################################
# PACKAGES INSTALLATION + HOME PRE-SETUP #
##########################################
    sudo /usr/sbin/usermod -aG sudo $username
    sudo /usr/sbin/adduser $username sudo
    sudo chmod 0440 /etc/sudoers

    sudo apt update
    sudo apt upgrade
    sudo apt dist-upgrade
    sudo apt install -y vim git openssh-server curl wget wmctrl python3 python3-pip net-tools zsh apt-transport-https ubuntu-restricted-extras firefox-gnome-shell p7zip-full libsdl2-2.0-0 gnome-tweak-tool gnome-shell-extensions timeshift virtualbox
    sudo service ssh start
    sudo chsh -s $(which zsh)

    snap install spotify
    snap install vlc
    snap install code

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    sed -i s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"bureau\"/ ~/.zshrc && source ~/.zshrc

###########################
# DRIVERS & KERNEL UPDATE #
###########################

    # keychron keyboard fn keys (+ manually set to macos mode)
    echo "options hid_apple fnmode=2 swap_opt_cmd=1" | sudo tee -a /etc/modprobe.d/hid_apple.conf

    # corsair scimitar setup
    sudo add-apt-repository ppa:tatokis/ckb-next                               
    sudo apt-get update && sudo apt install ckb-next

    # TLP
    sudo add-apt-repository ppa:linrunner/tlp                                                                                                                                                                                                                                            
    sudo apt-get update
    sudo apt-get install tlp tlp-rdw
    sudo tlp start

    # discord
    wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo dpkg -i ./discord.deb

    # signal
    curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    sudo apt update && sudo apt install signal-desktop

    # rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # sudo apt install software-properties-common nvidia-driver
