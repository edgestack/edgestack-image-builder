#!/bin/bash -x

set -o errexit
set -o nounset
set -o pipefail

yum update -y
yum install wget zip unzip -y
yum install epel-release -y
yum install qemu kvm qemu-kvm libvirt virt-install bridge-utils qemu-system-x86 -y

if command -v packer >/dev/null 2>&1; then exit 0; fi

mkdir -p .bin && cd .bin

yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install packer

cd .. && rm -rf .bin
