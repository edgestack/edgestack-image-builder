#!/bin/bash -x

os_distro_raw=`awk -F '=' '/^ID=/ { print $2 }' /etc/os-release`
os_distro="${os_distro_raw%\"}"
os_distro="${os_distro#\"}"

if [ $os_distro == "centos" ]; then
    curl -o /etc/yum.repos.d/CentOS-rt.repo https://raw.githubusercontent.com/sonaproject/edgestack-image-builder/master/ansible/roles/rt/files/CentOS-rt.repo
    yum install -y kernel-rt rt-tests tuned-profiles-realtime
elif [ $os_distro == "ubuntu" ]; then
    echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
    wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
    sudo apt update -y && sudo apt install linux-xanmod -y
elif [ $os_distro == "rocky" ]; then
    yum-config-manager --enable rt
    yum install -y kernel-rt rt-tests tuned-profiles-realtime
else
    echo "Unsupported OS"
fi
