The scripts in the package are used to add new machines to the Vector Space network and to install and maintain software across the network.

These scripts have been tested on Mint, Manjaro, and Debian

# Maintain existing machines
From a host machine with Ansible installed,
1. `ssh-keygen` if you don't have an SSH keypair in Vector Space account
1. `ssh-copy-id vectorspace@examplehostname` for every computer in the space if not done already
1. `cd vsadmin/scripts/`
1. `./host.sh`

# Add new machine
From a host machine with Ansible installed,
1. `ssh-copy-id vectorspace@examplehostname`
