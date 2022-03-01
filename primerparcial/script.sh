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
echo "lanzando contenedor 'web1'..."
lxc launch ubuntu:20.04 web1
echo "sleep 10"
sleep 10
echo "instalando apache2 en el contenedor..."
lxc exec web1 -- apt-get install apache2 -y
echo "creando página web [index.html]..."
sudo echo "<html>
<html>
<body>
<p>Bienvenidos a mi contenedor LXD 1</p>
</body>
</html>" > ./index.html
echo "reemplazando el index.html en el contenedor..."
lxc file push index.html web1/var/www/html/index.html
echo "validando contenido..."
lxc exec web1 -- cat /var/www/html/index.html
echo "reiniciando el servicio apache2..."
lxc exec web1 -- systemctl restart apache2
echo "reenvio de puertos"
lxc config device add web1 myport80 proxy listen=tcp:192.168.100.2:5080 connect=tcp:127.0.0.1:80
