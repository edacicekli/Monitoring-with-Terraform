#!/bin/bash

sudo rm /var/lib/dpkg/lock
sudo rm /var/cache/apt/archives/lock
sudo dpkg --configure -a
sudo apt update -y 
echo "update is complete."

cd /home/ubuntu
sudo apt install docker-compose -y
sudo docker-compose up -d