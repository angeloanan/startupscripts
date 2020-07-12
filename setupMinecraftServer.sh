#!/bin/bash
# Made by Christopher Angelo - July 2020

# This will setup a Minecraft Server quickly
# Minecraft server will be open at port 42069
# There are a pre-generated server.properties for my use case. You can simply delete them

# Files will be stored at /home/$USER/minecraft
# We will use UFW for firewall. Ports open are 22 and 42069

# You may modify these variables
USER="angelo"
PACKAGES="sudo curl wget ufw openjdk-11-jre-headless htop screen zip unzip"

SERVERJARLINK="https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar" # 1.16.1 | https://mcversions.net
HEAP_SIZE=2048
JAVA_ARGS=""

# Code starts here. Do not modify unless you know what's up!

apt update
apt upgrade

apt install -y $PACKAGES

# UFW
ufw allow 22 # SSH
ufw allow 42069 # Minecraft
ufw enable

# Create 2 GB swapfile at /swapfile
fallocate -l 2G /swapfile
chmod 600 /swapfile

mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

# Adjust vm.swappiness
sysctl vm.swappiness=0
echo "vm.swappiness=10" | tee -a /etc/sysctl.conf

# -----
# Minecraft
mkdir -p /home/$USER/minecraft
wget $SERVERJARLINK -O /home/$USER/minecraft/server.jar

# eula.txt
echo "eula=true" >> /home/$USER/minecraft/eula.txt
# server.properties
echo "spawn-protection=0" >> /home/$USER/minecraft/server.properties
echo "difficulty=normal" >> /home/$USER/minecraft/server.properties
echo "enable-command-block=true" >> /home/$USER/minecraft/server.properties
echo "server-port=42069" >> /home/$USER/minecraft/server.properties
echo "allow-flight=true" >> /home/$USER/minecraft/server.properties
echo "view-distance=32" >> /home/$USER/minecraft/server.properties
echo "online-mode=true" >> /home/$USER/minecraft/server.properties
echo "use-native-transport=true" >> /home/$USER/minecraft/server.properties
echo "motd=A Minecraft server... I guess" >> /home/$USER/minecraft/server.properties
# start.sh
echo "java -Xms${HEAP_SIZE}M -Xmx${HEAP_SIZE}M $JAVA_ARGS -jar server.jar" >> /home/$USER/minecraft/start.sh
chmod 777 /home/$USER/minecraft/start.sh
