#!/bin/bash
yum -y update
yum -y install yum-plugin-fastestmirror


rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm

yum -y --enablerepo=elrepo-kernel install kernel-ml
sudo awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
sudo grub2-set-default 0
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "reboot and ansible worker -m shell -a ' package-cleanup --oldkernels' "


