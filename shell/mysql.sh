#!/bin/bash

# 参考资料：https://dev.mysql.com/doc/mysql-yum-repo-quick-guide/en/

if test -f /usr/local/vagrant.mysql.lock; then
	exit
fi

yum -y remove maria*
rm -fr /var/lib/mysql/*

echo "install mysql5.7"

tar -xvf /vagrant/soft/mysql-5.7.22-1.el7.x86_64.rpm-bundle.tar
cd mysql-5.7.22-1.el7.x86_64.rpm-bundle.tar
rpm -ivh mysql-community-common-5.7.22-1.el7.x86_64.rpm
rpm -ivh mysql-community-libs-5.7.22-1.el7.x86_64.rpm 
rpm -ivh mysql-community-client-5.7.22-1.el7.x86_64.rpm
rpm -ivh mysql-community-server-5.7.22-1.el7.x86_64.rpm
# 初始化，生成数据库的随机密码及数据库的一些基本数据（如mysql数据库），
# 最好指定user，不然会有权限问题
mysqld --initialize --user=mysql

# sudo rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
# sudo yum-config-manager --disable mysql80-community
# sudo yum-config-manager --enable mysql57-community
# sudo yum install mysql-community-server
# sudo grep '123456' /var/log/mysqld.log

sudo systemctl enable mysqld
sudo systemctl start mysqld

touch /usr/local/vagrant.mysql.lock