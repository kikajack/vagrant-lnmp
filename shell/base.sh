#!/bin/bash

if [ -f "/etc/yum.repos.d/CentOS-Base.repo.bak" ]; then
	exit
fi

echo "change yum source to 163"
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
curl -O http://mirrors.163.com/.help/CentOS7-Base-163.repo
sudo mv CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
sudo yum clean all
sudo yum makecache

echo "install common soft"
sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm