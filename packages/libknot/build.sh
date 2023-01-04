TERMUX_PKG_HOMEPAGE=https://www.knot-dns.cz/
TERMUX_PKG_DESCRIPTION="Knot DNS libraries"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.4
TERMUX_PKG_SRCURL=https://secure.nic.cz/files/knot-dns/knot-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=299e8de918f9fc7ecbe625b41cb085e47cdda542612efbd51cd5ec60deb9dd13
TERMUX_PKG_DEPENDS="libgnutls, liblmdb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-daemon
--disable-modules
--enable-utilities
"
