TERMUX_PKG_HOMEPAGE=https://www.ncftp.com/
TERMUX_PKG_DESCRIPTION="A free set of programs that use the File Transfer Protocol"
# License: Clarified Artistic
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="doc/LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.6
TERMUX_PKG_SRCURL=https://www.ncftp.com/downloads/ncftp/ncftp-${TERMUX_PKG_VERSION}-src.tar.xz
TERMUX_PKG_SHA256=5f200687c05d0807690d9fb770327b226f02dd86155b49e750853fce4e31098d
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"

	export ac_cv_path_TAR=$TERMUX_PREFIX/bin/tar
}
