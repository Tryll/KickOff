<p><a href="#" rel="nofollow"><img alt="License: Apache 2.0" src="https://img.shields.io/badge/licence-Apache%202.0-brightgreen.svg?style=flat" style="max-width:100%;"></a><img alt="Status: In-Development" src="https://img.shields.io/badge/status-in%E2%80%93development-blue.svg?style=flat"  style="max-width:100%;margin-left:5px;"  />
</p>

<p>
<b>KickOff</b> - A minimal footprint rootfs bootstrapper for embedded devices. <br/>
5,5MB squashfs xz compressed / 16MB uncompressed (buster,armhf)<br/>
<br/>
Debian rootfs based on busybox, overlay (default tmpfs) with dpkg package management.<br/>
Includes a custom light-weight "apt-get" utility for Debian repository integration and package dependency walking.<br/>

Requirement (order of precedence):
1. Prefer light-weight over compliant
2. Be Debian package management compatible
<br/>
Usage (not there yet):<br/>
1. ./kickoff.sh build buster armhf iotjs dropbear-run<br/>
2. Customize rootfs<br/>
3. ./kickoff.sh pack<br/>
<br/>
Current tested distro: Debian Buster.
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

