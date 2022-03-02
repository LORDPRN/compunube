#!/bin/bash
cat <<TEST> /etc/resolv.conf
nameserver 8.8.8.8
TEST
echo "instalando lxd..."
sudo apt-get install lxd -y
echo "loguenado en el nuevo grupo creado..."
newgrp lxd
echo "inicializando lxd..."
lxd init --auto
echo "sleep 5"
sleep 5

echo "CONFIGURANDO HAPROXY [1 / 4]"
echo "lanzando contenedor 'haproxy'..."
lxc launch ubuntu:18.04 haproxy
echo "sleep 5"
sleep 5

echo "CONFIGURANDO HAPROXY [2 / 4]"
echo "update && upgrade"
apt-get update && apt-get upgrade -y
echo "instalando haproxy"
apt-get install haproxy -y
echo "habilitando haproxy"
systemctl enable haproxy
echo "sleep 5"
sleep 5

echo "CONFIGURANDO HAPROXY [3 / 4]"
cat /etc/haproxy/haproxy.cfg

echo "CONFIGURANDO HAPROXY [4 / 4]"
echo "iniciando haproxy"
systemctl start haproxy
echo "sleep 5"
sleep 5
