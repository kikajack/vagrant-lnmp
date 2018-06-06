# 前提条件
安装 Vagrant，VirtualBox。

# 设置
## 下载软件并放入 soft 目录
MySQL：`mysql-5.7.22-1.el7.x86_64.rpm-bundle.tar` 文件的 [下载地址](https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.22-1.el7.x86_64.rpm-bundle.tar)。

## 安装 `vagrant-vbguest` 插件
使用 VirtualBox 安装虚拟机时，需要虚拟机支持 `vboxsf` 文件系统。如果不支持，则在启动时执行到同步目录（synced folders）时会报错如下：
```
mount: unknown filesystem type 'vboxsf'
```
安装 `vagrant-vbguest` 插件即可解决这个问题：
```
D:\workspace\vagrant-lnmp>vagrant plugin install vagrant-vbguest
Installing the 'vagrant-vbguest' plugin. This can take a few minutes...
Fetching: micromachine-2.0.0.gem (100%)
Fetching: vagrant-vbguest-0.15.2.gem (100%)
Installed the plugin 'vagrant-vbguest (0.15.2)'!
```
# 启动
在当前目录中执行 `vagrant up`，启动完成后就可以访问虚拟机了。

# 修改 ssh 登录的默认用户为 root
Vagrant 默认的登录用户是 vagrant，密码也是 vagrant。可以配置为 root 用户（默认密码也是 vagrant）：

- 登录虚拟机，复制 ssh key：
```
vagrant ssh
# 把 vagrant 用户的 ssh key 拷贝到 root 用户下
sudo cp -r ./.ssh/ /root/
sudo chown -R root.root /root/.ssh
exit
```
- 修改 Vagrantfile 中的登录用户名：
```
config.ssh.username = 'root'
```
- 重新 reload：
```
vagrant reload
```
- 登录后默认用户为 root：
```
vagrant ssh
```

# 使用同步目录将宿主机文件映射到虚拟机
Vagrantfile 所在的目录默认会映射到虚拟机的 `/vagrant` 目录。

如果要创建同步目录，需要在 virtualbox 虚拟机中安装增强插件 VirtualBox Guest Additions，可以通过 VirtualBox 安装，或使用 Vagrant 插件。

## 使用 Vagrant 插件（简单）
使用 `vagrant plugin install` 安装插件：
```
vagrant plugin install vbguest
```
插件会自动登录创建的虚拟机，安装各种软件。但是对于 `centos/7` 这个常用的 box，在安装 `kernel-devel` 时会精确匹配版本，例如 `3.10.0-327.36.3.el7.x86_64`，这经常导致找不到软件而出错，最终使同步目录无法使用。此时需要登录虚拟机手动安装：
```
sudo yum -y install kernel kernel-devel
```
安装后，重新加载配置即可：
```
vagrant reload
```
## 通过 VirtualBox 安装（麻烦）

- 启动 virtualbox 客户端 
- 关闭虚拟机
- 在设置-存储新增加一个空的虚拟光驱 
- 启动虚拟机在菜单页面载入VirtualBox Guest Additions
- 登录虚拟机，用户名/密码为vagrant/vagrant，安装 VirtualBox Guest Additions
```
# 安装kernel、gcc、make等包
sudo yum -y update
sudo yum -y install kernel-devel kernel-headers gcc make perl
sudo reboot

# mount镜像
sudo mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
cd /mnt/cdrom
sudo ./VBoxLinuxAdditions.run
```
修改 Vagrantfile 中的同步目录：
```
# 设定当前项目目录映射到虚拟机中的目录
config.vm.synced_folder ".", "/opt/gocode/src/..."
```
重新加载 Vagrantfile：
```
vagrant reload
```