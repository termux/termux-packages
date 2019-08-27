TERMUX_PKG_HOMEPAGE=https://www.ettercap-project.org
TERMUX_PKG_DESCRIPTION="Comprehensive suite for MITM attacks, can sniff live connections, do content filtering on the fly and much more"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.8.3
TERMUX_PKG_SRCURL=https://github.com/Ettercap/ettercap/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d561a554562e447f4d7387a9878ba745e1aa8c4690cc4e9faaa779cfdaa61fbb
TERMUX_PKG_DEPENDS="libpcap, openssl, zlib, curl, pcre, ncurses, libiconv, libnet, libltdl, ethtool"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DENABLE_GTK=off
-DENABLE_GEOIP=off
"
