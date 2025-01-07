TERMUX_PKG_HOMEPAGE=https://www.ncftp.com/
TERMUX_PKG_DESCRIPTION="A free set of programs that use the File Transfer Protocol"
# License: Clarified Artistic
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="doc/LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.7"
TERMUX_PKG_SRCURL=https://www.ncftp.com/downloads/ncftp/ncftp-${TERMUX_PKG_VERSION}-src.tar.xz
TERMUX_PKG_SHA256=d41c5c4d6614a8eae2ed4e4d7ada6b6d3afcc9fb65a4ed9b8711344bef24f7e8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi -Iautoconf_local

	CFLAGS+=" -fcommon"

	export ac_cv_path_TAR=$TERMUX_PREFIX/bin/tar
}
