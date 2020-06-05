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


curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' terminator
sudo add-apt-repository contrib
sudo add-apt-repository non-free

##########################################
# PACKAGES INSTALLATION + HOME PRE-SETUP #
##########################################

    sudo /usr/sbin/usermod -aG sudo $username
    sudo /usr/sbin/adduser $username sudo
    sudo chmod 0440 /etc/sudoers

    sudo apt update
    sudo apt upgrade
    sudo apt dist-upgrade
    sudo apt install -y vim git openssh-server curl wget python3 python3-pip net-tools zsh apt-transport-https code
    sudo service ssh start

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    sed -i s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"bureau\"/ ~/.zshrc && source ~/.zshrc

###########################
# DRIVERS & KERNEL UPDATE #
###########################

    sudo apt install software-properties-common nvidia-driver
    sudo apt install linux-image-5.5.0-0.bpo.2-amd64


##########################
# SOFTWARES INSTALLATION #
##########################

    # install vagrant latest
    vagrantversion=$(wget -qO- https://raw.githubusercontent.com/hashicorp/vagrant/stable-website/version.txt) 
    wget -q https://releases.hashicorp.com/vagrant/${vagrantversion}/vagrant_${vagrantversion}_x86_64.deb
    sudo dpkg -i vagrant_${vagrantversion}_x86_64.deb
    sudo apt -f install
    rm -rf vagrant_${vagrantversion}_x86_64.deb

    # install virtualbox + extension pack
    sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian bionic contrib"
    wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
    sudo apt update
    vboxlatest=$(wget -qO- https://download.virtualbox.org/virtualbox/LATEST.TXT)
    vboxversion=$(echo $vboxlatest | cut -c1-3)
    sudo apt install -y virtualbox-${vboxversion}
    wget -q https://download.virtualbox.org/virtualbox/${vboxlatest}/Oracle_VM_VirtualBox_Extension_Pack-${vboxlatest}.vbox-extpack
    echo y | sudo vboxmanage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-${vboxlatest}.vbox-extpack
    rm -rf Oracle_VM_VirtualBox_Extension_Pack-${vboxlatest}.vbox-extpack