#!/bin/sh
#
# KickOff - Debian rootfs builder for embedded devices, by Amund@Tryll
#
#
# Todo:
# 1. Prettify -  Input arguments for ARCH / DISTRO
# 2. up-stream host requirements, check availablility and complain if missing
 

export ARCH=armhf
export DISTRO=buster


echo Host: Ensuring qemu and binfmt are installed 
sudo apt-get install -y qemu-user-static binfmt-support busybox-static squashfs-tools 
sudo update-binfmts  --enable qemu-arm

ROOT=rootfs
TARGET=$ROOT/bootstrap
export DEST=$TARGET
mkdir -p $TARGET


echo Target: Downloading debian base packages
./apt-get-light.sh download base-files busybox dpkg coreutils liblzma5 zlib1g libc-bin libselinux1 libbz2-1.0 libacl1 libattr1

# Bootstrap base filesytem
dpkg -x $TARGET/base-files* $ROOT
dpkg -e $TARGET/base-files* $ROOT/tmp/

# Initate base busybox
dpkg -x $TARGET/busybox_* $ROOT
dpkg -x $TARGET/libc6* $ROOT
sudo /usr/sbin/chroot $ROOT /bin/busybox --install


dpkg -x $TARGET/dpkg* $ROOT
dpkg -x $TARGET/libselinux1* $ROOT
dpkg -x $TARGET/libpcre3* $ROOT
dpkg -x $TARGET/zlib1g* $ROOT
dpkg -x $TARGET/libc-bin* $ROOT
dpkg -x $TARGET/liblzma5* $ROOT
dpkg -x $TARGET/libbz2-1.0* $ROOT
dpkg -x $TARGET/tar* $ROOT
dpkg -x $TARGET/libacl1* $ROOT
dpkg -x $TARGET/libattr1* $ROOT
dpkg -x $TARGET/coreutils* $ROOT

printf '#!/bin/sh\nless $*\n' > $ROOT/usr/bin/pager
chmod 755 $ROOT/usr/bin/pager



# init base filesystem
sudo /usr/sbin/chroot $ROOT /bin/sh /tmp/postinst
echo "/usr/bin/dpkg -i --force-all bootstrap/*.deb" | sudo chroot $ROOT sh -C

# cleanup
sudo rm -rf $TARGET
sudo rm -rf $ROOT/usr/share/doc/*
sudo rm -rf $ROOT/usr/share/locale/*
sudo rm -rf $ROOT/usr/share/man/*

P=$ROOT/usr/lib/*/gconv
sudo rm $P/libCNS* $P/BIG5* $P/IBM* $P/GB* $P/libJISX0213*

# networking
NET=$ROOT/etc/network
mkdir -p $NET/if-down.d  $NET/if-post-down.d  $NET/if-pre-up.d  $NET/if-up.d
printf 'auto lo\niface lo inet loopback\nallow-hotplug eth0\niface eth0 inet dhcp\n' > $NET/interfaces


cp apt-get-light.sh $ROOT/usr/bin/apt-get



# echo Squashing rootfs
sudo mksquashfs $ROOT tcore.rootfs.xz -b 64K -comp xz -all-root

