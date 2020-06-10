#!/bin/bash

# Do NOT run this script as root
# Disclaimer: the --install script has been written and tested on and for a Debian10 and may not work on other distributions
# Note that this script has been designed to work as a full and standalone installer, every single package it needs is installed from within it

# If running on a VM
# The following command should be ran on the host OS (replace vm-name by the name of your vm):
# VBoxManage modifyvm vm-name --nested-hw-virt on

set -xe
username=$1
gituser=$2
rudder_dir=/home/$username/rudder

    sudo apt install ruby-full jq
    sudo gem install serverspec

    ln -s ../rudder-api-client
    cd $rudder_dir/rudder-api-client/lib.python
    sh build.sh # must be executed from within its own directory
    cd $rudder_dir/rudder-tests
    echo -e '{\n  "default":{ "run-with": "vagrant", "rudder-version": "6.1", "system": "debian9", "inventory-os": "debian" },\n  "server": { "rudder-setup": "dev-server" }\n}' > platforms/debian9_dev.json
    ./rtf platform setup debian9_dev
    # will take a while...
    netstat -laputn | grep 15432 # check purpose only, should print : `tcp        0      0 0.0.0.0:15432           0.0.0.0:*               LISTEN`
    cd $rudder_dir/

###########################
# PRE SETUP FOR SOFTWARES #
###########################

    
    sudo mkdir -p /var/rudder/inventories/incoming /var/rudder/share /var/rudder/inventories/accepted-nodes-updates /var/rudder/inventories/received /var/rudder/inventories/failed /var/log/rudder/core /var/log/rudder/compliance/ /var/rudder/run/ /var/rudder/configuration-repository/ncf
    sudo touch /var/log/rudder/core/rudder-webapp.log /var/log/rudder/compliance/non-compliant-reports.log /var/rudder/run/api-token
    # since a lot has been installed as root apps launched as $username could need permissions to access its home space
    sudo chown $username -R /var/rudder
    sudo chown $username -R /var/log/rudder
    sudo chown $username -R /home/$username/
