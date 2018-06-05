#!/bin/bash

if [ -x "$(command -v nginx)"]; then
	exit
fi

cat >> /etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
EOF

echo "install nginx"
sudo yum install nginx -y

cat >> /etc/nginx/nginx.conf <<EOF
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    include /etc/nginx/conf.d/*.conf;
}
EOF

cat >> /etc/nginx/conf.d/default.conf <<EOF
server {
	listen 80;
	server_name default;
	index index.php;
    root /home/demo;

    location ~ \.php(.*)$  {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_split_path_info  ^((?U).+\.php)(/?.+)$;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_param  PATH_INFO  $fastcgi_path_info;
        fastcgi_param  PATH_TRANSLATED  $document_root$fastcgi_path_info;
        include        fastcgi_params;
    }
}
EOF

sudo systemctl enable nginx
sudo systemctl start nginx