#!/bin/bash -x

os_distro_raw=`awk -F '=' '/^ID=/ { print $2 }' /etc/os-release`
os_distro="${os_distro_raw%\"}"
os_distro="${os_distro#\"}"

if [ $os_distro == "centos" ]; then
    yum remove -y ansible
    rm -rf /tmp/*
    rm -rf /root/*.rpm
elif [ $os_distro == "ubuntu" ]; then
    apt-get -y remove ansible
    apt-get -y autoremove
    rm -rf /tmp/*
else
    echo "Unsupported OS"
fi
