#!/bin/bash -x

os_distro_raw=`awk -F '=' '/^ID=/ { print $2 }' /etc/os-release`
os_distro="${os_distro_raw%\"}"
os_distro="${os_distro#\"}"

if [ $os_distro == "centos" ]; then
    curl https://rpmfind.net/linux/epel/7/x86_64/Packages/a/ansible-2.9.24-2.el7.noarch.rpm -o ansible-2.9.24-2.el7.noarch.rpm
    yum localinstall -y ansible-2.9.24-2.el7.noarch.rpm
elif [ $os_distro == "ubuntu" ]; then
    apt-get -y update
    apt-get -y install ansible
else
    echo "Unsupported OS"
fi
