#!/bin/sh



export ARCH=armhf
export DISTRO=buster


echo Host: Ensuring qemu and binfmt are installed 
sudo apt-get install -y qemu-user-static binfmt-support busybox-static 
sudo update-binfmts  --enable qemu-arm

ROOT=rootfs
TARGET=$ROOT/bootstrap
mkdir -p $TARGET


echo Target: Downloading debian base packages
./apt-get-tiny.sh download base-files $TARGET
./apt-get-tiny.sh download busybox $TARGET
./apt-get-tiny.sh download dpkg $TARGET
./apt-get-tiny.sh download libc6 $TARGET
./apt-get-tiny.sh download libselinux1 $TARGET
./apt-get-tiny.sh download libpcre3 $TARGET
./apt-get-tiny.sh download libc-bin $TARGET
./apt-get-tiny.sh download zlib1g $TARGET
./apt-get-tiny.sh download liblzma5 $TARGET
./apt-get-tiny.sh download libbz2-1.0 $TARGET
./apt-get-tiny.sh download tar $TARGET
./apt-get-tiny.sh download libacl1 $TARGET
./apt-get-tiny.sh download libattr1 $TARGET
./apt-get-tiny.sh download libgcc1 $TARGET
./apt-get-tiny.sh download gcc-8-base $TARGET
./apt-get-tiny.sh download coreutils $TARGET


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
mkdir -p $NET/if-down.d  $NET/if-post-down.d  $NET/if-pre-up.d  $NET/if-up.d  $NET/interfaces.d
printf 'source /etc/network/interfaces.d/*\nauto lo\niface lo inet loopback\nallow-hotplug eth0\niface eth0 inet dhcp\n' > $NET/interfaces


#cp setup.sh target/rootfs/
#chroot target/rootfs /bin/busybox sh -c /setup.sh
#chroot target/rootfs /tmp/postinst





#apt-get --download-only install  base-files:armhf dpkg:armhf libselinux1:armhf libpcre3:armhf libc6:armhf busybox:armhf dropbear-bin:armhf dropbear-run udhcpc:armhf



