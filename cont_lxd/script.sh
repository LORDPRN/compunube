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

echo "sleep 10"
sleep 10

echo "lanzando contenedor 'web'..."
lxc launch ubuntu:20.04 webb

echo "sleep 10"
sleep 10

echo "instalando apache2 en el contenedor..."
lxc exec webb -- apt-get install apache2 -y

echo "creando página web [index.html]..."
sudo echo "<html>
<html>
<body>
<h1>Página de prueba</h1>
<p>Bienvenidos a mi contenedor LXD</p>
</body>
</html>" > ./index.html

echo "reemplazando el index.html en el contenedor..."
lxc file push index.html webb/var/www/html/index.html

echo "validando contenido..."
lxc exec webb -- cat /var/www/html/index.html

echo "reiniciando el servicio apache2..."
lxc exec webb -- systemctl restart apache2

echo "reenvio de puertos"
lxc config device add webb myport80 proxy listen=tcp:192.168.100.3:5080 connect=tcp:127.0.0.1:80
