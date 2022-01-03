#!/bin/bash -x

os_distro_raw=`awk -F '=' '/^ID=/ { print $2 }' /etc/os-release`
os_distro="${os_distro_raw%\"}"
os_distro="${os_distro#\"}"

if [ $os_distro == "centos" ]; then
    curl -o /etc/yum.repos.d/CentOS-rt.repo https://raw.githubusercontent.com/sonaproject/edgestack-image-builder/master/ansible/roles/rt/files/CentOS-rt.repo
    yum install -y kernel-rt rt-tests tuned-profiles-realtime
elif [ $os_distro == "ubuntu" ]; then
    add-apt-repository ppa:damentz/liquorix && sudo apt-get update
    apt-get install linux-image-liquorix-amd64 linux-headers-liquorix-amd64
elif [ $os_distro == "rocky" ]; then
    yum-config-manager --enable rt
    yum install -y kernel-rt rt-tests tuned-profiles-realtime
else
    echo "Unsupported OS"
fi
