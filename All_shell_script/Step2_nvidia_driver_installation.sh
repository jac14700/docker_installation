#!/bin/bash
sudo add-apt-repository ppa:graphics-drivers/ppa 
sudo apt-get update
sudo apt-get install nvidia-driver-418
sudo service gdm3 start
reboot
