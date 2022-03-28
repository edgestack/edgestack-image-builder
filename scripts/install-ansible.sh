#!/bin/bash -x

os_distro_raw=`awk -F '=' '/^ID=/ { print $2 }' /etc/os-release`
os_distro="${os_distro_raw%\"}"
os_distro="${os_distro#\"}"

if [ $os_distro == "centos" ]; then
    yum install centos-release-ansible-29 -y
    yum install ansible -y    
elif [ $os_distro == "ubuntu" ]; then
    apt-add-repository ppa:ansible/ansible
    apt-get -y update
    apt-get -y install ansible
elif [ $os_distro == "rocky" ]; then
    dnf -y makecache
    dnf install -y epel-release
    dnf -y makecache
    dnf install -y ansible
elif [ $os_distro == "fedora" ]; then
    dnf -y makecache
    dnf install -y ansible
else
    echo "Unsupported OS"
fi
