TERMUX_PKG_HOMEPAGE=https://www.knot-dns.cz/
TERMUX_PKG_DESCRIPTION="Knot DNS libraries"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.5
TERMUX_PKG_SRCURL=https://secure.nic.cz/files/knot-dns/knot-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=38502c1472247c955aa3329bb5722e61ca765b833e3497d71f891ebf8e77fa04
TERMUX_PKG_DEPENDS="libgnutls, liblmdb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-daemon
--disable-modules
--enable-utilities
"
