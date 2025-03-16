TERMUX_PKG_HOMEPAGE=https://www.ncftp.com/
TERMUX_PKG_DESCRIPTION="A free set of programs that use the File Transfer Protocol"
# License: Clarified Artistic
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="doc/LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.8"
TERMUX_PKG_SRCURL=https://www.ncftp.com/downloads/ncftp/ncftp-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=db7da662458a1643209d6869465c38ec811f8975a6ac54fd20c63a3349f7dbf4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi -Iautoconf_local

	CFLAGS+=" -fcommon"

	export ac_cv_path_TAR=$TERMUX_PREFIX/bin/tar
}
