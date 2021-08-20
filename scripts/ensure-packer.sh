#!/bin/bash -x

set -o errexit
set -o nounset
set -o pipefail

yum update -y
yum install wget zip unzip -y
yum install epel-release -y
yum install qemu kvm qemu-kvm libvirt virt-install bridge-utils qemu-system-x86 -y

rm -rf /usr/sbin/packer

yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install packer
