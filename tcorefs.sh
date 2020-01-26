#!/bin/sh



export ARCH=armhf
export DISTRO=buster


echo Host: Ensuring qemu and binfmt are installed 
sudo apt-get install -y qemu-user-static binfmt-support busybox-static 
sudo update-binfmts  --enable qemu-arm

ROOT=target/rootfs
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
dpkg -x $TARGET/base-files* target/rootfs
dpkg -e $TARGET/base-files* target/rootfs/tmp/

# Initate base busybox
dpkg -x $TARGET/busybox_* target/rootfs
dpkg -x $TARGET/libc6* target/rootfs
sudo /usr/sbin/chroot target/rootfs /bin/busybox --install


dpkg -x $TARGET/dpkg* target/rootfs
dpkg -x $TARGET/libselinux1* target/rootfs
dpkg -x $TARGET/libpcre3* target/rootfs
dpkg -x $TARGET/zlib1g* target/rootfs
dpkg -x $TARGET/libc-bin* target/rootfs
dpkg -x $TARGET/liblzma5* target/rootfs
dpkg -x $TARGET/libbz2-1.0* target/rootfs
dpkg -x $TARGET/tar* target/rootfs
dpkg -x $TARGET/libacl1* target/rootfs
dpkg -x $TARGET/libattr1* target/rootfs
dpkg -x $TARGET/coreutils* target/rootfs

printf '#!/bin/sh\nless $*\n' > $TARGET/../usr/bin/pager
chmod 755 $TARGET/../usr/bin/pager



# init base filesystem
sudo /usr/sbin/chroot target/rootfs /bin/sh /tmp/postinst
echo "/usr/bin/dpkg -i --force-all bootstrap/*.deb" | sudo chroot target/rootfs sh -C

# cleanup
sudo rm -rf $TARGET
sudo rm -rf $ROOT/usr/share/doc/*
sudo rm -rf $ROOT/usr/share/locale/*
sudo rm -rf $ROOT/usr/share/man/*

P=$ROOT/usr/lib/*/gconv
sudo rm $P/libCNS* $P/BIG5* $P/IBM* $P/GB* $P/libJISX0213*

du -h $ROOT



#cp setup.sh target/rootfs/
#chroot target/rootfs /bin/busybox sh -c /setup.sh
#chroot target/rootfs /tmp/postinst





#apt-get --download-only install  base-files:armhf dpkg:armhf libselinux1:armhf libpcre3:armhf libc6:armhf busybox:armhf dropbear-bin:armhf dropbear-run udhcpc:armhf



