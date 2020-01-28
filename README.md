<p><a href="http://www.gnu.org/licenses/gpl-3.0" rel="nofollow"><img src="https://camo.githubusercontent.com/bf135a9cea09d0ea4bba410582c0e70ec8222736/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f4c6963656e73652d47504c25323076332d626c75652e737667" alt="License: GPL v3" data-canonical-src="https://img.shields.io/badge/License-GPL%20v3-blue.svg" style="max-width:100%;"></a>
</p>

<p>
<b>KickOff</b> - A minimal footprint rootfs bootstrapper for embedded devices. <br/>
5,5MB squashfs xz compressed / 16MB uncompressed (buster,armhf)<br/>
<br/>
Debian rootfs based on busybox, overlay (default tmpfs) with dpkg package management.<br/>
Includes a custom light-weight "apt-get" utility for Debian repository integration and package dependency walking.<br/>

Requirement (order of precedence):
1. Balance light-weight vs usable
2. Be Debian package management compatible

Current distro support: Debian Buster.
<br/>
Goal (not there yet):
1. kickoff.sh build [DISTOR] [ARCH] [Extra Packages]<br/>
   kickoff.sh build buster armhf iotjs dropbear-run

2. Customize rootfs directory 
3. kickoff.sh pack<br/>
   generates squashfs xz compressed.

</p>
<br/>
<p>
<b>apt-get-light</b> - A light-weight Debian package manager for embedded devices. <br/>
Supports: update, info, resolve, download and install.

Install vim and iotjs: (when renamed)<br/>
apt-get install iotjs dropbear-run
</p>
<br/>
<p>
<b>Potential devices:</b><br/>
<ul>
  <li>Wifi/PTZ Cameras (Hisilicone++)</li>
  <li>Lawnmowers (Bosch)</li>
  <li>Routers (Wifi, Wired)</li>
  <li>System-on-chip devices > 32MB RAM</li>
</ul>
</p>

