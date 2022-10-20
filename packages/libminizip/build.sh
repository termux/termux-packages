TERMUX_PKG_HOMEPAGE=https://www.winimage.com/zLibDll/minizip.html
TERMUX_PKG_DESCRIPTION="Mini zip and unzip based on zlib"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="MiniZip64_info.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.13
TERMUX_PKG_SRCURL=https://www.zlib.net/zlib-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=d14c38e313afc35a9a8760dadf26042f51ea0f5d154b0630a31da0540107fb98
TERMUX_PKG_DEPENDS="zlib"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/contrib/minizip"
	cd $TERMUX_PKG_SRCDIR
	autoreconf -fi
}
