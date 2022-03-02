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

echo "CONFIGURANDO PÁGINA WEB [1 / 2]"
echo "lanzando contenedor 'web'..."
lxc launch ubuntu:20.04 webb
echo "sleep 5"
sleep 5
echo "instalando apache2 en el contenedor..."
lxc exec webb -- apt-get install apache2 -y
echo "creando página web [index.html]..."
sudo echo "<html>
<html>
<body>
<h1>Ubuntuvm1: contenedor web #1</h1>
<p>Bienvenidos a mi contenedor LXD #1</p>
</body>
</html>" > ./index.html
echo "reemplazando el index.html en el contenedor..."
lxc file push index.html webb/var/www/html/index.html
echo "validando contenido..."
lxc exec webb -- cat /var/www/html/index.html
echo "reiniciando el servicio apache2..."
lxc exec webb -- systemctl restart apache2
echo "sleep 5"
sleep 5
echo "reenvio de puertos"
lxc config device add webb myport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80
echo "hecho."

