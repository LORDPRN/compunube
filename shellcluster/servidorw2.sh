#!/bin/bash

cat <<TEST> /etc/resolv.conf
nameserver 8.8.8.8
TEST
echo "instalando lxd en ubuntuvm2"
sudo apt-get install lxd -y
echo "loguenado en el nuevo grupo creado..."
newgrp lxd
echo "inicializando lxd ubuntuvm2"
lxd init --auto
echo "sleep 5"
sleep 5

echo "CONFIGURANDO PÁGINA WEB [2 / 2]"
echo "lanzando contenedor 'weba'..."
lxc launch ubuntu:20.04 weba
echo "sleep 5"
sleep 5
echo "instalando apache2 en el contenedor..."
lxc exec weba -- apt-get install apache2 -y
echo "creando página web [index.html]..."
sudo echo "<html>
<html>
<body>
<h1>Ubuntuvm2: contenedor web #2</h1>
<p>Bienvenidos a mi contenedor LXD #2</p>
</body>
</html>" > ./index.html
echo "reemplazando el index.html en el contenedor..."
lxc file push index.html weba/var/www/html/index.html
echo "validando contenido..."
lxc exec weba -- cat /var/www/html/index.html
echo "reiniciando el servicio apache2..."
lxc exec weba -- systemctl restart apache2
echo "sleep 5"
sleep 5
echo "reenvio de puertos"
lxc config device add weba myport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80
