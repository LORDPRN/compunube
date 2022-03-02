#!/bin/bash
echo "inicio del aprovisionamiento"
cat <<TEST> /etc/resolv.conf
nameserver 8.8.8.8
TEST
echo "instalando lxd..."
sudo apt-get install lxd -y
echo "loguenado en el nuevo grupo creado..."
newgrp lxd
echo "inicializando lxd..."
lxd init --auto
echo "sleep 10"
sleep 10

