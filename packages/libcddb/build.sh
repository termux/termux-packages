TERMUX_PKG_HOMEPAGE=http://libcddb.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A C library to access data on a CDDB server"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_SRCURL=http://prdownloads.sourceforge.net/libcddb/libcddb-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b
TERMUX_PKG_DEPENDS="libiconv"

termux_step_pre_configure() {
	autoreconf -fi
}
