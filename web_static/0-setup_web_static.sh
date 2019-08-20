#!/usr/bin/env bash
# Prepare server for web static
apt update
dpkg -l | grep -qw nginx || apt install nginx -y 
mkdir -p /data/
mkdir -p  /data/web_static/
mkdir -p /data/web_static/releases/
mkdir -p /data/web_static/shared/
mkdir -p /data/web_static/releases/test/
basicStructure='<html>
<head>
</head>
<body>
holberton school
</body>
</html>'
echo "$basicStructure" > /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test/ /data/web_static/current
chown -R ubuntu /data/ && chgrp -R ubuntu /data/
sed -i '37i\\tlocation /hbnb_static/ {\n\talias /data/web_static/current/;\n\t}' /etc/nginx/sites-enabled/default
service nginx restart
