#!/bin/bash

if [ -x "$(command -v php-fpm)" ]; then
	exit
fi

rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

echo "install php"
sudo yum install php72w-fpm -y

sudo systemctl enable php-fpm
sudo systemctl start php-fpm