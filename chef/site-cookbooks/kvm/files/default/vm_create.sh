#!/bin/bash

if [ $# -ne 5 ]; then
  echo "usage: $0 <hostname> <ip> <vcpus> <ram> <disk>"
  echo "example: $0 test01 192.168.1.101 1 1024 10"
  exit 1
fi

HOSTNAME=$1
IP=$2
VCPUS=$3
RAM=$4
DISK=$5

IMG=/var/lib/libvirt/images/${HOSTNAME}.img

if [ -f "$IMG" ];then
  echo already exists
  exit 1
fi

dd if=/dev/zero of=$IMG bs=1MiB count=`expr $DISK \* 1024`

virt-install  --connect qemu:///system \
  --name $HOSTNAME \
  --ram $RAM \
  --vcpus=$VCPUS \
  --disk path=$IMG \
  --os-variant rhel7 \
  --nographics \
  --location http://192.168.1.10/os/centos7/ \
  --extra-args "ks=http://192.168.1.10/ks/centos7/ks.php?hostname=${HOSTNAME}&ip=${IP} console=ttyS0,115200n8 serial"
