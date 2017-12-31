#!/bin/bash
wget -qO - http://download.alephobjects.com/ao/aodeb/aokey.pub | sudo apt-key add -
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo sed -i '$a deb http://download.alephobjects.com/ao/aodeb wheezy main' /etc/apt/sources.list
sudo apt-get update
