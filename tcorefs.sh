#!/bin/sh



export ARCH=armhf
export DISTRO=buster


echo Host: Ensuring qemu and binfmt are installed 
sudo apt-get install -y qemu-user-static binfmt-support busybox-static 
sudo update-binfmts  --enable qemu-arm

mkdir -p target/packages target/rootfs target/rootfs/tmp


echo Target: Downloading debian base packages
./apt-get-tiny.sh download base-files target/packages
./apt-get-tiny.sh download busybox target/packages
./apt-get-tiny.sh download dpkg target/packages
./apt-get-tiny.sh download libselinux1 target/packages
./apt-get-tiny.sh download libpcre3 target/packages
./apt-get-tiny.sh download udhcpc target/packages
./apt-get-tiny.sh download dropbear-run target/packages
./apt-get-tiny.sh download busybox-static target/packages



# Bootstrap base filesytem
./apt-get-tiny.sh extract target/packages/base-files* target/rootfs
./apt-get-tiny.sh extract target/packages/busybox-static* target/rootfs

# Extract base prep script
cd target/rootfs/tmp
dpkg -e packages/base-files* target/rootfs/tmp


# Setup busybox-static
#cp /bin/busybox target/rootfs/bin/
#cp setup.sh target/rootfs/
#chroot target/rootfs /bin/busybox sh -c /setup.sh
#chroot target/rootfs /tmp/postinst




#apt-get --download-only install  base-files:armhf dpkg:armhf libselinux1:armhf libpcre3:armhf libc6:armhf busybox:armhf dropbear-bin:armhf dropbear-run udhcpc:armhf



