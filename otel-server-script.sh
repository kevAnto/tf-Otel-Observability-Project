#!/bin/bash

set -e

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt-get update -y
sudo apt-get upgrade -y

sudo su
apt update
apt install docker.io -y
systemctl status docker

# Ajouter au fstab pour montage automatique au démarrage
echo '/dev/sdf /data ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab

git clone https://github.com/open-telemetry/opentelemetry-demo.git
cd opentelemetry-demo/

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo docker compose up --force-recreate --remove-orphans --detach

