TERMUX_PKG_HOMEPAGE=https://www.ettercap-project.org
TERMUX_PKG_DESCRIPTION="Comprehensive suite for MITM attacks, can sniff live connections, do content filtering on the fly and much more"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.3.1
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/Ettercap/ettercap/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d0c3ef88dfc284b61d3d5b64d946c1160fd04276b448519c1ae4438a9cdffaf3
TERMUX_PKG_DEPENDS="ethtool, libcurl, libiconv, libnet, libpcap, ncurses, ncurses-ui-libs, openssl, pcre, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DENABLE_GTK=off
-DENABLE_GEOIP=off
"
