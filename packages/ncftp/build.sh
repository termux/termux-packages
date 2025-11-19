TERMUX_PKG_HOMEPAGE=https://www.ncftp.com/
TERMUX_PKG_DESCRIPTION="A free set of programs that use the File Transfer Protocol"
# License: Clarified Artistic
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="doc/LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.ncftp.com/public_ftp/ncftp/ncftp-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=7920f884c2adafc82c8e41c46d6f3d22698785c7b3f56f5677a8d5c866396386
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"

	export ac_cv_path_TAR=$TERMUX_PREFIX/bin/tar
}
