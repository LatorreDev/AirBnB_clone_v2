#!/usr/bin/env bash
# puppet script to prepare server for web static
exec { 'Install ngnix':
command  => 'sudo apt update && dpkg -l | grep -qw nginx || apt install nginx -y',
provider => shell,
}
-> package {'nginx':
ensure => installed
}
-> file{ [ '/data/', '/data/web_static/', '/data/web_static/releases/',
'/data/web_static/shared/', '/data/web_static/releases/test/',]
ensure => directory,
}
-> file { '/data/web_static/releases/test/index.html':
ensure  => 'present',
content => 'testing',
}
-> exec {'link':
command  => 'ln -sf /data/web_static/releases/test/ /data/web_static/current',
provider => shell,
}
-> exec {'permissions':
command  => 'chown -R ubuntu /data/ && chgrp -R ubuntu /data/',
provider => shell,
}
-> exec { 'sed':
command  => "sed -i '37i\\tlocation /hbnb_static/ {\n\talias /data/web_static/current/;\n\t}' /etc/nginx/sites-enabled/default",
provider => shell,
}
-> exec {'Restart':
command  => service nginx restart,
provider => shell,
}
