<b>KickOff</b> - A minimal footprint rootfs bootstrapper for embedded devices. <br/>

Debian rootfs based on busybox, overlay (default tmpfs) with dpkg package management.<br/>
Includes a custom light-weight "apt-get" utility for Debian repository integration and package dependency walking.<br/>

Generated squashfs:<br/>
rootfs.xz 5525504 bytes<br/>


<b>apt-get-light</b> - A Debian package manager for embedded devices. <br/>
Supports: update, info, resolve, download and install.

Install vim and iotjs:<br/>
./apt-get-light.sh install iotjs dropbear-run


