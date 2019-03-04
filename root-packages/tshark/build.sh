TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer and sniffer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bc4f30f5b2e94f3a696fef9de44673cdf402db90aac5299966da647f708f009e
TERMUX_PKG_DEPENDS="glib, libgpg-error, libgcrypt, libnl, libpcap, libgnutls, openssl, libiconv"
# Needed by pkg-config (since they are dependenies for libgnutls and glib)
TERMUX_PKG_BUILD_DEPENDS="pcre-dev, libnettle-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_wireshark=OFF
-DENABLE_LUA=OFF
"
