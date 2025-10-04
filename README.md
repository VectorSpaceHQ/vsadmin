The scripts in the package are used to add new machines to the Vector Space network and to install and maintain software across the network.

These scripts have been tested on Mint, Manjaro, and Debian

# Maintain existing machines
From a host machine with Ansible installed,
1. Log into your personal account that is in the sudoers file
1. `ssh-keygen` if you don't have an SSH keypair in your personal account
1. From your personal account, run `ssh-copy-id vectorspace@examplehostname` for every computer in the space if not done already
1. `cd vsadmin/scripts/`
1. `./host.sh`
1. When Ansible asks for "BECOME password", enter administrator password

# Add new machine
From a host machine with Ansible installed,
1. From your personal account, run `ssh-copy-id vectorspace@examplehostname`
