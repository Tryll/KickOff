<p><a href="http://www.gnu.org/licenses/gpl-3.0" rel="nofollow"><img src="https://camo.githubusercontent.com/bf135a9cea09d0ea4bba410582c0e70ec8222736/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f4c6963656e73652d47504c25323076332d626c75652e737667" alt="License: GPL v3" data-canonical-src="https://img.shields.io/badge/License-GPL%20v3-blue.svg" style="max-width:100%;"></a>
</p>

<p>
<b>KickOff</b> - A minimal footprint rootfs bootstrapper for embedded devices. <br/>

Debian rootfs based on busybox, overlay (default tmpfs) with dpkg package management.<br/>
Includes a custom light-weight "apt-get" utility for Debian repository integration and package dependency walking.<br/>

Generated squashfs:<br/>
rootfs.xz 5525504 bytes<br/>

<b>Requirements</b>
1. Balanced on light-weight / usable
2. Be Debian package management compatible
</p>
<p>
<b>apt-get-light</b> - A Debian package manager for embedded devices. <br/>
Supports: update, info, resolve, download and install.

Install vim and iotjs:<br/>
./apt-get-light.sh install iotjs dropbear-run
</p>

