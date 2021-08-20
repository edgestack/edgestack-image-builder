#!/bin/bash -x

os_distro_raw=`awk -F '=' '/^ID=/ { print $2 }' /etc/os-release`
os_distro="${os_distro_raw%\"}"
os_distro="${os_distro#\"}"

if [ $os_distro == "centos" ]; then
    yum install -y epel-release
    yum install -y ansible
elif [ $os_distro == "ubuntu" ]; then
    apt-get -y update
    apt-get -y install ansible
else
    echo "Unsupported OS"
fi
